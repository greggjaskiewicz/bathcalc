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
#import "TemperatureCalculator.h"

static const CGFloat warm_water_flow = 10.0; // litre per minute
static const CGFloat cold_water_flow = 12.0; // litre per minute
static const CGFloat warm_water_temp = 60.0; // celcius , not mentioned in the document - but here's my assumption
static const CGFloat cold_water_temp = 10.0; // celcius


@interface ViewController () <TapViewControllerDelegate>

@property(nonatomic, strong) TapViewController  *coldTap;
@property(nonatomic, strong) TapViewController  *warmTap;
@property(nonatomic, strong) UIProgressView     *progress;
@property(nonatomic, strong) DialViewController *temperatureDial;
@property(nonatomic)         NSTimeInterval      lastTimeChange;
@property(nonatomic)         TemperatureCalculator *tCalculator;

@end


@implementation ViewController

- (void)updateTemperatureWithColdTap:(CGFloat)coldTap warmTap:(CGFloat)warmTap
{
  NSTimeInterval tnow  = [[NSDate date] timeIntervalSince1970];
  NSTimeInterval tdiff = tnow - self.lastTimeChange;
  self.lastTimeChange = tnow;
  
  CGFloat coldMass = cold_water_flow * (tdiff/60.0);
  CGFloat warmMass = warm_water_flow * (tdiff/60.0);
  
  // calculate each water mass using flow,and tap position, and time
  coldMass *= coldTap;
  warmMass *= warmTap;
  
  [self.tCalculator updateCalculationWithTemperature:warm_water_temp sampleMass:warmMass];
  [self.tCalculator updateCalculationWithTemperature:cold_water_temp sampleMass:coldMass];
  
  self.temperatureDial.temperature = self.tCalculator.temperature;
  
  self.progress.progress = self.tCalculator.mass/150.0;
  
  if (self.tCalculator.mass >= 150)
  {
    self.coldTap.enabled = NO;
    self.warmTap.enabled = NO;
    return;
  }
}

- (void)tapViewController:(TapViewController *)tapViewController valueChangedTo:(CGFloat)newValue previousValue:(CGFloat)previousValue
{
  CGFloat coldTap = self.coldTap.currentValue;
  CGFloat warmTap = self.warmTap.currentValue;
  
  // calculate each water mass using flow,and tap position, and time
  if (self.coldTap == tapViewController)
  {
    coldTap = previousValue;
  }
  
  if (self.warmTap == tapViewController)
  {
    warmTap = previousValue;
  }
  
  [self updateTemperatureWithColdTap:coldTap warmTap:warmTap];
}

- (void)animateTemp
{
  double delayInSeconds = 0.15;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    // if you want to make it random, have fun !
#ifdef RANDOM_MODE
    
    CGFloat r = random();
    r = r/(float)RAND_MAX;
    r *= 100.0;
    //     self.temperatureDial.temperature = r;
    
    r = r/100.0;
    
    // set taps too !
    self.coldTap.currentValue = 1-r;
    self.warmTap.currentValue = r;
#endif

    [self updateTemperatureWithColdTap:self.coldTap.currentValue warmTap:self.warmTap.currentValue];
    
    if (self.tCalculator.mass < 150)
    {
      [self animateTemp];
    }
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
  self.coldTap = [[TapViewController alloc] initWithTap:tap_cold];
  self.warmTap = [[TapViewController alloc] initWithTap:tap_warm];
  
  [self addChildViewController:self.coldTap];
  [self addChildViewController:self.warmTap];
  
  self.coldTap.view.frame =  CGRectMake(190, 300, self.coldTap.view.bounds.size.width, self.coldTap.view.bounds.size.height);
  self.warmTap.view.frame =  CGRectMake(20,  300, self.warmTap.view.bounds.size.width, self.warmTap.view.bounds.size.height);
  
  [self.view addSubview:self.coldTap.view];
  [self.view addSubview:self.warmTap.view];
  
  
  self.coldTap.delegate = self;
  self.warmTap.delegate = self;
  
  self.temperatureDial = [[DialViewController alloc] init];
  [self addChildViewController:self.temperatureDial];
  [self.view addSubview:self.temperatureDial.view];
  
  CGRect dialRect = self.temperatureDial.view.bounds;
  dialRect.origin = CGPointMake(self.view.frame.size.width/2-self.temperatureDial.view.frame.size.width/2, 30);
  self.temperatureDial.view.frame = dialRect;
  
  self.temperatureDial.temperature = 0.0f;
  
  self.progress = [[UIProgressView alloc] initWithFrame:CGRectMake(30, self.temperatureDial.view.bounds.size.height+30+30, self.view.frame.size.width-30-30, 30)];
  self.progress.progressViewStyle = UIProgressViewStyleBar;
  self.progress.progress = 0.0;
  [self.view addSubview:self.progress];
  
  
  self.tCalculator = [[TemperatureCalculator alloc] init];
  self.lastTimeChange = [[NSDate date] timeIntervalSince1970];
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
