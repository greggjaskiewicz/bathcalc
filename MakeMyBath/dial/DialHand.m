//
//  DialHand.m
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 05/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "DialHand.h"
#import "DialHandLayer.h"

#import <QuartzCore/QuartzCore.h>

@interface DialHand()

@end

@implementation DialHand

+ (Class)layerClass
{
  return [DialHandLayer class];
}

- (void)setAngle:(CGFloat)angle
{
  if (angle == _angle)
  {
    return;
  }
  
  if (angle < 0.0)
  {
    angle = 0.0;
  }
  
  if (angle > 180)
  {
    angle = 180;
  }
  
  DialHandLayer *theLayer = (DialHandLayer*)self.layer;

  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"angle"];
	anim.duration = 0.2;
	anim.fromValue = [NSNumber numberWithDouble:_angle];
	anim.toValue = [NSNumber numberWithDouble:angle];
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  
	[theLayer addAnimation:anim forKey:@"angle"];
  
  theLayer.angle = angle;
  _angle = angle;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.backgroundColor = [UIColor clearColor];
    _angle = -1.0;
  }
  return self;
}

@end
