//
//  RRComet.m
//  PixelMapper
//
//  Created by Rus Maxham on 6/1/13.
//  Copyright (c) 2013 rrrus. All rights reserved.
//

#import "RRComet.h"
#import "PPPixel.h"
#import "PPStrip.h"

@implementation RRComet

- (id)init
{
    self = [super init];
    if (self) {
		self.startTime = CACurrentMediaTime();
        self.tailLength = (random()%20)/10.0+1;
		while (fabsf(self.speed) < 4) {
			self.speed = (random()%600-300)/10.0;
		}
		if (self.speed > 0)	self.startPosition = 0;
		else				self.startPosition = 240;
		self.speedVariance = 0.2;
        self.speedVariancePeriod = (random()%400)/10.0;
        
//        self.color = [PPPixel pixelWithHue:(random()%200)/200.0 saturation:1 luminance:1];
    }
    return self;
}

- (float)headPosition {
	CFTimeInterval now = CACurrentMediaTime();
    float speedNow1 = self.speed * (1 + sin(now/self.speedVariancePeriod*M_2_PI) * self.speedVariance*fabs(self.distance*50));
    float speedNow = self.speed * (1 + sin(now/self.speedVariancePeriod*M_2_PI) * self.speedVariance*fabs(self.distance*100)) + fabs(self.distance*100);
    if (self.distance > 0) {
        NSLog(@"speedNow1 %f newspeedNow %f self.speedVariance %f", speedNow1, speedNow, self.speedVariance*fabs(self.distance*50));
    }

	double interval = now - self.startTime;
	return self.startPosition + speedNow1*interval;
}

- (float)tailPosition {
	CFTimeInterval now = CACurrentMediaTime();
    float speedNow = self.speed * (1 + sin(now/self.speedVariancePeriod*M_2_PI) * self.speedVariance)+(fabs(self.distance*10));
	double interval = now - self.startTime - self.tailLength;
	return self.startPosition + speedNow*interval;
}

- (BOOL)drawInStrip:(PPStrip*)strip {

    float head = self.headPosition;
    float tail = self.tailPosition;

	if (head < 0 && tail < 0) return NO;
        int pixcount = strip.pixels.count; //should be 72
    
//    NSLog(@" - %d", -self.beacon.rssi);
//    if ((-self.beacon.rssi < strip.pixels.count)) {
//         pixcount = -self.beacon.rssi;
//        NSLog(@"1 - %d", pixcount);
//    }else {
//         pixcount = strip.pixels.count; //should be 72
//        NSLog(@"2 - %d", pixcount);
//
//    }
    
	if (head > pixcount && tail > pixcount) return NO;
	
	int start, end, lead;
	float leadfrac = fmodf(head, 1);
	if (self.speed > 0) {
		end = MIN(pixcount-1, floorf(head));
		start = MAX(0, ceilf(tail));
		lead = end+1;
	} else {
		end = MIN(pixcount-1, floorf(tail));
		start = MAX(0, ceilf(head));
		lead = start-1;
		leadfrac = 1-leadfrac;
	}
	float range = head-tail;
	for (int i=start; i<=end; i++) {
		float lum = ((float)i - tail)/range;
		PPPixel *pix = strip.pixels[i];
        
        if(self.beacon){
            [pix addPixel:[self.color pixelScalingLuminance:lum]];
        }
        
	}
	if (lead >= 0 && lead < pixcount) {
		PPPixel *pix = strip.pixels[lead];
        if(self.beacon){
            [pix addPixel:[self.color pixelScalingLuminance:leadfrac]];
        }
	}
	return YES;
}

@end

