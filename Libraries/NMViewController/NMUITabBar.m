//
//  NMUITabBar.m
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import "NMUITabBar.h"


@implementation NMUITabBar

#pragma mark NMTabBar

- (void)setTabsForViewControllers:(NSArray *)viewControllers {
	NSMutableArray *items = [NSMutableArray array];
	
	for (UIViewController *vc in viewControllers) {
		[items addObject:vc.tabBarItem];
	}
	
	tabBar.items = items;
}

- (void)setSelectedTab:(NSUInteger)tabIndex {
	tabBar.selectedItem = [tabBar.items objectAtIndex:tabIndex];
}


#pragma mark UITabBarDelegate

- (void)tabBar:(UITabBar *)tb didSelectItem:(UITabBarItem *)item {
	[delegate tabBar:self didSelectTab:[tabBar.items indexOfObject:item]];
}


#pragma mark View Lifecycle

- (void)createView {
	[super createView];
	
	self.frame = CGRectMake(0, 0, 320, 49);
	tabBar = [[UITabBar alloc] initWithFrame:self.bounds];
	tabBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	tabBar.delegate = self;
	[self addSubview:tabBar];
}

- (void)dealloc {
	[tabBar release];
	
	[super dealloc];
}

@end
