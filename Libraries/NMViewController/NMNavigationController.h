//
//  NMNavigationController.h
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


