//
//  TabOneController.h
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich. The App Agency. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMViewController.h"


@interface TabOneController : NMViewController {

	UILabel *titleLabel;
	
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@end
