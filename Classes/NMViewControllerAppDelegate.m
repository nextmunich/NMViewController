//
//  NMViewControllerAppDelegate.m
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright NEXT Munich. The App Agency. 2011. All rights reserved.
//

#import "NMViewControllerAppDelegate.h"

#import "NMUITabBar.h"



@implementation NMViewControllerAppDelegate

#pragma mark Properties

@synthesize window, tabBarController, tabOneController, tabTwoController;


#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// setup controller titles
	tabOneController.title = @"First";
	tabTwoController.title = @"Second";
	
	// setup of NMTabBarController before view is loaded
	tabBarController.tabBar = [[[NMUITabBar alloc] init] autorelease];
	tabBarController.viewControllers = [NSArray arrayWithObjects:tabOneController, tabTwoController, nil];
	
    // Override point for customization after application launch.
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


#pragma mark Tab Bar Controller Delegate

- (void)tabBarController:(NMTabBarController *)vc willSelectIndex:(NSUInteger)tab {
	NSLog(@"willSelect: %d", tab);
}

- (void)tabBarController:(NMTabBarController *)vc didSelectIndex:(NSUInteger)tab {
	NSLog(@"didSelect: %d", tab);
}

- (void)tabBarController:(NMTabBarController *)vc popToRoot:(NSUInteger)tab {
	NSLog(@"popToRoot: %d", tab);
}


- (void)dealloc {
	[tabOneController release];
	[tabTwoController release];
	[tabBarController release];
    [window release];
    [super dealloc];
}


@end
