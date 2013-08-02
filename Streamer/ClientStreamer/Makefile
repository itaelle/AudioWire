INCLUDES = -I../Lib/UsageEnvironment/include -I../Lib/groupsock/include -I../Lib/liveMedia/include -I../Lib/BasicUsageEnvironment/include
# Default library filename suffixes for each library that we link with.  The "config.*" file might redefine these later.
libliveMedia_LIB_SUFFIX = $(LIB_SUFFIX)
libBasicUsageEnvironment_LIB_SUFFIX = $(LIB_SUFFIX)
libUsageEnvironment_LIB_SUFFIX = $(LIB_SUFFIX)
libgroupsock_LIB_SUFFIX = $(LIB_SUFFIX)
##### Change the following for your environment:
COMPILE_OPTS =		$(INCLUDES) -I. -O -DSOCKLEN_T=socklen_t -DXLOCALE_NOT_USED=1
C =			c
C_COMPILER =		gcc
C_FLAGS =		$(COMPILE_OPTS) -DUSE_OUR_BZERO=1 -D__CYGWIN__
CPP =			cpp
CPLUSPLUS_COMPILER =	c++
CPLUSPLUS_FLAGS =	$(COMPILE_OPTS) -Wall -DBSD=1
OBJ =			o
LINK =			c++ -o 
LINK_OPTS =		-L.
CONSOLE_LINK_OPTS =	$(LINK_OPTS)
LIBRARY_LINK =		ld -o 
LIBRARY_LINK_OPTS =	$(LINK_OPTS) -r -Bstatic
LIB_SUFFIX =			a
LIBS_FOR_CONSOLE_APPLICATION =
LIBS_FOR_GUI_APPLICATION =
EXE =
##### End of variables to change

#UNICAST_RECEIVER_APPS = myClientRTSPStreamerMac$(EXE)
#UNICAST_RECEIVER_APPS_LINUX = myClientRTSPStreamerLinux$(EXE)
#UNICAST_APPS = $(UNICAST_RECEIVER_APPS)

OS := $(shell uname)
ifeq ($(OS), Darwin)
MEDIA_SERVER = myClientRTSPStreamerMac$(EXE)
else
OS := $(shell uname -o)
endif

ifeq ($(OS), Linux)
MEDIA_SERVER = myClientRTSPStreamerLinux$(EXE)
endif
ifeq ($(OS), GNU/Linux)
MEDIA_SERVER = myClientRTSPStreamerLinux$(EXE)
endif

ifeq ($(OS), Cygwin)
MEDIA_SERVER = myClientRTSPStreamerCygwin$(EXE)
endif

ALL = $(MEDIA_SERVER)
all: $(ALL)

.$(C).$(OBJ):
	$(C_COMPILER) -c $(C_FLAGS) $<
.$(CPP).$(OBJ):
	$(CPLUSPLUS_COMPILER) -c $(CPLUSPLUS_FLAGS) $<

OPEN_RTSP_OBJS    = openRTSP.$(OBJ) playCommon.$(OBJ) QosMeasurementRecord.$(OBJ)

QosMeasurementRecord.$(CPP):		QosMeasurementRecord.h
openRTSP.$(CPP):	playCommon.hh
playCommon.$(CPP):	playCommon.hh

USAGE_ENVIRONMENT_DIR = ../Lib/UsageEnvironment
USAGE_ENVIRONMENT_LIB = $(USAGE_ENVIRONMENT_DIR)/libUsageEnvironment.$(libUsageEnvironment_LIB_SUFFIX)
USAGE_ENVIRONMENT_LIB_LINUX = $(USAGE_ENVIRONMENT_DIR)/libUsageEnvironment_linux.$(libUsageEnvironment_LIB_SUFFIX)
USAGE_ENVIRONMENT_LIB_CYGWIN = $(USAGE_ENVIRONMENT_DIR)/libUsageEnvironment_cygwin.$(libUsageEnvironment_LIB_SUFFIX)

