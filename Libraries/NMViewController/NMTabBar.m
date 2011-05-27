//
//  NMTabBar.m
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import "NMTabBar.h"


@implementation NMTabBar

#pragma mark Properties

@synthesize delegate;


#pragma mark Public API

- (void)setTabsForViewControllers:(NSArray *)viewControllers {
	// override in subclass
}


- (void)setSelectedTab:(NSUInteger)tabIndex {
	
}

@end
