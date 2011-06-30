//
//  TabOneController.m
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import "TabOneController.h"

#import "NMNavigationController.h"


@implementation TabOneController

@synthesize titleLabel;


- (void)logView:(NSString *)prefix animated:(BOOL)animated {
	NSLog(@"-----");
	NSLog(@"%@ (animated: %@)", prefix, (animated ? @"YES" : @"NO"));
	NSLog(@"isLoaded? %@", ([self isViewLoaded] ? @"YES" : @"NO"));
	NSLog(@"navVC: %@", self.navigationController);
	NSLog(@"nmNavVC: %@", self.nmNavigationController);
	
	if ([self isViewLoaded]) {
		NSLog(@"superview: %@", self.view.superview);
		NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
	}
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self logView:@"willAppear" animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self logView:@"didAppear" animated:animated];	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self logView:@"willDisappear" animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self logView:@"didDisappear" animated:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"willAnimate");
}


@end
