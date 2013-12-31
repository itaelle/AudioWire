//
//  AWXMPPManager.h
//  iPhoneXMPP
//
//  Created by Guilaume Derivery on 27/12/13.
//
//

#import <Foundation/Foundation.h>
#import "DDLog.h"
#import "XMPPFramework.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"

@protocol AWXMPPManagerDelegate <NSObject>

@optional
-(void)messageRender:(NSDictionary *)infoMsg;
@end

@interface AWXMPPManager : NSObject
{
    XMPPUserCoreDataStorageObject *userSentMessage;
    
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
}

@property (weak, nonatomic) id<AWXMPPManagerDelegate> delegate;

+(AWXMPPManager*)getInstance;
-(void)sendMessage:(NSString *)bodymsg toUserJID:(NSString *)userJID;
-(void)saveUserSettingsWithJID:(NSString *)JID andPassword:(NSString *)pwd;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSManagedObjectContext *)managedObjectContext_messages;

- (BOOL)connect;
- (void)disconnect;

- (void)setupStream;
- (void)unSetupStream;
- (void)teardownStream;

@end
