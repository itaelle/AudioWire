//
//  QosMeasurementRecord.h
//  StreamerRTSP
//
//  Created by Derivery Guillaume on 7/14/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#ifndef __StreamerRTSP__QosMeasurementRecord__
#define __StreamerRTSP__QosMeasurementRecord__

#include <iostream>
#include "liveMedia.hh"

class qosMeasurementRecord
{
public:
    qosMeasurementRecord(struct timeval const& startTime, RTPSource* src);
    
    virtual ~qosMeasurementRecord();
    
    void periodicQOSMeasurement(struct timeval const& timeNow);
    
public:
    RTPSource* fSource;
    qosMeasurementRecord* fNext;
    
public:
    struct timeval measurementStartTime, measurementEndTime;
    double kbits_per_second_min, kbits_per_second_max;
    double kBytesTotal;
    double packet_loss_fraction_min, packet_loss_fraction_max;
    unsigned totNumPacketsReceived, totNumPacketsExpected;
};

#endif /* defined(__StreamerRTSP__QosMeasurementRecord__) */
