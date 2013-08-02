#include "liveMedia.hh"

#define myClientRTSPStreamer
#ifndef __MYCLIENTRTSPSTREAMER__

#if defined(__WIN32__) || defined(_WIN32)
#define snprintf _snprintf
#else
#include <signal.h>
#define USE_SIGNALS 1
#endif

#define DEBUG 1

// Variables

// Forward function definitions:
bool usage(int count, char **argv);
void continueAfterClientCreation0(RTSPClient* client);
void continueAfterClientCreation1();
void continueAfterOPTIONS(RTSPClient* client, int resultCode, char* resultString);
void continueAfterDESCRIBE(RTSPClient* client, int resultCode, char* resultString);
void continueAfterSETUP(RTSPClient* client, int resultCode, char* resultString);
void continueAfterPLAY(RTSPClient* client, int resultCode, char* resultString);
void continueAfterTEARDOWN(RTSPClient* client, int resultCode, char* resultString);
void setupStreams();
void closeMediaSinks();
void subsessionAfterPlaying(void* clientData);
void subsessionByeHandler(void* clientData);
void sessionAfterPlaying(void* clientData = NULL);
void sessionTimerHandler(void* clientData);
void shutdown(int exitCode = 1);
void signalHandlerShutdown(int sig);
void checkForPacketArrival(void* clientData);
void checkInterPacketGaps(void* clientData);
void beginQOSMeasurement(MediaSession *session, TaskToken qosMeasurementTimerTask, unsigned int qosMeasurementIntervalMS, UsageEnvironment *env);


//
// Communication with external static libraries : liveMedia, groupSock
// UsageEnvironment, BasicUsageEnvironment
//
extern Medium* createClient(UsageEnvironment& env, char const* URL, int verbosityLevel, char const* applicationName);
extern void assignClient(Medium* client);
extern RTSPClient* ourRTSPClient;
extern SIPClient* ourSIPClient;

extern void getOptions(RTSPClient::responseHandler* afterFunc);

extern void getSDPDescription(RTSPClient::responseHandler* afterFunc);

extern void setupSubsession(MediaSubsession* subsession, Boolean streamUsingTCP, RTSPClient::responseHandler* afterFunc);

extern void startPlayingSession(MediaSession* session, double start, double end, float scale, RTSPClient::responseHandler* afterFunc);

extern void startPlayingSession(MediaSession* session, char const* absStartTime, char const* absEndTime, float scale, RTSPClient::responseHandler* afterFunc);
  // For playing by 'absolute' time (using strings of the form "YYYYMMDDTHHMMSSZ" or "YYYYMMDDTHHMMSS.<frac>Z"

extern void tearDownSession(MediaSession* session, RTSPClient::responseHandler* afterFunc);

extern Authenticator* ourAuthenticator;
extern Boolean allowProxyServers;
extern Boolean controlConnectionUsesTCP;
extern Boolean supportCodecSelection;
extern char const* clientProtocolName;
extern unsigned statusCode;

#endif __MYCLIENTRTSPSTREAMER__

