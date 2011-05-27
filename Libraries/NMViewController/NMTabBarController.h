//
//  NMTabBarController.h
//  Gamedisk
//
//  Created by Benjamin Broll on 10.11.10.
//  Copyright 2010 NEXT Munich. The App Agency. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMTabBar.h"
#import "NMViewController.h"


@protocol NMTabBarControllerDelegate;



@interface NMTabBarController : NMViewController <NMTabBarDelegate> {

	// View
	UIView* viewControllerContainer;
	UIView *tabBarContainer;
	
	// State
	id<NMTabBarControllerDelegate> delegate;
	NSMutableArray* viewControllers;
	NSUInteger selectedIndex;
	// - the tab bar view
	NMTabBar *tabBar;
	
}

@property (nonatomic, retain) IBOutlet UIView *viewControllerContainer;
@property (nonatomic, retain) IBOutlet UIView *tabBarContainer;

@property (nonatomic, assign) id<NMTabBarControllerDelegate> delegate;
@property (nonatomic, retain) NSArray* viewControllers;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) UIViewController* selectedViewController;
// currently, the tab has to be able to fill the whole width of the screen
// the tab bar's height is used as is
@property (nonatomic, retain) NMTabBar *tabBar;

@end


@protocol NMTabBarControllerDelegate <NSObject>

@optional

// only called when the user changes tabs. not called when tabBarController.selectedIndex
// is reassigned
- (void)tabBarController:(NMTabBarController*)vc willSelectIndex:(NSUInteger)tab;
- (void)tabBarController:(NMTabBarController*)vc didSelectIndex:(NSUInteger)tab;
- (void)tabBarController:(NMTabBarController*)vc popToRoot:(NSUInteger)tab;

@end
