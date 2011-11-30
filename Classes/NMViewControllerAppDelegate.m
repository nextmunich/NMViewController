//
//  NMViewControllerAppDelegate.m
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich GmbH. The App Agency. All rights reserved.
//

#import "NMViewControllerAppDelegate.h"

#import "NMUINavigationBar.h"
#import "NMUITabBar.h"
#import "SwitchTabBar.h"



@implementation NMViewControllerAppDelegate

#pragma mark Properties

@synthesize window, nmTabBarController, nmNavigationController, tabOneController, tabTwoController, tabThreeController;


#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// setup controller titles
	tabOneController.title = @"First";
	tabTwoController.title = @"Second";
	tabThreeController.title = @"Third";
	
	// setup of NMTabBarController before view is loaded
#ifdef UITABBAR
	nmTabBarController.tabBar = [[[NMUITabBar alloc] init] autorelease];
#elif SWITCHTABBAR
	nmTabBarController.tabBar = [[[SwitchTabBar alloc] init] autorelease];
#endif
	
	nmTabBarController.viewControllers = [NSArray arrayWithObjects:tabOneController, tabTwoController, nil];
	[window addSubview:nmTabBarController.view];
	
	//tabBarController = [[UITabBarController alloc] init];
	//tabBarController.viewControllers = nmTabBarController.viewControllers;
	//[window addSubview:tabBarController.view];
	
	//nmNavigationController.navigationBar = [[[NMUINavigationBar alloc] init] autorelease];
	//[nmNavigationController pushViewController:tabOneController animated:NO];
	//[window addSubview:nmNavigationController.view];
	//[self performSelector:@selector(nmPushVC:) withObject:tabTwoController afterDelay:5];
	
	//navigationController = [[UINavigationController alloc] initWithRootViewController:tabOneController];
	//[window addSubview:navigationController.view];
	//[self performSelector:@selector(pushVC:) withObject:tabTwoController afterDelay:5];
	
    [window makeKeyAndVisible];
	
	
	//UITapGestureRecognizer *r = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)] autorelease];
	//r.numberOfTapsRequired = 2;
	//[window addGestureRecognizer:r];
	
	
	return YES;
}


- (void)nmPushVC:(UIViewController *)vc {
	[nmNavigationController pushViewController:vc animated:YES];
	/*if (vc == tabTwoController) {
		[self performSelector:_cmd withObject:tabThreeController afterDelay:5];
	}*/
}

- (void)pushVC:(UIViewController *)vc {
	[navigationController pushViewController:vc animated:YES];
	/*if (vc == tabTwoController) {
		[self performSelector:_cmd withObject:tabThreeController afterDelay:5];
	}*/
}


- (void)logNavController {
	NSLog(@"tabOne. navVC: %@", tabOneController.navigationController);
	NSLog(@"tabOne. nmNavVC: %@", tabOneController.nmNavigationController);
}


- (void)doubleTap {
	/*[navigationController setViewControllers:[NSArray arrayWithObjects:tabOneController, tabThreeController, nil]
									animated:YES];*/
	nmNavigationController.topViewController = tabThreeController;
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
	[tabThreeController release];
	[nmNavigationController release];
	[nmTabBarController release];
    [window release];
    [super dealloc];
}


@end
