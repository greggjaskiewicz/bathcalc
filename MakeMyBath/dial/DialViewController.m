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

@property (nonatomic, strong) NSArray     *digits;

@end

@implementation DialViewController

- (void)setDigitTemperature
{
  CGFloat div = 100;
  for(UILabel *l in self.digits)
  {
    CGFloat dig = self.temperature/div;
    dig = fmodf(dig, 10.0f);
    l.text = [NSString stringWithFormat:@"%d",(int)dig];
    div = div/10;
  }
}

- (void)setTemperature:(CGFloat)temperature
{
  self.dialHand.angle = (temperature/100.0)*180.0;
  _temperature = temperature;
  [self setDigitTemperature];
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
  
  NSMutableArray *dl = [@[] mutableCopy];
  CGRect lrect = CGRectMake(64, 122, 18, 26);
  for(int i=0;i<3;i++)
  {
    UILabel *l = [[UILabel alloc] initWithFrame:lrect];
    UIFont *f = [UIFont fontWithName:@"Arial-BoldMT" size:21];
    l.font = f;
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.shadowOffset = CGSizeMake(2, 2);
    [dl addObject:l];
    [self.view addSubview:l];
    lrect.origin.x += 3+18;
  }
  
  self.digits = [dl copy];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
