#include "DynamicRTSPServer.hh"
#include "RTSPServer.hh"
#include "RTSPCommon.hh"
#include "ProxyServerMediaSession.hh"
#include "Base64.hh"
#include "ServerMediaSession.hh"
#include "DigestAuthentication.hh"
#include <RTSPServer.hh>
#include <NetAddress.hh>
#include <GroupsockHelper.hh>
#include <liveMedia.hh>
#include <string.h>
#include <iostream>

#define DEBUG 1

DynamicRTSPServer*
DynamicRTSPServer::createNew(UsageEnvironment& env, Port ourPort,
                             UserAuthenticationDatabase* authDatabase,
                             unsigned reclamationTestSeconds)
{
    int ourSocket = setUpOurSocket(env, ourPort);
    if (ourSocket == -1) return NULL;
    
    return new DynamicRTSPServer(env, ourSocket, ourPort, authDatabase, reclamationTestSeconds);
}

RTSPServer::RTSPClientConnection* DynamicRTSPServer::createNewClientConnection(int clientSocket, struct sockaddr_in clientAddr)
{
    RTSPClientConnection *temp = new RTSPClientConnection(*this, clientSocket, clientAddr);
    
    envir() << "RTSPClient connection created! \n";
    return temp;
}

DynamicRTSPServer::DynamicRTSPServer(UsageEnvironment& env, int ourSocket,
                                     Port ourPort,
                                     UserAuthenticationDatabase* authDatabase, unsigned reclamationTestSeconds)
: RTSPServerSupportingHTTPStreaming(env, ourSocket, ourPort, authDatabase, reclamationTestSeconds)
{
}

void DynamicRTSPServer::incomingConnectionHandler(int serverSocket)
{
    RTSPServer::RTSPClientConnection *temp = (RTSPServer::RTSPClientConnection *)this->fClientConnections->getFirst();
    
    struct sockaddr_in clientAddr;
    SOCKLEN_T clientAddrLen = sizeof clientAddr;
    int clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &clientAddrLen);
    if (clientSocket < 0)
    {
        int err = envir().getErrno();
        if (err != EWOULDBLOCK)
        {
            envir().setResultErrMsg("accept() failed: ");
        }
        return;
    }
    
    if (temp != NULL)
    {
        envir().setResultErrMsg("Sorry a client is already connected. Only one authorized at a time.\n");
        
        envir().taskScheduler().disableBackgroundHandling(clientSocket);
        ::closeSocket(clientSocket);
        
        return ;
    }
    
    makeSocketNonBlocking(clientSocket);
    increaseSendBufferTo(envir(), clientSocket, 50*1024);
    
    envir() << "New Connection accepted from : " << AddressString(clientAddr).val() << "\n";
    
    (void)createNewClientConnection(clientSocket, clientAddr);
}

DynamicRTSPServer::~DynamicRTSPServer()
{
}

static ServerMediaSession* createNewSMS(UsageEnvironment& env,
                                        char const* fileName, FILE* fid); // forward

ServerMediaSession*
DynamicRTSPServer::lookupServerMediaSession(char const* streamName)
{
    FILE* fid = fopen(streamName, "rb");
    Boolean fileExists = fid != NULL;
    
    ServerMediaSession* sms = RTSPServer::lookupServerMediaSession(streamName);
    Boolean smsExists = sms != NULL;
    
    if (!fileExists)
    {
        if (smsExists)
        {
            removeServerMediaSession(sms);
        }
        return NULL;
    }
    else
    {
        if (!smsExists)
        {
            sms = createNewSMS(envir(), streamName, fid);
            addServerMediaSession(sms);
        }
        fclose(fid);
        return sms;
    }
}

// Special code for handling Matroska files:
static char newMatroskaDemuxWatchVariable;
static MatroskaFileServerDemux* demux;
static void onMatroskaDemuxCreation(MatroskaFileServerDemux* newDemux, void* /*clientData*/)
{
    demux = newDemux;
    newMatroskaDemuxWatchVariable = 1;
}
// END Special code for handling Matroska files:

#define NEW_SMS(description) do {\
char const* descStr = description\
", streamed by the Audiowire Streamer Media Server";\
sms = ServerMediaSession::createNew(env, fileName, fileName, descStr);\
} while(0)

