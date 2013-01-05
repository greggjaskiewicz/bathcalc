//
//  ViewController.m
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 03/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "ViewController.h"
#import "TapViewController.h"
#import "DialViewController.h"

@interface ViewController () <TapViewControllerDelegate>

@property(nonatomic, strong) TapViewController *coldTap;
@property(nonatomic, strong) TapViewController *warmTap;
@property(nonatomic, strong) DialViewController *temperatureDial;
@property(nonatomic) CGFloat temperature;

@end

@implementation ViewController

- (void)tapViewController:(TapViewController *)tapViewController valueChangedTo:(CGFloat)newValue
{
  self.temperature = (self.warmTap.currentValue * 100) - (self.coldTap.currentValue*self.warmTap.currentValue*100);
  self.temperatureDial.temperature  = self.temperature;
}

- (void)animateTemp
{
  //  return;
  double delayInSeconds = 0.45;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    CGFloat r = random();
    r = r/(float)RAND_MAX;
    r *= 100.0;
    self.temperatureDial.temperature = r;
    
    r = r/100.0;
    
    // set taps too !
    self.coldTap.currentValue = 1-r;
    self.warmTap.currentValue = r;
    
    [self animateTemp];
  });
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // set background to tiles
  UIImage *tile = [UIImage imageNamed:@"tile.png"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:tile];
 
  // warm 20, 322
  // cold 190, 322
  self.coldTap = [[TapViewController alloc] initWithTapImage:[UIImage imageNamed:@"cold_tap.png"]];
  self.warmTap = [[TapViewController alloc] initWithTapImage:[UIImage imageNamed:@"hot_tap.png"]];
  
  [self addChildViewController:self.coldTap];
  [self addChildViewController:self.warmTap];
  
  [self.view addSubview:self.coldTap.view];
  [self.view addSubview:self.warmTap.view];

  self.coldTap.view.frame =  CGRectMake(190, 322, self.coldTap.view.bounds.size.width, self.coldTap.view.bounds.size.height);
  self.warmTap.view.frame =  CGRectMake(20,  322, self.warmTap.view.bounds.size.width, self.warmTap.view.bounds.size.height);
  
  self.coldTap.delegate = self;
  self.warmTap.delegate = self;
  
  self.temperatureDial = [[DialViewController alloc] init];
  [self addChildViewController:self.temperatureDial];
  [self.view addSubview:self.temperatureDial.view];
  
  CGRect dialRect = self.temperatureDial.view.bounds;
  dialRect.origin = CGPointMake(self.view.frame.size.width/2-self.temperatureDial.view.frame.size.width/2, 120);
  self.temperatureDial.view.frame = dialRect;
  
  self.temperatureDial.temperature = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self animateTemp];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
