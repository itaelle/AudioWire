#include <BasicUsageEnvironment.hh>
#include <string>
#include "DynamicRTSPServer.hh"
#include "version.hh"

#define ACCESS_CONTROL 1
#define PORT 8559
#define DEFAULT_LOGIN "audiowire"
#define DEFAULT_PWD "audiowire"

int main(int argc, char** argv)
{
    TaskScheduler* scheduler = BasicTaskScheduler::createNew();
    UsageEnvironment* env = BasicUsageEnvironment::createNew(*scheduler);
    
    UserAuthenticationDatabase* authDB = NULL;
    
#ifdef ACCESS_CONTROL
    authDB = new UserAuthenticationDatabase;
    authDB->addUserRecord(DEFAULT_LOGIN, DEFAULT_PWD);
#endif
    
    RTSPServer* rtspServer;
    portNumBits rtspServerPortNum = PORT;
    
    rtspServer = DynamicRTSPServer::createNew(*env, rtspServerPortNum, authDB);
//    if (rtspServer == NULL)
//    {
//        rtspServerPortNum = 8559;
//        rtspServer = DynamicRTSPServer::createNew(*env, rtspServerPortNum, authDB);
//    }
    if (rtspServer == NULL)
    {
        *env << "Failed to create RTSP server: " << env->getResultMsg() << "\n";
        exit(1);
    }

    *env << "AudioreWire Streamer Media  Server ... started\n";
    *env << "\tversion " << MEDIA_SERVER_VERSION_STRING
    << " (using LIVE555 Streaming Media library version "
    << LIVEMEDIA_LIBRARY_VERSION_STRING << ").\n";

    std::string url = std::string (rtspServer->rtspURLPrefix());
    url = url.substr(7, url.size() - 7);

    std::string preFix = "rtsp://";
    preFix.append(DEFAULT_LOGIN);
    preFix.append(":");
    preFix.append(DEFAULT_PWD);
    preFix.append("@");

    url.insert(0, preFix);

    *env << "Play streams from this server using the URL\n\t"
	 << url.c_str() << "<filename>\nwhere <filename> is a file present in the current directory.\n";

    env->taskScheduler().doEventLoop();
    return 0;
}




