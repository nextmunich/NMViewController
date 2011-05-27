//
//  NMViewControllerAppDelegate.h
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright NEXT Munich. The App Agency. 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMTabBarController.h"


@interface NMViewControllerAppDelegate : NSObject <UIApplicationDelegate, NMTabBarControllerDelegate> {

    UIWindow *window;
	
	NMTabBarController *tabBarController;
	UIViewController *tabOneController;
	UIViewController *tabTwoController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NMTabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIViewController *tabOneController;
@property (nonatomic, retain) IBOutlet UIViewController *tabTwoController;

@end

