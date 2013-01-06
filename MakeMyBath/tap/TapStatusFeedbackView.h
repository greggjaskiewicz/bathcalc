//
//  TapStatusFeedbackView.h
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 06/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TapStatusFeedbackView : UIView

- (id)initWithFrame:(CGRect)frame andColour:(UIColor*)colour andRadius:(CGFloat)radius;

@property(nonatomic) CGFloat value;

@end
