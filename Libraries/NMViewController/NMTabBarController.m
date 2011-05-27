//
//  NMTabBarController.m
//  Gamedisk
//
//  Created by Benjamin Broll on 10.11.10.
//  Copyright 2010 NEXT Munich. The App Agency. All rights reserved.
//

#import "NMTabBarController.h"


@interface NMTabBarController (Private)

- (void)showCurrentViewController;
- (void)hideCurrentViewController;

- (void)addTabBarAsSubview;

@end



@implementation NMTabBarController

#pragma mark Properties

@synthesize viewControllerContainer, tabBarContainer;
@synthesize delegate, viewControllers, selectedIndex, tabBar;


- (void)setViewControllers:(NSArray *)vcs {
	// remove previous view controller
	[self hideCurrentViewController];
	
	// remember new view controllers
	if (viewControllers != vcs) {
		[viewControllers release];
		viewControllers = [vcs retain];
	}
	[tabBar setTabsForViewControllers:viewControllers];
	
	// select first view controller
	self.selectedIndex = 0;
}

- (void)setSelectedIndex:(NSUInteger)selected {
	if (selected == NSNotFound) {
		selectedIndex = selected;
		[tabBar setSelectedTab:selected];
	} else {
		// remove previous view controller
		[self hideCurrentViewController];
		
		// remember selected index
		selectedIndex = selected;
		
		// display selected view controller
		[tabBar setSelectedTab:selected];
		[self showCurrentViewController];
	}
}

- (void)setSelectedViewController:(UIViewController *)vc {
	NSUInteger selected = [viewControllers indexOfObject:vc];
	
	if (selected != NSNotFound) {
		self.selectedIndex = selected;
	}
}

- (UIViewController *)selectedViewController {
	if (selectedIndex != NSNotFound) return [viewControllers objectAtIndex:selectedIndex];
	else return nil;
}

- (void)setTabBar:(NMTabBar *)tb {
	if (tabBar != tb) {
		tabBar.delegate = nil;
		if (tabBar.superview != nil) [tabBar removeFromSuperview];
		[tabBar release];
		
		tabBar = [tb retain];
		tabBar.delegate = self;
	}
	
	if ([self isViewLoaded]) [self addTabBarAsSubview];
}


#pragma mark Helper Methods

- (void)showCurrentViewController {
	if ([self isViewLoaded]) {
		self.selectedViewController.view.frame = viewControllerContainer.bounds;
		self.selectedViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		
		[viewControllerContainer addSubview:self.selectedViewController.view];
		[self.selectedViewController viewWillAppear:NO];
		[self.selectedViewController viewDidAppear:NO];
	}
}

- (void)hideCurrentViewController {
	if (self.selectedViewController.view.superview != nil) {
		[self.selectedViewController viewWillDisappear:NO];
		[self.selectedViewController viewDidDisappear:NO];
		[self.selectedViewController.view removeFromSuperview];
	} else if (self.selectedIndex == NSNotFound) {
		for (UIViewController* vc in viewControllers) {
			if ([vc isViewLoaded]) {
				[vc viewWillDisappear:NO];
				[vc viewDidDisappear:NO];
				[vc.view removeFromSuperview];
			}
		}
	}
}


#pragma mark Tab Bar Management

- (void)addTabBarAsSubview {
	if (tabBar != nil) {
		NSLog(@"tab bar: %@", tabBar);
		
		tabBarContainer.bounds = CGRectMake(0, 0, tabBarContainer.bounds.size.width, tabBar.bounds.size.height);
		tabBarContainer.center = CGPointMake(tabBarContainer.center.x, self.view.bounds.size.height-tabBar.bounds.size.height/2);
		viewControllerContainer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-tabBar.bounds.size.height);
		
		tabBar.frame = tabBarContainer.bounds;
		tabBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[tabBarContainer addSubview:tabBar];
		
		NSLog(@"tab bar container: %@", tabBarContainer);
		NSLog(@"tab bar: %@", tabBar);
		
		if (viewControllers != nil) {
			[tabBar setTabsForViewControllers:viewControllers];
			[tabBar setSelectedTab:self.selectedIndex];
		}
	}
}

- (void)tabBar:(NMTabBar *)tb didSelectTab:(NSUInteger)tabIndex {
	if (self.selectedIndex != tabIndex) {
		[delegate tabBarController:self willSelectIndex:tabIndex];
		self.selectedIndex = tabIndex;
		[delegate tabBarController:self didSelectIndex:tabIndex];
	} else {
		[delegate tabBarController:self popToRoot:tabIndex];
	}
}


#pragma mark Interface Orientation Management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	BOOL result = YES;
	
	for (UIViewController *vc in viewControllers) {
		result = result && [vc shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}
	
	return result;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	for (UIViewController* vc in viewControllers) {
		[vc willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	for (UIViewController* vc in viewControllers) {
		[vc didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	}
}



#pragma mark State Lifecycle

- (void)unloadState {
	[super unloadState];
	
	[viewControllers release];
	viewControllers = nil;
	
	[tabBar release];
	tabBar = nil;
}


#pragma mark View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self addTabBarAsSubview];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.selectedIndex = selectedIndex;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self hideCurrentViewController];
}

- (void)unloadViewReferences {
	[super unloadViewReferences];

	[tabBar removeFromSuperview];
	self.viewControllerContainer = nil;
	self.tabBarContainer = nil;
}

@end
