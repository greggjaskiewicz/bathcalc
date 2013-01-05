//
//  DialHand.m
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 05/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "DialHand.h"

@implementation DialHand

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
  
  _angle = angle;
  
  [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.backgroundColor = [UIColor clearColor];
    self.angle = 0.0;
  }
  return self;
}

- (void)actionForKey
{
  
}
static CGPoint pointOnCircle(const CGFloat radius, const CGFloat angle)
{
  CGFloat x = radius * cos((angle*M_PI)/180.0);
  CGFloat y = radius * sin((angle*M_PI)/180.0);
  
  return CGPointMake(x,y);
}

- (void)drawRect:(CGRect)rect
{
  static const CGFloat pitch_line_width = 4.0;
  
  /* draw the pitch */
  CGContextRef context = UIGraphicsGetCurrentContext();
  //  CGContextSetShadowWithColor(context, CGSizeMake(2,2), -1.5, [UIColor lightGrayColor].CGColor);
  CGContextSetShadow(context, CGSizeMake(2, 2), 4);
  
  /* draw lines */
  CGContextSetRGBStrokeColor(context, 0.9, 0.0, 0.0, 0.9);
  CGContextSetRGBFillColor(  context, 1.0, 0.0, 0.0, 1.0);
  
  CGFloat radius = 11;
  CGContextFillEllipseInRect(context, CGRectMake(self.frame.size.width/2-radius, self.frame.size.height/2-radius,
                                                 radius*2, radius*2 ));
  CGContextSetLineCap(context, kCGLineCapRound);

  CGContextBeginPath(context);
  
  CGContextSetLineCap(context, kCGLineCapRound);
  CGContextSetLineWidth(context, pitch_line_width);

  {
    CGPoint lowPoint  = pointOnCircle(self.frame.size.height*0.10, self.angle);
    CGPoint highPoint = pointOnCircle(self.frame.size.height*0.35, self.angle);
    
    CGContextMoveToPoint(context,    self.frame.size.width/2 - highPoint.x, self.frame.size.height/2 - highPoint.y);
    CGContextAddLineToPoint(context, self.frame.size.width/2 + lowPoint.x,  self.frame.size.height/2 + lowPoint.y );
  }

  CGContextStrokePath(context);
}

@end
