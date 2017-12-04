//
//  RRMainViewController.h
//  Comets
//
//  Created by Rus Maxham on 5/20/13.
//  Copyright (c) 2013 rrrus. All rights reserved.
//

#import <EstimoteSDK/EstimoteSDK.h>

typedef enum : int
{
    ESTScanTypeBluetooth,
    ESTScanTypeBeacon
    
} ESTScanType;

@interface RRMainViewController : UIViewController

@property (nonatomic, copy)     void (^completion)(CLBeacon *);
@property (nonatomic, assign)   ESTScanType scanType;
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTUtilityManager *utilityManager;
@property (nonatomic, strong) NSMutableArray *beaconsArray;
@property NSMutableDictionary *beaconsDictionary;

- (id)initWithScanType:(ESTScanType)scanType completion:(void (^)(id))completion;

@end