BASIC_USAGE_ENVIRONMENT_DIR = ../Lib/BasicUsageEnvironment
BASIC_USAGE_ENVIRONMENT_LIB = $(BASIC_USAGE_ENVIRONMENT_DIR)/libBasicUsageEnvironment.$(libBasicUsageEnvironment_LIB_SUFFIX)
BASIC_USAGE_ENVIRONMENT_LIB_LINUX = $(BASIC_USAGE_ENVIRONMENT_DIR)/libBasicUsageEnvironment_linux.$(libBasicUsageEnvironment_LIB_SUFFIX)
BASIC_USAGE_ENVIRONMENT_LIB_CYGWIN = $(BASIC_USAGE_ENVIRONMENT_DIR)/libBasicUsageEnvironment_cygwin.$(libBasicUsageEnvironment_LIB_SUFFIX)

LIVEMEDIA_DIR = ../Lib/liveMedia
LIVEMEDIA_LIB = $(LIVEMEDIA_DIR)/libliveMedia.$(libliveMedia_LIB_SUFFIX)
LIVEMEDIA_LIB_LINUX = $(LIVEMEDIA_DIR)/libliveMedia_linux.$(libliveMedia_LIB_SUFFIX)
LIVEMEDIA_LIB_CYGWIN = $(LIVEMEDIA_DIR)/libliveMedia_cygwin.$(libliveMedia_LIB_SUFFIX)

GROUPSOCK_DIR = ../Lib/groupsock
GROUPSOCK_LIB = $(GROUPSOCK_DIR)/libgroupsock.$(libgroupsock_LIB_SUFFIX)
GROUPSOCK_LIB_LINUX = $(GROUPSOCK_DIR)/libgroupsock_linux.$(libgroupsock_LIB_SUFFIX)
GROUPSOCK_LIB_CYGWIN = $(GROUPSOCK_DIR)/libgroupsock_cygwin.$(libgroupsock_LIB_SUFFIX)


LOCAL_LIBS =	$(LIVEMEDIA_LIB) $(GROUPSOCK_LIB) \
		$(BASIC_USAGE_ENVIRONMENT_LIB) $(USAGE_ENVIRONMENT_LIB)
LOCAL_LIBS_LINUX =	$(LIVEMEDIA_LIB_LINUX) $(GROUPSOCK_LIB_LINUX) \
			$(BASIC_USAGE_ENVIRONMENT_LIB_LINUX) $(USAGE_ENVIRONMENT_LIB_LINUX)
LOCAL_LIBS_CYGWIN =	$(LIVEMEDIA_LIB_CYGWIN) $(GROUPSOCK_LIB_CYGWIN) \
			$(BASIC_USAGE_ENVIRONMENT_LIB_CYGWIN) $(USAGE_ENVIRONMENT_LIB_CYGWIN)
	
			
LIBS =			$(LOCAL_LIBS) $(LIBS_FOR_CONSOLE_APPLICATION)
LIBS_LINUX = 		$(LOCAL_LIBS_LINUX) $(LIBS_FOR_CONSOLE_APPLICATION)
LIBS_CYGWIN = 		$(LOCAL_LIBS_CYGWIN) $(LIBS_FOR_CONSOLE_APPLICATION)


myClientRTSPStreamerLinux$(EXE):	$(OPEN_RTSP_OBJS) $(LOCAL_LIBS_LINUX)
	$(LINK)$@ $(CONSOLE_LINK_OPTS) $(OPEN_RTSP_OBJS) $(LIBS_LINUX)

myClientRTSPStreamerMac$(EXE):	$(OPEN_RTSP_OBJS) $(LOCAL_LIBS)
	$(LINK)$@ $(CONSOLE_LINK_OPTS) $(OPEN_RTSP_OBJS) $(LIBS)

myClientRTSPStreamerCygwin$(EXE):	$(OPEN_RTSP_OBJS) $(LOCAL_LIBS_CYGWIN)
	$(LINK)$@ $(CONSOLE_LINK_OPTS) $(OPEN_RTSP_OBJS) $(LIBS_CYGWIN)
	
clean:
	-rm -rf *.$(OBJ) $(ALL) core *.core *~ include/*~

re: clean all

install: $(ALL)
	  install -d $(DESTDIR)/usr/local/bin
	  install -m 755 $(ALL) $(DESTDIR)/usr/local/bin

##### Any additional, platform-specific rules come here:
