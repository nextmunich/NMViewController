//
//  NMNavigationController.m
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

#import "NMNavigationController.h"

#import <objc/runtime.h>

#import "NMViewController.h"


#define UIKIT_FORWARDS_APPEARANCE() [UIViewController instancesRespondToSelector:@selector(automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers)]

#define ANIMATIONDURATION 0.3 // in seconds


typedef enum {
	NMNavigationControllerPositionCurrent,
	NMNavigationControllerPositionBack,
	NMNavigationControllerPositionNext
} NMNavigationControllerPosition;

typedef enum {
	NMNavigationControllerTransitionNone,
	NMNavigationControllerTransitionPush,
	NMNavigationControllerTransitionPop
} NMNavigationControllerTransition;


@interface NMNavigationController (Private)

- (void)transition:(NMNavigationControllerTransition)transition
  toViewController:(UIViewController *)destinationController animated:(BOOL)isAnimated;

- (void)addViewControllers:(NSArray *)vcs;
- (void)removeAllViewControllers;
- (void)removeViewControllersUpToViewController:(UIViewController *)vc;
- (void)removeViewController:(UIViewController *)vc;
- (void)applyPostion:(NMNavigationControllerPosition)position toViewController:(UIViewController *)vc;

- (void)addNavigationBarAsSubview;

- (NSComparisonResult)compareSystemVersionWithVersion:(NSString *)version;

@end



@implementation NMNavigationController

#pragma mark Properties

@synthesize contentContainerView, navigationBarContainerView;
@synthesize delegate, viewControllers, navigationBar;

- (void)setViewControllers:(NSArray *)vcs {
	[self setViewControllers:vcs animated:NO];
}

- (void) setViewControllers:(NSArray *)vcs animated:(BOOL)isAnimated {
	// prevent a stack that contains duplicates
	NSSet *vcsWithoutDuplicates = [NSSet setWithArray:vcs];
	if ([vcsWithoutDuplicates count] < [vcs count]) {
		[NSException raise:@"NSInvalidArgumentException"
					format:@"Setting a view controller stack including the same controller multiple times is not supported (%@)", vcs];
	}
	
	// prevent an empty stack
	if ([vcs count] == 0) {
		[NSException raise:@"NSInvalidArgumentException"
					format:@"Setting an empty view controller stack is not supported (%@)", vcs];
	}
	
	// update the navigation bar
	[navigationBar setNavigationStack:vcs animated:isAnimated];
	
	if ([self isViewLoaded] && self.view.superview != nil) {
		if ([viewControllers count] == 0) {
			// we cannot animate a transition from an empty stack
			// --> just make the top controller visible
			[self addViewControllers:vcs];
			
			[navigationBar setNavigationStack:viewControllers animated:NO];
			
			UIViewController *destinationController = [vcs lastObject];
			
			[self applyPostion:NMNavigationControllerPositionCurrent toViewController:destinationController];
			destinationController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
			[self.contentContainerView addSubview:destinationController.view];
			if (!UIKIT_FORWARDS_APPEARANCE()) [destinationController viewWillAppear:NO];
			if (!UIKIT_FORWARDS_APPEARANCE()) [destinationController viewDidAppear:NO];
		} else {
			// animated transition from a non-empty stack to a non-empty stack
			// --> determine transition information and animate if necessary
			
			// determine how we transition to the new topViewController
			NMNavigationControllerTransition transition;
			if (![viewControllers containsObject:[vcs lastObject]]) {
				transition = NMNavigationControllerTransitionPush;
			} else if ([viewControllers lastObject] == [vcs lastObject]) {
				transition = NMNavigationControllerTransitionNone;
			} else {
				transition = NMNavigationControllerTransitionPop;
			}
			
			// replace previous stack by new stack but keep topViewController for a
			// (potentially) necessary transition
			[self removeViewControllersUpToViewController:[viewControllers lastObject]];
			for (NSUInteger controllerIndex = 0; controllerIndex < [vcs count]; controllerIndex++) {
				UIViewController *vc = [vcs objectAtIndex:controllerIndex];
				vc.nmNavigationController = self;
				[viewControllers insertObject:vc atIndex:controllerIndex];
			}
			
			// perform the requested transition
			if (transition == NMNavigationControllerTransitionNone) {
				// both arrays contained the same last object so that it's now present
				// twice - remove one of the duplicates
				[viewControllers removeLastObject];
			} else {
				UIViewController *destinationController = [viewControllers objectAtIndex:[viewControllers count]-2];
				[self transition:transition toViewController:destinationController animated:isAnimated];
			}
		}
	} else {
		// we're not visible yet
		// --> just remember our controllers, they will be made visible later
		[self removeAllViewControllers];
		[self addViewControllers:vcs];
	}
}

- (void) setTopViewController:(UIViewController *)vc {
	NSMutableArray *newControllerStack = [NSMutableArray arrayWithArray:viewControllers];
	[newControllerStack removeLastObject];
	
	if ([newControllerStack containsObject:vc]) {
		[NSException raise:@"NSInvalidArgumentException"
					format:@"Pushing the same view controller instance more than once is not supported (%@)", vc];
	}
	
	[newControllerStack addObject:vc];
	[self setViewControllers:newControllerStack animated:NO];
}

- (UIViewController*)topViewController {
	return [viewControllers lastObject];
}

- (void)setNavigationBar:(NMNavigationBar *)nb {
	if (navigationBar != nb) {
		navigationBar.delegate = nil;
		if (navigationBar.superview != nil) [navigationBar removeFromSuperview];
		[navigationBar release];
		
		navigationBar = [nb retain];
		navigationBar.delegate = self;
	}
	
	if ([self isViewLoaded]) [self addNavigationBarAsSubview];
}


#pragma mark Pushing / Popping

- (void)pushViewController:(UIViewController *)vc animated:(BOOL)isAnimated {
	if ([viewControllers containsObject:vc]) {
		[NSException raise:@"NSInvalidArgumentException"
					format:@"Pushing the same view controller instance more than once is not supported (%@)", vc];
	}
	
	NSMutableArray *newStack = [NSMutableArray arrayWithArray:viewControllers];
	[newStack addObject:vc];
	[self setViewControllers:newStack animated:isAnimated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)isAnimated {
	if ([viewControllers count] > 1) {
		NSMutableArray *newStack = [NSMutableArray arrayWithArray:viewControllers];
		UIViewController *removed = [newStack lastObject];
		[newStack removeLastObject];
		[self setViewControllers:newStack animated:isAnimated];
		
		return removed;
	} else {
		return nil;
	}
}

- (NSArray *)popToViewController:(UIViewController *)newCurrentController animated:(BOOL)isAnimated {
	if ([viewControllers containsObject:newCurrentController]
		&& [viewControllers lastObject] != newCurrentController) {
		
		NSMutableArray *newStack = [NSMutableArray arrayWithArray:viewControllers];
		NSMutableArray *removedControllers = [NSMutableArray array];
		
		NSUInteger indexOfController = [newStack indexOfObject:newCurrentController];
		NSUInteger indicesToRemove = ([newStack count]-1 - indexOfController);
		while (indicesToRemove > 0) {
			[removedControllers addObject:[newStack objectAtIndex:indexOfController+1]];
			[newStack removeObjectAtIndex:indexOfController+1];
			indicesToRemove--;
		}
		
		[self setViewControllers:newStack animated:isAnimated];
		
		return removedControllers;
	} else {
		return [NSArray array];
	}
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)isAnimated {
	if ([viewControllers count] > 0) {
		return [self popToViewController:[viewControllers objectAtIndex:0] animated:isAnimated];
	} else {
		return [NSArray array];
	}
}


#pragma mark Transition Management

// preconditions:
// - self.topViewController is currently visible and should be removed from
//   the top of the navigation stack at the end of the transition
// - destinationController's view is not added to the contentContainerView yet
- (void)transition:(NMNavigationControllerTransition)transition
  toViewController:(UIViewController *)destinationController animated:(BOOL)isAnimated {

	// determine animation values
	NSTimeInterval duration = (isAnimated ? ANIMATIONDURATION : 0);
	
	// determine positions
	NMNavigationControllerPosition destinationStartPosition;
	NMNavigationControllerPosition destinationFinalPosition;
	NMNavigationControllerPosition currentFinalPosition;
	switch (transition) {
		case NMNavigationControllerTransitionNone:
			destinationStartPosition = NMNavigationControllerPositionCurrent;
			destinationFinalPosition = NMNavigationControllerPositionCurrent;
			currentFinalPosition = NMNavigationControllerPositionCurrent;
			break;
		case NMNavigationControllerTransitionPop:
			destinationStartPosition = NMNavigationControllerPositionBack;
			destinationFinalPosition = NMNavigationControllerPositionCurrent;
			currentFinalPosition = NMNavigationControllerPositionNext;
			break;
		case NMNavigationControllerTransitionPush:
			destinationStartPosition = NMNavigationControllerPositionNext;
			destinationFinalPosition = NMNavigationControllerPositionCurrent;
			currentFinalPosition = NMNavigationControllerPositionBack;
			break;
	}
	
	// prepare destination vc
	[self applyPostion:destinationStartPosition toViewController:destinationController];
	destinationController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.contentContainerView addSubview:destinationController.view];
	if (!UIKIT_FORWARDS_APPEARANCE()) [destinationController viewWillAppear:isAnimated];
	
	// prepare current vc
	UIViewController *currentController = [[self.topViewController retain] autorelease];
	if (!UIKIT_FORWARDS_APPEARANCE()) [currentController viewWillDisappear:isAnimated];
	
	// correct view controller stack
	[viewControllers removeLastObject];
	
	// animate (if necessary) the view into place and send appropriate
	// appear / disappear messages to the involved controllers
	[UIView animateWithDuration:duration
					 animations:^{
						 [self applyPostion:destinationFinalPosition toViewController:destinationController];
						 [self applyPostion:currentFinalPosition toViewController:currentController];
					 }
					 completion:^(BOOL finished) {
						 if (!UIKIT_FORWARDS_APPEARANCE()) [destinationController viewDidAppear:isAnimated];

						 [currentController.view removeFromSuperview];
						 if (transition == NMNavigationControllerTransitionPop) {
							 currentController.nmNavigationController = nil;
						 }
						 if (!UIKIT_FORWARDS_APPEARANCE()) [currentController viewDidDisappear:isAnimated];
						 
						 if (transition == NMNavigationControllerTransitionPush) {
							 if ([delegate respondsToSelector:@selector(navigationController:didPushViewController:)]) {
								 [delegate navigationController:self didPushViewController:destinationController];
							 }
						 } else if (transition == NMNavigationControllerTransitionPop) {
							 if ([delegate respondsToSelector:@selector(navigationController:didPopViewController:)]) {
								 [delegate navigationController:self didPopViewController:currentController];
							 }
						 }
					 }];
}


