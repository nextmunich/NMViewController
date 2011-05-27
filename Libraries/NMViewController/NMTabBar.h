//
//  NMTabBar.h
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMView.h"

@protocol NMTabBarDelegate;



// this is an abstract class and should only serve as a basis for your
// implementation of a tab bar
@interface NMTabBar : NMView {

	// State
	id<NMTabBarDelegate> delegate;
	
}

@property (nonatomic, assign) id<NMTabBarDelegate> delegate;


// populate the view with the necessary elements to represent the view
// controllers
- (void)setTabsForViewControllers:(NSArray *)viewControllers;

// select tabs
// NSNotFound will be passed in case no tab should be selected
- (void)setSelectedTab:(NSUInteger)tabIndex;

@end



@protocol NMTabBarDelegate

- (void)tabBar:(NMTabBar *)tb didSelectTab:(NSUInteger)tabIndex;

@end