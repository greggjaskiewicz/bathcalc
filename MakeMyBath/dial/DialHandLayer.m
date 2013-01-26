//
//  DialHandLayer.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 05/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "DialHandLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation DialHandLayer


+ (BOOL)needsDisplayForKey:(NSString *)key
{
  BOOL result;
  
  if ([key isEqualToString:@"angle"])
  {
    result = YES;
  }
  else
  {
    result = [super needsDisplayForKey:key];
  }
  return result;
}


- (void)setAngle:(CGFloat)angle
{
  _angle = angle;
  
  [self setNeedsDisplay];
}


static CGPoint pointOnCircle(const CGFloat radius, const CGFloat angle)
{
  CGFloat x = radius * cos((angle*M_PI)/180.0);
  CGFloat y = radius * sin((angle*M_PI)/180.0);
  
  return CGPointMake(x,y);
}


- (void)drawInContext:(CGContextRef)context
{
  static const CGFloat pitch_line_width = 4.00f;
  
  //  CGContextSetShadowWithColor(context, CGSizeMake(2,2), -1.5, [UIColor lightGrayColor].CGColor);
  
  CGFloat shadowOffset = 1.0 - sin((self.angle*M_PI)/180.0);
  CGSize shadow        = CGSizeMake(shadowOffset*2.5, shadowOffset*2);
  
  CGContextSetShadow(context, shadow, 2.5);
  
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


- (id)initWithLayer:(id)layer
{
	if ((self = [super initWithLayer:layer]))
  {
		if ([layer isKindOfClass:[DialHandLayer class]])
    {
			// Copy custom property values between layers
			DialHandLayer *other = (DialHandLayer *)layer;
			self.angle = other.angle;
		}
	}
	return self;
}

@end
