//
//  RRMainViewController.m
//  Comets
//
//  Created by Rus Maxham on 5/20/13.
//  Copyright (c) 2013 rrrus. All rights reserved.
//

#import "HLDeferred.h"
#import "PPDeviceRegistry.h"
#import "PPPixel.h"
#import "PPStrip.h"
#import "RRAppDelegate.h"
#import "RRComet.h"
#import "RRForEach.h"
#import "RRMainViewController.h"

INIT_LOG_LEVEL_INFO

@interface RRMainViewController () <PPFrameDelegate, UIGestureRecognizerDelegate, ESTBeaconManagerDelegate, ESTUtilityManagerDelegate> //etimote delegates added
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *comets;
@property (nonatomic, assign) uint32_t numStrips;
@end


@implementation RRMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	PPDeviceRegistry.sharedRegistry.frameDelegate = self;
	[PPDeviceRegistry.sharedRegistry startPushing];

    //comet
	self.numStrips = 8;
	self.comets = NSMutableArray.array;
	for (int i=0; i<self.numStrips; i++) {
		[self.comets addObject:NSMutableArray.array];
	}

    //estimote
    self.scanType = ESTScanTypeBeacon;
    self.completion = [self.completion copy]; //why copy
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.utilityManager = [[ESTUtilityManager alloc] init];
    self.utilityManager.delegate = self;
    
    self.beaconDict = [NSMutableDictionary new];
    self.beaconsArray = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated {
    //estimote
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                     identifier:@"EstimoteSampleRegion"];
    [self startRangingBeacons];
}

- (void)viewDidUnload {
	PPDeviceRegistry.sharedRegistry.frameDelegate = nil;
	[self setImageView:nil];
	[super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //estimote
    [self.beaconManager stopRangingBeaconsInRegion:self.region];
    [self.utilityManager stopEstimoteBeaconDiscovery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Estimote Methods

- (void)beaconManager:(id)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Ranging error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}

- (void)beaconManager:(id)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Monitoring error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}

- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
    for (int i=0; i<[beacons count]; i++) {
//
//        BubbleObject *bubbleObject = [BubbleObject new];
//
        CLBeacon *beacon = [beacons objectAtIndex:i];
        NSLog(@"beacon %@", beacon);
//        //if dictionary doesn't contain the found beacon add it.
//        //otherwise just update the beacon
//        if (!self.beaconDict[beacon.major]) {
//
//            [bubbleObject setBeacon:beacon];
//            [bubbleObject setUuid:[beacon.major stringValue]];
//
//            //add color but remove it from the list
//            NSLog(@"Colors %@", [self.colors lastObject]);
//            [bubbleObject setColor:[self.colors lastObject]];
//            [self.colors removeObject:[self.colors lastObject]];
//
//            [bubbleObject setPosition:[self.beaconDict count]+1];
//
//            //add beacon to dict
//            [self.beaconDict setObject:bubbleObject forKey:beacon.major];
//
//        }else{
//            bubbleObject = [self.beaconDict objectForKey:beacon.major];
//            [bubbleObject setBeacon:beacon];
//            [self.beaconDict setObject:bubbleObject forKey:beacon.major];
//        }
//
//        NSLog(@"Beacons %@", [self.beaconDict description]);
    }
    
    [self updateBeacons];
}

- (void)updateBeacons {
    
}

- (void)utilityManager:(ESTUtilityManager *)manager didDiscoverBeacons:(NSArray *)beacons
{
    
}

-(void)startRangingBeacons
{
//    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
//    {
//        [self.beaconManager requestAlwaysAuthorization];
//        [self.beaconManager startRangingBeaconsInRegion:self.region];
//    }
//    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
//    {
        [self.beaconManager startRangingBeaconsInRegion:self.region];
//    }
//    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
//                                                        message:@"You have denied access to location services. Change this in app settings."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//
//        [alert show];
//    }
//    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
//                                                        message:@"You have no access to location services."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//
//        [alert show];
//    }
}

#pragma mark - PPFrameDelegate

- (void)renderComets {
	NSArray *strips = PPDeviceRegistry.sharedRegistry.strips;
	if (strips.count >= self.numStrips) {
		for (NSUInteger s=0; s<self.numStrips; s++) {
			PPStrip *strip = strips[s];
			for (int i=0; i<strip.pixels.count; i++) {
				PPPixel *pix = strip.pixels[i];
				pix.red = pix.green = pix.blue = 0;
			}
			NSMutableArray *stripComets = self.comets[s];
			while (stripComets.count < 10) {
				RRComet *comet = RRComet.alloc.init;
				[stripComets addObject:comet];
			}
			[stripComets.copy forEach:^(RRComet *comet, NSUInteger idx, BOOL *stop) {
				if (![comet drawInStrip:strip]) [stripComets removeObject:comet];
			}];
			strip.touched = YES;
		}
	}
}


- (HLDeferred*)pixelPusherRender {
#if 0
	__block HLDeferred* deferred = HLDeferred.new;
	dispatch_async(your_worker_queue, ^{
		// do your rendering stuff here
		dispatch_async(dispatch_get_main_queue(), ^{
			[deferred takeResult:nil];
		});
	});
	return deferred;
#else
	[self renderComets];
	return nil;
#endif
}

@end


