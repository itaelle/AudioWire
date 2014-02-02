#import "AWXMPPManager.h"
#import "ConversationViewController.h"
#import <AudioToolbox/AudioToolbox.h>


NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@implementation AWXMPPManager

+(AWXMPPManager*)getInstance
{
    static AWXMPPManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[AWXMPPManager alloc] init];
    });
    return sharedMyManager;
}

-(void)saveUserSettingsWithJID:(NSString *)JID andPassword:(NSString *)pwd
{
    [[NSUserDefaults standardUserDefaults] setObject:JID forKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:kXMPPmyPassword];
}

- (void)setupStream
{
    if (xmppStream != nil)
        return ;
//	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
    
	xmppReconnect = [[XMPPReconnect alloc] init];
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
    
    // Archiving
    xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingStorage];
    
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:NO];

    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppMessageArchivingStorage mainThreadManagedObjectContext];
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
    [xmppMessageArchivingModule removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	[xmppMessageArchivingModule deactivate];
    
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
    xmppMessageArchivingModule = nil;
    xmppMessageArchivingStorage = nil;
}

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
//    NSString *domain = [xmppStream.myJID domain];
	[xmppStream sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[xmppStream sendElement:presence];
}

- (BOOL)connect
{
	if (![xmppStream isDisconnected])
		return YES;
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil)
		return NO;
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];

		[alertView show];
		return NO;
	}
	return YES;
}

-(void)sendMessage:(NSString *)bodymsg toUserJID:(NSString *)userJID fromMe:(NSString *)me
{
    if (bodymsg && [bodymsg length] > 0 && userJID)
    {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:bodymsg];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:userJID];
        [message addAttributeWithName:@"sender" stringValue:me];
        [message addChild:body];

        [xmppStream sendElement:message];
    }
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

-(void)unSetupStream
{
    [self disconnect];
    [xmppvCardTempModule removeDelegate:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	// DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	// DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![xmppStream authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{    
//    if ([message isChatMessageWithBody])
//	{
//		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
//		                                                         xmppStream:xmppStream
//		                                               managedObjectContext:[self managedObjectContext_roster]];
//		
//		NSString *body = [[message elementForName:@"body"] stringValue];
//		NSString *displayName = [user displayName];
//        
//		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
//		{
//            if (self.delegate && [self.delegate respondsToSelector:@selector(messageRender:)])
//            {
//                [self.delegate performSelector:@selector(messageRender:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[[message elementForName:@"body"] stringValue], @"msg", @"me", @"sender", [NSNumber numberWithBool:YES], @"outgoing", nil]];
//            }
//		}
//    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
	if ([message isChatMessageWithBody])
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];

		NSString *body = [[message elementForName:@"body"] stringValue];
        userSentMessage = user;
        if (!userSentMessage || ![userSentMessage displayName] || [[userSentMessage displayName]length] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unknow", @"") message:[NSString stringWithFormat:@"%@", body] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
            [alert show];
            return ;
        }
		NSString *displaySenderName = [[user displayName] lowercaseString];
        NSString *displayRecipientName = [[message toStr]lowercaseString];
        
        NSLog(@"FROM : %@",  displaySenderName);
        NSLog(@"TO : %@",  displayRecipientName);
        NSLog(@"Body : %@",  body);
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageRender:)] &&
                ([self.delegate messageRender:[NSDictionary dictionaryWithObjectsAndKeys:[[message elementForName:@"body"] stringValue], @"msg", displaySenderName, @"sender",  displayRecipientName, @"to", [NSNumber numberWithBool:NO], @"outgoing", nil]] == TRUE))
            {
                return ;
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displaySenderName
                                                                    message:body
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
                alertView.tag = 4242;
                [alertView show];
            }
		}
		else
		{
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n%@", displaySenderName,body];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
	}
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex && alertView.tag == 4242)
    {
        UINavigationController *rootVC = (UINavigationController *) [[UIApplication sharedApplication].windows[0] rootViewController];
        
        if (rootVC && [rootVC isKindOfClass:[UINavigationController class]])
        {   
            ConversationViewController *conv = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
            conv.usernameSelectedFriend = [[userSentMessage displayName] lowercaseString];
            conv.closeOption = YES;
            
            UIAudioWireCustomNavigationController *nav = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:conv];
            
            if (IS_OS_7_OR_LATER)
            {
                nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                nav.navigationBar.translucent = YES;
            }
            else
            {
                nav.navigationBar.barStyle = UIBarStyleBlack;
                nav.navigationBar.translucent = NO;
            }
            
            [rootVC presentViewController:nav animated:TRUE completion:^{
            }];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_messages
{
	return [xmppMessageArchivingStorage mainThreadManagedObjectContext];
}

@end
