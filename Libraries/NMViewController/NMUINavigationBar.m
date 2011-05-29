//
//  NMUINavigationBar.m
//  NMViewController
//
//  Created by Benjamin Broll on 30.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import "NMUINavigationBar.h"


@implementation NMUINavigationBar


#pragma mark NMNavigationBar

- (void)setNavigationStack:(NSArray *)viewControllers animated:(BOOL)isAnimated {
	if (!shouldNotUpdateNavigationStack) {
		NSMutableArray *navigationItems = [NSMutableArray array];
		
		for (UIViewController *vc in viewControllers) {
			[navigationItems addObject:vc.navigationItem];
		}
		
		[navigationBar setItems:navigationItems animated:isAnimated];
	} else {
		shouldNotUpdateNavigationStack = NO;
	}
}


#pragma mark Navigation Bar Delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
	shouldNotUpdateNavigationStack = YES;
	[delegate navigationBarDidPop:self];
	return YES;
}


#pragma mark View Lifecycle

- (void)createView {
	[super createView];
	
	self.frame = CGRectMake(0, 0, 320, 44);
	navigationBar = [[UINavigationBar alloc] initWithFrame:self.bounds];
	navigationBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	navigationBar.delegate = self;
	[self addSubview:navigationBar];
}

- (void)dealloc {
	[navigationBar release];
	
	[super dealloc];
}

@end
