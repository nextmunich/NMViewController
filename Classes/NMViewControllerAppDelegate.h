//
//  NMViewControllerAppDelegate.h
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich GmbH. The App Agency. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMNavigationController.h"
#import "NMTabBarController.h"


@interface NMViewControllerAppDelegate : NSObject <UIApplicationDelegate, NMTabBarControllerDelegate> {

    UIWindow *window;
	
	NMTabBarController *nmTabBarController;
	NMNavigationController *nmNavigationController;
	UIViewController *tabOneController;
	UIViewController *tabTwoController;
	UIViewController *tabThreeController;
	
	UITabBarController *tabBarController;
	UINavigationController *navigationController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NMTabBarController *nmTabBarController;
@property (nonatomic, retain) IBOutlet NMNavigationController *nmNavigationController;
@property (nonatomic, retain) IBOutlet UIViewController *tabOneController;
@property (nonatomic, retain) IBOutlet UIViewController *tabTwoController;
@property (nonatomic, retain) IBOutlet UIViewController *tabThreeController;

@end

