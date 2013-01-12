//
//  DialViewController.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 05/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "DialViewController.h"
#import "DialHand.h"
#import "DialTemperatureEntryViewController.h"

@interface DialViewController ()

@property (nonatomic, strong) UIImage     *bckImg;
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
    CGFloat dig = roundf(self.temperature)/div;
    dig = fmodf(dig, 10.0f);
    l.text = [NSString stringWithFormat:@"%d",(int)dig];
    div = div/10;
  }
}

- (void)setTemperature:(CGFloat)temperature
{
  self.dialHand.angle = (roundf(temperature)/100.0)*180.0;
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

- (BOOL)isTemperatureValid:(CGFloat)temp
{
  if (self.delegate && [self.delegate respondsToSelector:@selector(dialViewController:isTemperatureValid:)])
  {
    return [self.delegate dialViewController:self isTemperatureValid:temp];
  }
  
  if (temp >= 0 && temp <= 100)
  {
    return YES;
  }
  return NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self.view];
  
  CGFloat tempSet = touchPoint.x/self.view.frame.size.width;
  tempSet *= 100.0;
  
  if (tempSet < 0)
  {
    tempSet = 0;
  }
  
  if (tempSet > 100)
  {
    tempSet = 100;
  }
  
  if ([self isTemperatureValid:tempSet])
  {
    self.temperature = tempSet;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dialViewController:newTemperature:)])
    {
      [self.delegate dialViewController:self newTemperature:tempSet];
    }
  }
}

- (void)tapped:(NSObject*)ignore
{
  static NSInteger editTag = 120;
  
  if ([self.view viewWithTag:editTag])
  {
    return;
  }
  
  DialTemperatureEntryViewController *tempEntry = [[DialTemperatureEntryViewController alloc] initWithNibName:nil bundle:nil];
  tempEntry.dialMain = self;
  
  tempEntry.view.tag = editTag;
  
  [self addChildViewController:tempEntry];
  [self.view addSubview:tempEntry.view];
  
  tempEntry.view.frame = self.view.bounds;
}

- (void)viewWillLayoutSubviews
{
  CGRect frame = CGRectMake(0, 0, self.bckImg.size.width, self.bckImg.size.height);
  self.view.bounds = frame;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.bckImg = [UIImage imageNamed:@"dial.png"];
  
  self.imageView = [[UIImageView alloc] initWithImage:self.bckImg];
  [self.view addSubview:self.imageView];
  
  //  self.view.backgroundColor = [UIColor colorWithPatternImage:bck];
  CGRect frame = CGRectMake(0, 0, self.bckImg.size.width, self.bckImg.size.height);
  
  self.view.bounds = frame;
  self.view.clipsToBounds = YES;
  
  self.dialHand = [[DialHand alloc] initWithFrame:frame];
  [self.view addSubview:self.dialHand];
  
  self.dialHand.angle = 0.0f;
  
  NSMutableArray *dl = [@[] mutableCopy];
  CGRect lrect = CGRectMake(71, 126, 18, 26);
  //  CGRect lrect = CGRectMake(64, 122, 18, 26);
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
    lrect.origin.x += 5+18;
  }
  
  self.digits = [dl copy];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
  [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
