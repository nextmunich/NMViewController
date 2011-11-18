//
//  NMTabBarController.m
//  NMViewController
//
//  Created by Benjamin Broll on 10.11.10.
//  Copyright 2010 NEXT Munich. The App Agency. All rights reserved.
//

/*
 * The BSD License
 * http://www.opensource.org/licenses/bsd-license.php
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of NEXT Munich GmbH nor the names of its contributors may
 *   be used to endorse or promote products derived from this software without
 *   specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "NMTabBarController.h"


@interface NMTabBarController (Private)

- (void)showCurrentViewController;
- (void)hideCurrentViewController;

- (void)showViewController:(UIViewController *)vc;
- (void)hideViewController:(UIViewController *)vc;

- (void)addTabBarAsSubview;

- (NSComparisonResult)compareSystemVersionWithVersion:(NSString *)version;

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
		[self showViewController:self.selectedViewController];
	}
}

- (void)hideCurrentViewController {
	if (self.selectedViewController.view.superview != nil) {
		[self hideViewController:self.selectedViewController];
	} else if (self.selectedIndex == NSNotFound) {
		for (UIViewController* vc in viewControllers) {
			if ([vc isViewLoaded]) {
				[self hideViewController:vc];
			}
		}
	}
}

- (void)showViewController:(UIViewController *)vc {
	vc.view.frame = viewControllerContainer.bounds;
	vc.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	
	// mimics the behavior of UITabBarController:
	// the VC's view is added to its container before the controller is sent the
	// -viewWillAppear: message
	[viewControllerContainer addSubview:self.selectedViewController.view];
    
    if ([self compareSystemVersionWithVersion:(@"5.0")] == NSOrderedAscending) {
        [vc viewWillAppear:NO];
        [vc viewDidAppear:NO];
    }
}

- (void)hideViewController:(UIViewController *)vc {
    if ([self compareSystemVersionWithVersion:(@"5.0")] == NSOrderedAscending) {
        [vc viewWillDisappear:NO];
    }
	// mimics the behavior of UITabBarController:
	// the VC's view is removed from the superview before it is sent
	// the -viewDidDisappear: message
	[vc.view removeFromSuperview];
    if ([self compareSystemVersionWithVersion:(@"5.0")] == NSOrderedAscending) {
        [vc viewDidDisappear:NO];
    }
}


#pragma mark Tab Bar Management

- (void)addTabBarAsSubview {
	if (tabBar != nil) {
		tabBarContainer.bounds = CGRectMake(0, 0, tabBarContainer.bounds.size.width, tabBar.bounds.size.height);
		tabBarContainer.center = CGPointMake(tabBarContainer.center.x, self.view.bounds.size.height-tabBar.bounds.size.height/2);
		viewControllerContainer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-tabBar.bounds.size.height);
		
		tabBar.frame = tabBarContainer.bounds;
		tabBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[tabBarContainer addSubview:tabBar];
		
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

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self hideCurrentViewController];
}

- (void)unloadViewReferences {
	[super unloadViewReferences];

	[tabBar removeFromSuperview];
	self.viewControllerContainer = nil;
	self.tabBarContainer = nil;
}

#pragma mark Version Helper

- (NSComparisonResult)compareSystemVersionWithVersion:(NSString *)version {
    return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch];
}

@end
