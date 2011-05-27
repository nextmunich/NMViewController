//
//  NMWeirdTabBar.h
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NMTabBar.h"
#import "SwitchTabBar.h"


@interface SwitchTabBar : NMTabBar {

	UISwitch *tabSwitch;
	
}

@property (nonatomic, retain) IBOutlet UISwitch *tabSwitch;

- (IBAction)switchChangedValue;

@end