static ServerMediaSession* createNewSMS(UsageEnvironment& env,
                                        char const* fileName, FILE* /*fid*/)
{
    // Use the file name extension to determine the type of "ServerMediaSession":
    char const* extension = strrchr(fileName, '.');
    if (extension == NULL)
        return NULL;
    
    ServerMediaSession* sms = NULL;
    Boolean const reuseSource = False;
    if (strcmp(extension, ".aac") == 0)
    {
        // Assumed to be an AAC Audio (ADTS format) file:
        NEW_SMS("AAC Audio");
        sms->addSubsession(ADTSAudioFileServerMediaSubsession::createNew(env, fileName, reuseSource));
    }
    else if (strcmp(extension, ".amr") == 0)
    {
        // Assumed to be an AMR Audio file:
        NEW_SMS("AMR Audio");
        sms->addSubsession(AMRAudioFileServerMediaSubsession::createNew(env, fileName, reuseSource));
    }
    else if (strcmp(extension, ".ac3") == 0)
    {
        // Assumed to be an AC-3 Audio file:
        NEW_SMS("AC-3 Audio");
        sms->addSubsession(AC3AudioFileServerMediaSubsession::createNew(env, fileName, reuseSource));
    }
    else if (strcmp(extension, ".m4e") == 0)
    {
        // Assumed to be a MPEG-4 Video Elementary Stream file:
        NEW_SMS("MPEG-4 Video");
        sms->addSubsession(MPEG4VideoFileServerMediaSubsession::createNew(env, fileName, reuseSource));
    }
    else if (strcmp(extension, ".264") == 0)
    {
        // Assumed to be a H.264 Video Elementary Stream file:
        NEW_SMS("H.264 Video");
        OutPacketBuffer::maxSize = 100000; // allow for some possibly large H.264 frames
        sms->addSubsession(H264VideoFileServerMediaSubsession::createNew(env, fileName, reuseSource));
    }
    else if (strcmp(extension, ".mp3") == 0)
    {
        // Assumed to be a MPEG-1 or 2 Audio file:
        NEW_SMS("MPEG-1 or 2 Audio");
        // To stream using 'ADUs' rather than raw MP3 frames, uncomment the following:
        //#define STREAM_USING_ADUS 1
        // To also reorder ADUs before streaming, uncomment the following:
        //#define INTERLEAVE_ADUS 1

        Boolean useADUs = False;
        Interleaving* interleaving = NULL;
#ifdef STREAM_USING_ADUS
        useADUs = True;
#ifdef INTERLEAVE_ADUS
        unsigned char interleaveCycle[] = {0,2,1,3}; // or choose your own...
        unsigned const interleaveCycleSize
        = (sizeof interleaveCycle)/(sizeof (unsigned char));
        interleaving = new Interleaving(interleaveCycleSize, interleaveCycle);
#endif
#endif
        sms->addSubsession(MP3AudioFileServerMediaSubsession::createNew(env, fileName, reuseSource, useADUs, interleaving));
    } else if (strcmp(extension, ".mpg") == 0) {
        // Assumed to be a MPEG-1 or 2 Program Stream (audio+video) file:
        NEW_SMS("MPEG-1 or 2 Program Stream");
        MPEG1or2FileServerDemux* demux
        = MPEG1or2FileServerDemux::createNew(env, fileName, reuseSource);
        sms->addSubsession(demux->newVideoServerMediaSubsession());
        sms->addSubsession(demux->newAudioServerMediaSubsession());
    } else if (strcmp(extension, ".vob") == 0) {
        // Assumed to be a VOB (MPEG-2 Program Stream, with AC-3 audio) file:
        NEW_SMS("VOB (MPEG-2 video with AC-3 audio)");
        MPEG1or2FileServerDemux* demux
        = MPEG1or2FileServerDemux::createNew(env, fileName, reuseSource);
        sms->addSubsession(demux->newVideoServerMediaSubsession());
        sms->addSubsession(demux->newAC3AudioServerMediaSubsession());
    } else if (strcmp(extension, ".ts") == 0) {
        // Assumed to be a MPEG Transport Stream file:
        // Use an index file name that's the same as the TS file name, except with ".tsx":
        unsigned indexFileNameLen = strlen(fileName) + 2; // allow for trailing "x\0"
        char* indexFileName = new char[indexFileNameLen];
        sprintf(indexFileName, "%sx", fileName);
        NEW_SMS("MPEG Transport Stream");
        sms->addSubsession(MPEG2TransportFileServerMediaSubsession::createNew(env, fileName, indexFileName, reuseSource));
        delete[] indexFileName;
    } else if (strcmp(extension, ".wav") == 0) {
        // Assumed to be a WAV Audio file:
        NEW_SMS("WAV Audio Stream");
        // To convert 16-bit PCM data to 8-bit u-law, prior to streaming,
        // change the following to True:
        Boolean convertToULaw = False;
        sms->addSubsession(WAVAudioFileServerMediaSubsession::createNew(env, fileName, reuseSource, convertToULaw));
    } else if (strcmp(extension, ".dv") == 0) {
        // Assumed to be a DV Video file
        // First, make sure that the RTPSinks' buffers will be large enough to handle the huge size of DV frames (as big as 288000).
        OutPacketBuffer::maxSize = 300000;
        
        NEW_SMS("DV Video");
        sms->addSubsession(DVVideoFileServerMediaSubsession::createNew(env, fileName, reuseSource));
    } else if (strcmp(extension, ".mkv") == 0 || strcmp(extension, ".webm") == 0) {
        // Assumed to be a Matroska file (note that WebM ('.webm') files are also Matroska files)
        NEW_SMS("Matroska video+audio+(optional)subtitles");
        
        // Create a Matroska file server demultiplexor for the specified file.  (We enter the event loop to wait for this to complete.)
        newMatroskaDemuxWatchVariable = 0;
        MatroskaFileServerDemux::createNew(env, fileName, onMatroskaDemuxCreation, NULL);
        env.taskScheduler().doEventLoop(&newMatroskaDemuxWatchVariable);
        
        ServerMediaSubsession* smss;
        while ((smss = demux->newServerMediaSubsession()) != NULL) {
            sms->addSubsession(smss);
        }
    }
    
    return sms;
}
