//
//  SettingsViewController.h
//  BathCalc
//
//  Created by Greg Jaskiewicz on 12/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TemperatureCalculator;

@interface SettingsViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil temperatureCalculator:(TemperatureCalculator*)temperatureCalculator;

@end
