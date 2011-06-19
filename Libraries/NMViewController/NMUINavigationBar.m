//
//  NMUINavigationBar.m
//  NMViewController
//
//  Created by Benjamin Broll on 30.05.11.
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