#pragma mark Controller Management

- (void)addViewControllers:(NSArray *)vcs {
	for (UIViewController *vc in vcs) {
		vc.nmNavigationController = self;
		[viewControllers addObject:vc];
	}
}

- (void)removeAllViewControllers {
	while ([viewControllers count] > 0) {
		UIViewController *bottom = [viewControllers objectAtIndex:0];
		[self removeViewController:bottom];
	}
}

- (void)removeViewControllersUpToViewController:(UIViewController *)vc {
	while ([viewControllers objectAtIndex:0] != vc) {
		UIViewController *bottom = [viewControllers objectAtIndex:0];
		[self removeViewController:bottom];
	}
}

- (void)removeViewController:(UIViewController *)vc {
	[viewControllers removeObject:vc];
	vc.nmNavigationController = nil;
	if ([vc isViewLoaded] && vc.view.superview != nil) {
		[vc.view removeFromSuperview];
	}
}

- (void)applyPostion:(NMNavigationControllerPosition)position toViewController:(UIViewController *)vc {
	CGSize contentSize = self.contentContainerView.bounds.size;
	
	switch (position) {
		case NMNavigationControllerPositionCurrent:
			vc.view.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
			break;
		case NMNavigationControllerPositionBack:
			vc.view.frame = CGRectMake(-contentSize.width, 0, contentSize.width, contentSize.height);
			break;
		case NMNavigationControllerPositionNext:
			vc.view.frame = CGRectMake(contentSize.width, 0, contentSize.width, contentSize.height);
			break;
	}
}


