//
//  TapViewController.m
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 03/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "TapViewController.h"
#import <QuartzCore/QuartzCore.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface TapViewController ()

@property (nonatomic, strong) UIImageView *tapImageView;
@property (nonatomic, strong) UIImage *tapImage;
@property                     CGPoint lastTapPoint;
@property (nonatomic)         double currentRotation;

@end

@implementation TapViewController

-(void)setAnchorPointInTheMiddleForView:(UIView *)view
{
  CGPoint middle = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
  CGRect imageBounds = view.bounds;
  [view.layer setAnchorPoint:CGPointMake(middle.x / imageBounds.size.width, middle.y / imageBounds.size.height)];
}

- (void)rotateLayer:(CALayer*)layer by:(CGFloat)deg
{
  [UIView beginAnimations:@"rotate" context:nil];
  [layer setTransform:
   CATransform3DRotate(layer.transform, radians(deg), 0.0f, 0.0f, 1.0f)];
  [UIView commitAnimations];
}


- (id)initWithTapImage:(UIImage*)tapImage
{
  if (!tapImage)
  {
    return nil;
  }
  
  self = [super initWithNibName:nil bundle:nil];
  if (self)
  {
    self.tapImage = tapImage;
  }
  
  return self;
}

// do the nice touch controls

static double wrap(double val, double min, double max)
{
  if (val < min) return max - (min - val);
  if (val > max) return min - (max - val);
  return val;
}

- (void)rotateTapFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2
{
  CGPoint center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
  
  double fromAngle = atan2(p1.y-center.y, p1.x-center.x);
  double toAngle   = atan2(p2.y-center.y, p2.x-center.x);

  double deltaAngle = wrap(toAngle - fromAngle, -M_PI, M_PI ) * 60; // magic value
  
  //  NSLog(@"delta Angle %f, from: %f, to: %f", deltaAngle, fromAngle, toAngle);

  if (self.currentRotation + deltaAngle > 359)
  {
    deltaAngle = 359 - self.currentRotation;
  }
  
  if (self.currentRotation + deltaAngle < 0.0)
  {
    deltaAngle = -self.currentRotation;
  }
  
  if (fabs(deltaAngle) > DBL_EPSILON)
  {
    self.currentRotation += deltaAngle;
    [self rotateLayer:self.tapImageView.layer by:deltaAngle];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapViewController:valueChangedTo:)])
    {
      [self.delegate tapViewController:self valueChangedTo:self.currentRotation];
    }
  }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self.view];
  
  self.lastTapPoint = touchPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self.view];
  
  [self rotateTapFromPoint:self.lastTapPoint toPoint:touchPoint];
  
  self.lastTapPoint = touchPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self touchesMoved:touches withEvent:event];
}


- (void) rotation:(UIRotationGestureRecognizer *) sender
{
  [self rotateLayer:self.tapImageView.layer by:sender.rotation];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.frame = CGRectMake(0, 0, self.tapImage.size.width, self.tapImage.size.height);
  self.tapImageView = [[UIImageView alloc] initWithImage:self.tapImage];
  [self.view addSubview:self.tapImageView];
  
  self.tapImageView.center = self.view.center;
  
  [self setAnchorPointInTheMiddleForView:self.tapImageView];
  
  // for brave enough to do it with two fingers !
  UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
  
  [self.view addGestureRecognizer:rotate];
  self.currentRotation = 0.0;
  /*
   double deg = random();
   deg /= (double)RAND_MAX/180.0;
   [self rotateLayer:self.tapImageView.layer by:deg];
   */
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
