//
//  NMNavigationBar.m
//  NMViewController
//
//  Created by Benjamin Broll on 30.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import "NMNavigationBar.h"


@implementation NMNavigationBar

#pragma mark Properties

@synthesize delegate;


#pragma mark Public API

- (void)setNavigationStack:(NSArray *)viewControllers animated:(BOOL)isAnimated {
	// override in subclass
}


@end
