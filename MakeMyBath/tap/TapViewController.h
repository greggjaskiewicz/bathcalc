//
//  TapViewController.h
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 03/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>

enum taps_t
{
  tap_warm,
  tap_cold
};

@class TapViewController;

@protocol TapViewControllerDelegate <NSObject>

@optional

- (void)tapViewController:(TapViewController*)tapViewController valueChangedTo:(CGFloat)newValue previousValue:(CGFloat)previousValue;

@end

@interface TapViewController : UIViewController

- (id)initWithTap:(enum taps_t)tap;
@property(nonatomic, weak) NSObject<TapViewControllerDelegate> *delegate;

@property(nonatomic) CGFloat currentValue; // 0.0 - 1.0

@end
