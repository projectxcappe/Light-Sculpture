//
//  RRAppDelegate.m
//  Comets
//
//  Created by Rus Maxham on 5/20/13.
//  Copyright (c) 2013 rrrus. All rights reserved.
//

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "RRAppDelegate.h"
#import "RRMainViewController.h"
#import "Examples-Prefix.pch"

@implementation RRAppDelegate

+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    self.mainViewController = [[RRMainViewController alloc] initWithNibName:@"RRMainViewController_iPhone" bundle:nil];
	} else {
	    self.mainViewController = [[RRMainViewController alloc] initWithNibName:@"RRMainViewController_iPad" bundle:nil];
	}
	self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
	UIApplication.sharedApplication.idleTimerDisabled = YES;
    return YES;
    
    //estimote
    
    //    NSLog(@"ESTAppDelegate: APP ID and APP TOKEN are required to connect to your beacons and make Estimote API calls.");
    [ESTConfig setupAppID:@"metro-app-l49" andAppToken:@"8c2ccced36eb0661899e3ecc0866d23e"];
    
    // Register for remote notificatons related to Estimote Remote Beacon Management.
    if (IS_OS_8_OR_LATER)
    {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeNone);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

//estimote
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // After device is registered in iOS to receive Push Notifications,
    // device token has to be sent to Estimote Cloud.
    
    ESTRequestRegisterDevice *request = [[ESTRequestRegisterDevice alloc] initWithDeviceToken:deviceToken];
    [request sendRequestWithCompletion:^(NSError *error) {
        
    }];
}

//estimote
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Verify if push is comming from Estimote Cloud and is related
    // to remote beacon management
    if ([ESTBulkUpdater verifyPushNotificationPayload:userInfo])
    {
        // pending settings are fetched and performed automatically
        // after startWithCloudSettingsAndTimeout: method call
        [[ESTBulkUpdater sharedInstance] startWithCloudSettingsAndTimeout:60 * 60];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
