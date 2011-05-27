//
//  NMViewController.m
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright NEXT Munich. The App Agency. 2011. All rights reserved.
//

#import "NMViewController.h"


@implementation NMViewController

#pragma mark Properties


#pragma mark Initializers

- (id) init {
	if ((self = [super init])) {
		[self loadState];
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self loadState];
	}
	
	return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self loadState];
	}
	
	return self;
}


#pragma mark State Management

- (void) loadState { }


#pragma mark Memory Management Callbacks

- (void) unloadState { }

- (void) unloadViewReferences { }

- (void) unloadCachedData { }


#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
	[self unloadCachedData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	[self unloadViewReferences];
}

- (void)dealloc {
	[self unloadViewReferences];
	[self unloadState];
	
    [super dealloc];
}

@end
