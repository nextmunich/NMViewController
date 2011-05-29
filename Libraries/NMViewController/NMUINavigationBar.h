//
//  NMUINavigationBar.h
//  NMViewController
//
//  Created by Benjamin Broll on 30.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NMNavigationBar.h"


@interface NMUINavigationBar : NMNavigationBar <UINavigationBarDelegate> {

	// View
	UINavigationBar *navigationBar;
	
	// State
	BOOL shouldNotUpdateNavigationStack;
	
}

@end
