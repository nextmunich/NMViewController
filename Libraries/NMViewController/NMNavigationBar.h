//
//  NMNavigationBar.h
//  NMViewController
//
//  Created by Benjamin Broll on 30.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NMView.h"


@protocol NMNavigationBarDelegate;



@interface NMNavigationBar : NMView {

	// State
	id<NMNavigationBarDelegate> delegate;
	
}

@property (nonatomic, assign) id<NMNavigationBarDelegate> delegate;

- (void)setNavigationStack:(NSArray *)viewControllers animated:(BOOL)isAnimated;

@end


@protocol NMNavigationBarDelegate

- (void)navigationBarDidPop:(NMNavigationBar *)bar;

@end