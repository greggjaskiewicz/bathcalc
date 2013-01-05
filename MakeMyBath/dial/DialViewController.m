//
//  DialViewController.m
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 05/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "DialViewController.h"
#import "DialHand.h"

@interface DialViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DialHand    *dialHand;
@end

@implementation DialViewController

- (void)setTemperature:(CGFloat)temperature
{
  self.dialHand.angle = (temperature/100.0)*180.0;
}

- (CGFloat)angle
{
  return self.dialHand.angle;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIImage *bck = [UIImage imageNamed:@"dial.png"];

  self.imageView = [[UIImageView alloc] initWithImage:bck];
  [self.view addSubview:self.imageView];
  
  //  self.view.backgroundColor = [UIColor colorWithPatternImage:bck];
  CGRect frame = CGRectMake(0, 0, bck.size.width, bck.size.height);

  self.view.bounds = frame;
  self.view.clipsToBounds = YES;
  
  self.dialHand = [[DialHand alloc] initWithFrame:frame];
  [self.view addSubview:self.dialHand];
  
  self.dialHand.angle = 0.0f;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