#pragma mark NMNavigationBarDelegate

- (void)addNavigationBarAsSubview {
	if (navigationBar != nil) {
		navigationBarContainerView.bounds = CGRectMake(0, 0, navigationBarContainerView.bounds.size.width, navigationBar.bounds.size.height);
		navigationBarContainerView.center = CGPointMake(navigationBarContainerView.center.x, navigationBar.bounds.size.height/2);
		contentContainerView.frame = CGRectMake(0, navigationBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-navigationBar.bounds.size.height);
		
		navigationBar.frame = navigationBarContainerView.bounds;
		navigationBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[navigationBarContainerView addSubview:navigationBar];
		
		[navigationBar setNavigationStack:viewControllers animated:NO];
	}
}

- (void)navigationBarDidPop:(NMNavigationBar *)bar {
	[self popViewControllerAnimated:YES];
}


#pragma mark Interface Orientation Management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	BOOL result = YES;
	
	for (UIViewController* vc in viewControllers) {
		result = result && [vc shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}
	
	return result;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	for (UIViewController* vc in viewControllers) {
		[vc willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	for (UIViewController* vc in viewControllers) {
		[vc didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	}
}


#pragma mark State Lifecycle

- (void)loadState {
	[super loadState];
	
	viewControllers = [[NSMutableArray alloc] init];
}

- (void)unloadState {
	[super unloadState];
	
	[viewControllers release];
	viewControllers = nil;
	
	[navigationBar release];
	navigationBar = nil;
}


#pragma mark View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationBarContainerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
	self.contentContainerView.frame = self.view.bounds;
	
	[self addNavigationBarAsSubview];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if ([viewControllers count] > 0) {
		UIViewController *vc = [viewControllers lastObject];
		[self applyPostion:NMNavigationControllerPositionCurrent toViewController:vc];
		vc.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[self.contentContainerView addSubview:vc.view];
		if (!UIKIT_FORWARDS_APPEARANCE()) [vc viewWillAppear:animated];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([viewControllers count] > 0) {
		UIViewController *vc = [viewControllers lastObject];
		if (!UIKIT_FORWARDS_APPEARANCE()) [vc viewDidAppear:animated];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	if ([viewControllers count] > 0) {
		UIViewController *vc = [viewControllers lastObject];
		if (!UIKIT_FORWARDS_APPEARANCE()) [vc viewWillDisappear:animated];
	}
	
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	if ([viewControllers count] > 0) {
		UIViewController *vc = [viewControllers lastObject];
		[vc.view removeFromSuperview];
		if (!UIKIT_FORWARDS_APPEARANCE()) [vc viewDidDisappear:animated];
	}
	
	[super viewDidDisappear:animated];
}

- (void)unloadViewReferences {
	[super unloadViewReferences];
	
	self.contentContainerView = nil;
	self.navigationBarContainerView = nil;
	
	for (UIViewController *vc in viewControllers) {
		if ([vc isViewLoaded]) {
			[vc.view removeFromSuperview];
		}
	}
}

@end


#define KEY_NMNAVIGATIONCONTROLLER @"NMNavigationController *nmNavigationController"

@implementation UIViewController (NMNavigationControllerAdditions)

#pragma mark Properties

- (void)setNmNavigationController:(NMNavigationController *)vc {
	objc_setAssociatedObject(self, KEY_NMNAVIGATIONCONTROLLER, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NMNavigationController *)nmNavigationController {
	return objc_getAssociatedObject(self, KEY_NMNAVIGATIONCONTROLLER);
}

@end



