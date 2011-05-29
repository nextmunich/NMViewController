//
//  NMNavigationController.h
//  Gamedisk
//
//  Created by Benjamin Broll on 10.11.10.
//  Copyright 2010 NEXT Munich. The App Agency. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMNavigationBar.h"
#import "NMViewController.h"


@protocol NMNavigationControllerDelegate;


@interface NMNavigationController : NMViewController <NMNavigationBarDelegate> {

	// View
	UIView *contentContainerView;
	UIView *navigationBarContainerView;
	
	// State
	id<NMNavigationControllerDelegate> delegate;
	NSMutableArray *viewControllers;
	// - the navigation bar view
	NMNavigationBar *navigationBar;
	
}

@property (nonatomic, retain) IBOutlet UIView *contentContainerView;
@property (nonatomic, retain) IBOutlet UIView *navigationBarContainerView;

@property (nonatomic, assign) id<NMNavigationControllerDelegate> delegate;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *topViewController;
// currently, the tab has to be able to fill the whole width of the screen
// the tab bar's height is used as is
@property (nonatomic, retain) NMNavigationBar *navigationBar;

- (void)setViewControllers:(NSArray *)vcs animated:(BOOL)isAnimated;

- (void)pushViewController:(UIViewController *)vc animated:(BOOL)isAnimated;
- (UIViewController *)popViewControllerAnimated:(BOOL)isAnimated;
- (NSArray *)popToViewController:(UIViewController *)vc animated:(BOOL)isAnimated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)isAnimated;

@end


@protocol NMNavigationControllerDelegate <NSObject>

@optional

- (void) navigationController:(NMNavigationController *)navigationVC didPushViewController:(UIViewController *)vc;
- (void) navigationController:(NMNavigationController *)navigationVC didPopViewController:(UIViewController *)vc;

@end


@interface UIViewController (NMNavigationControllerAdditions)

@property (nonatomic, retain) NMNavigationController *nmNavigationController;

@end


