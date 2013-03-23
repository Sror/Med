//
//  AppDelegate.m
//  Med
//
//  Created by Edward on 13-3-21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "AppDelegate.h"
#import "dataBaseManager.h"
#import "RootViewController.h"
#import "ScanAllMedInfo.h"
@implementation StackScrollViewAppDelegate

@synthesize window;
@synthesize rootViewController;



+ (StackScrollViewAppDelegate *) instance {
	return (StackScrollViewAppDelegate *) [[UIApplication sharedApplication] delegate];
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	[self.window setBackgroundColor:[UIColor clearColor]];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dataBaseManager *manager = [[dataBaseManager alloc] init];
        [dataBaseManager createDataBase];
        if ([manager createTable]) {
            debugLog(@"Create DataBase Success!");
        }
        [manager release];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
    
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}
@end
