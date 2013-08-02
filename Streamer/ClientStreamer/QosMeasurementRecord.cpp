//
//  QosMeasurementRecord.cpp
//  StreamerRTSP
//
//  Created by Derivery Guillaume on 7/14/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#include "QosMeasurementRecord.h"

qosMeasurementRecord::qosMeasurementRecord(struct timeval const& startTime, RTPSource* src)
: fSource(src), fNext(NULL),
kbits_per_second_min(1e20), kbits_per_second_max(0),
kBytesTotal(0.0),
packet_loss_fraction_min(1.0), packet_loss_fraction_max(0.0),
totNumPacketsReceived(0), totNumPacketsExpected(0)
{
    measurementEndTime = measurementStartTime = startTime;
    
    RTPReceptionStatsDB::Iterator statsIter(src->receptionStatsDB());
    // Assume that there's only one SSRC source (usually the case):
    RTPReceptionStats* stats = statsIter.next(True);
    if (stats != NULL) {
        kBytesTotal = stats->totNumKBytesReceived();
        totNumPacketsReceived = stats->totNumPacketsReceived();
        totNumPacketsExpected = stats->totNumPacketsExpected();
    }
}

void qosMeasurementRecord::periodicQOSMeasurement(struct timeval const& timeNow) {
    unsigned secsDiff = timeNow.tv_sec - measurementEndTime.tv_sec;
    int usecsDiff = timeNow.tv_usec - measurementEndTime.tv_usec;
    double timeDiff = secsDiff + usecsDiff/1000000.0;
    measurementEndTime = timeNow;
    
    RTPReceptionStatsDB::Iterator statsIter(fSource->receptionStatsDB());
    // Assume that there's only one SSRC source (usually the case):
    RTPReceptionStats* stats = statsIter.next(True);
    if (stats != NULL) {
        double kBytesTotalNow = stats->totNumKBytesReceived();
        double kBytesDeltaNow = kBytesTotalNow - kBytesTotal;
        kBytesTotal = kBytesTotalNow;
        
        double kbpsNow = timeDiff == 0.0 ? 0.0 : 8*kBytesDeltaNow/timeDiff;
        if (kbpsNow < 0.0) kbpsNow = 0.0; // in case of roundoff error
        if (kbpsNow < kbits_per_second_min) kbits_per_second_min = kbpsNow;
        if (kbpsNow > kbits_per_second_max) kbits_per_second_max = kbpsNow;
        
        unsigned totReceivedNow = stats->totNumPacketsReceived();
        unsigned totExpectedNow = stats->totNumPacketsExpected();
        unsigned deltaReceivedNow = totReceivedNow - totNumPacketsReceived;
        unsigned deltaExpectedNow = totExpectedNow - totNumPacketsExpected;
        totNumPacketsReceived = totReceivedNow;
        totNumPacketsExpected = totExpectedNow;
        
        double lossFractionNow = deltaExpectedNow == 0 ? 0.0
        : 1.0 - deltaReceivedNow/(double)deltaExpectedNow;
        //if (lossFractionNow < 0.0) lossFractionNow = 0.0; //reordering can cause
        if (lossFractionNow < packet_loss_fraction_min) {
            packet_loss_fraction_min = lossFractionNow;
        }
        if (lossFractionNow > packet_loss_fraction_max) {
            packet_loss_fraction_max = lossFractionNow;
        }
    }
}

qosMeasurementRecord::~qosMeasurementRecord() { delete fNext; }




















