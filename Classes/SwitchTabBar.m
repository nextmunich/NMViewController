//
//  NMWeirdTabBar.m
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import "SwitchTabBar.h"


@implementation SwitchTabBar

@synthesize tabSwitch;


- (void)setSelectedTab:(NSUInteger)tabIndex {
	if (tabIndex == 0) tabSwitch.on = YES;
	else tabSwitch.on = NO;
}


- (IBAction)switchChangedValue {
	[delegate tabBar:self didSelectTab:(tabSwitch.on ? 0 : 1)];
}


- (void)dealloc {
	self.tabSwitch = nil;
	
	[super dealloc];
}

@end
