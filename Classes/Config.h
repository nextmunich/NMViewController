//
//  Config.h
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright NEXT Munich. The App Agency. 2011. All rights reserved.
//


// use the preprocessor defines CONFIGURATION_<ConfigName> to customize
// configuration based on the configuration used for compilation


// configure functionality. any of the below can be enabled to immediately start
// using the service
#ifndef CONFIGURATION_Distribution
#define USE_LOGGING
#endif
//#define USE_PUSHNOTIFICATIONS
//#define USE_LOCATION


// configure details of utility functions
#define UTILITIES_GOOGLEMAPS_SPAN 0.02