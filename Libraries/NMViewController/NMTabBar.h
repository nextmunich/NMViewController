//
//  NMTabBar.h
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
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