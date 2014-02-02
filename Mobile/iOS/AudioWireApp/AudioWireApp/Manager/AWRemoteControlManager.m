#import "AWRemoteControlManager.h"

@implementation AWRemoteControlManager

+(AWRemoteControlManager*)getInstance
{
    static AWRemoteControlManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[AWRemoteControlManager alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        messages = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)connectToAWHost:(NSString *)hostIp cb_connect:(void(^)(BOOL ok))cb_connect_ cb_receive:(void(^)(NSString *msg))cb_receive_
{
    NSLog(@"Connection...");
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)hostIp, [PORT_REMOTE intValue], &readStream, &writeStream);
    
    CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket,
                            kCFBooleanTrue);
    CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket,
                             kCFBooleanTrue);
	
    inputStream = (__bridge NSInputStream *)readStream;
	outputStream = (__bridge NSOutputStream *)writeStream;

	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream open];
	[outputStream open];
    
    callBackConnection = nil;
    callBackConnection = cb_connect_;
    
    callBackReceiveMsg = nil;
    callBackReceiveMsg = cb_receive_;
}

-(void)sendCommand:(AWRemoteCommand)command
{
    NSString *commandString = nil;
    
    switch (command)
    {
        case AWPlay:
            commandString = AWPLAY;
            break;
        case AWPause:
            commandString = AWPAUSE;
            break;
        case AWStop:
            commandString = AWSTOP;
            break;
        case AWPrev:
            commandString = AWPREV;
            break;
        case AWNext:
            commandString = AWNEXT;
            break;
        case AWShuffle:
            commandString = AWSHUFFLE;
            break;
        case AWRepeat:
            commandString = AWREPEAT;
            break;
        default:
            break;
    }
    if (commandString)
    {
        NSData *data = [[NSData alloc] initWithData:[commandString dataUsingEncoding:NSASCIIStringEncoding]];
     	[outputStream write:[data bytes] maxLength:[data length]];
    }
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	NSLog(@"stream event %i", streamEvent);
    
	switch (streamEvent)
    {
		case NSStreamEventOpenCompleted:
            
			NSLog(@"!!!! Stream opened !!!!");
            if (callBackConnection)
                callBackConnection(YES);
			break;
            
		case NSStreamEventHasBytesAvailable:
            
			if (theStream == inputStream)
            {
				uint8_t buffer[1024];
				int len;
				
				while ([inputStream hasBytesAvailable])
                {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
                    {
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						if (nil != output)
                        {
							NSLog(@"server said: %@", output);
							[self messageReceived:output];
						}
					}
				}
			}
			break;
			
		case NSStreamEventErrorOccurred:
			
			NSLog(@"Event error occurred");
            if (callBackConnection)
                callBackConnection(NO);
			break;
			
		case NSStreamEventEndEncountered:

			NSLog(@"EndEncountered");

            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            //            [theStream release];
            theStream = nil;

            if (callBackDisconnection)
                callBackDisconnection(YES);
			break;
            
		default:
			NSLog(@"Unknown event");
	}
}

-(void)discconnectFromAWHost:(void(^)(BOOL ok))cb_disconnection
{
    NSLog(@"Disconnection...");
    [inputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    callBackDisconnection = nil;
    callBackDisconnection = cb_disconnection;
}

- (void) messageReceived:(NSString *)message
{
	[messages addObject:message];

    if (callBackReceiveMsg)
        callBackReceiveMsg(message);
}

@end
