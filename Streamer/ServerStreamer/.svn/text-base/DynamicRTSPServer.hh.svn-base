#ifndef _DYNAMIC_RTSP_SERVER_HH
#define _DYNAMIC_RTSP_SERVER_HH

#ifndef _RTSP_SERVER_SUPPORTING_HTTP_STREAMING_HH
#include "RTSPServerSupportingHTTPStreaming.hh"
#endif

#include <vector>

class DynamicRTSPServer: public RTSPServerSupportingHTTPStreaming
{
    std::vector<RTSPServer::RTSPClientConnection*> listClients_;
    
public:
    static DynamicRTSPServer* createNew(UsageEnvironment& env, Port ourPort,
                                        UserAuthenticationDatabase* authDatabase,
                                        unsigned reclamationTestSeconds = 65);
    
protected:
    DynamicRTSPServer(UsageEnvironment& env, int ourSocket, Port ourPort,
                      UserAuthenticationDatabase* authDatabase, unsigned reclamationTestSeconds);
    virtual RTSPServer::RTSPClientConnection*
    createNewClientConnection(int clientSocket, struct sockaddr_in clientAddr);
    
    virtual ~DynamicRTSPServer();
    
protected: // redefined virtual functions
    
    virtual ServerMediaSession* lookupServerMediaSession(char const* streamName);
    virtual void incomingConnectionHandler(int serverSocket);
    
};

#endif
