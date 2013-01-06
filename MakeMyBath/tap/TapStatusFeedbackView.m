//
//  TapStatusFeedbackView.m
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 06/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "TapStatusFeedbackView.h"

@interface TapStatusFeedbackView()

@property (nonatomic, strong) UIColor *colour;
@property (nonatomic)         CGFloat radius;
@end


@implementation TapStatusFeedbackView

- (void)setValue:(CGFloat)value
{
  if (_value != value)
  {
    _value = value;
    [self setNeedsDisplay];
  }
}

- (id)initWithFrame:(CGRect)frame andColour:(UIColor*)colour andRadius:(CGFloat)radius
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.backgroundColor = [UIColor clearColor];
    self.value = 0.0f;
    self.colour = colour;
    self.radius = radius;
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGColorRef arcColour = CGColorCreateCopyWithAlpha(self.colour.CGColor, 0.7);
  CGColorRef ovrColour = CGColorCreateCopyWithAlpha(self.colour.CGColor, 0.9);
  
  CGContextSetStrokeColorWithColor(context, ovrColour);
  CGContextSetFillColorWithColor  (context, arcColour);

  CGFloat angle = ((360.0*self.value)*M_PI)/180.0;

  CGContextBeginPath(context);

  CGContextMoveToPoint(context,    self.frame.size.width/2, self.frame.size.height/2);
  CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, self.radius, angle, -FLT_EPSILON, 1);
  CGContextMoveToPoint(context,    self.frame.size.width/2, self.frame.size.height/2);

  CGContextFillPath(context);
}

@end
