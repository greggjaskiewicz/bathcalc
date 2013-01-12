//
//  DialViewController.h
//  BathCalc
//
//  Created by Greg Jaskiewicz on 05/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DialViewController;

@protocol DialViewControllerDelegate <NSObject>

@optional
- (void)dialViewController:(DialViewController*)dialViewController newTemperature:(CGFloat)newTemperature;
- (BOOL)dialViewController:(DialViewController*)dialViewController isTemperatureValid:(CGFloat)newTemperature;

@end


@interface DialViewController : UIViewController

@property(nonatomic) CGFloat temperature; // 0-100
@property(nonatomic, weak) NSObject<DialViewControllerDelegate> *delegate;

@end
