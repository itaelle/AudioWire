#include "playCommon.hh"

RTSPClient* ourRTSPClient = NULL;

Medium* createClient(UsageEnvironment& env, char const* url, int verbosityLevel, char const* applicationName)
{
  extern portNumBits tunnelOverHTTPPortNum;
  return ourRTSPClient = RTSPClient::createNew(env, url, verbosityLevel, applicationName, tunnelOverHTTPPortNum);
}

void assignClient(Medium* client)
{
  ourRTSPClient = (RTSPClient*)client;
}

void getOptions(RTSPClient::responseHandler* afterFunc)
{
  ourRTSPClient->sendOptionsCommand(afterFunc, ourAuthenticator);
}

void getSDPDescription(RTSPClient::responseHandler* afterFunc)
{
  ourRTSPClient->sendDescribeCommand(afterFunc, ourAuthenticator);
}

void setupSubsession(MediaSubsession* subsession, Boolean streamUsingTCP, RTSPClient::responseHandler* afterFunc)
{
  Boolean forceMulticastOnUnspecified = False;
  ourRTSPClient->sendSetupCommand(*subsession, afterFunc, False, streamUsingTCP, forceMulticastOnUnspecified, ourAuthenticator);
}

void startPlayingSession(MediaSession* session, double start, double end, float scale, RTSPClient::responseHandler* afterFunc)
{
  ourRTSPClient->sendPlayCommand(*session, afterFunc, start, end, scale, ourAuthenticator);
}

void startPlayingSession(MediaSession* session, char const* absStartTime, char const* absEndTime, float scale, RTSPClient::responseHandler* afterFunc)
{
  ourRTSPClient->sendPlayCommand(*session, afterFunc, absStartTime, absEndTime, scale, ourAuthenticator);
}

void tearDownSession(MediaSession* session, RTSPClient::responseHandler* afterFunc)
{
  ourRTSPClient->sendTeardownCommand(*session, afterFunc, ourAuthenticator);
}

Boolean allowProxyServers = False;
Boolean controlConnectionUsesTCP = True;
Boolean supportCodecSelection = False;
char const* clientProtocolName = "RTSP";
