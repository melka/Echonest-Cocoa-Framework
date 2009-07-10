//
//  iPhoneAppDelegate.m
//  iPhone
//
//  Created by Kamel Makhloufi on 11/07/09.
//  Copyright melka 2009. All rights reserved.
//

#import "iPhoneAppDelegate.h"
#import "iPhoneViewController.h"

@implementation iPhoneAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
