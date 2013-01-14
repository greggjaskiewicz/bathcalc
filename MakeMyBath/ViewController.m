//
//  ViewController.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 03/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "ViewController.h"
#import "TapViewController.h"
#import "DialViewController.h"
#import "TemperatureCalculator.h"
#import "SettingsViewController.h"


/// Enable to get some automatic show
/// disable for manual control
//#define RANDOM_MODE


@interface ViewController () <TapViewControllerDelegate, DialViewControllerDelegate>

@property(nonatomic, strong) TapViewController  *coldTap;
@property(nonatomic, strong) TapViewController  *warmTap;
@property(nonatomic, strong) DialViewController *temperatureDial;

@property(nonatomic, strong) UIButton           *settingsButton;
@property(nonatomic)         NSTimeInterval      lastTimeChange;
@property(nonatomic)         TemperatureCalculator *tCalculator;


@end


@implementation ViewController

- (void)updateTemperatureWithColdTap:(CGFloat)coldTap warmTap:(CGFloat)warmTap
{
  [self.tCalculator reset];
  [self.tCalculator updateCalculationWithTemperature:self.tCalculator.warmTemp sampleMass:self.tCalculator.warmFlow * warmTap];
  [self.tCalculator updateCalculationWithTemperature:self.tCalculator.coldTemp sampleMass:self.tCalculator.coldFlow * coldTap];
  
  self.temperatureDial.temperature = self.tCalculator.temperature;
#ifdef _DEBUG_
  NSLog(@"Temperature %f", self.tCalculator.temperature);
#endif
}

- (void)tapViewController:(TapViewController *)tapViewController valueChangedTo:(CGFloat)newValue previousValue:(CGFloat)previousValue
{
  CGFloat coldTap = self.coldTap.currentValue;
  CGFloat warmTap = self.warmTap.currentValue;
  
  [self updateTemperatureWithColdTap:coldTap warmTap:warmTap];
}

/*
- (void)animateTemp
{
#ifdef RANDOM_MODE
  double delayInSeconds = 0.45;
#else
  double delayInSeconds = 0.15;
#endif
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    // if you want to make it random, have fun !
#ifdef RANDOM_MODE
    
    CGFloat r = random();
    r = r/(float)RAND_MAX;
    
    // set taps too !
    self.coldTap.currentValue = 1-r;
    self.warmTap.currentValue = r;
#endif

    [self updateTemperatureWithColdTap:self.coldTap.currentValue warmTap:self.warmTap.currentValue];
    
    if (self.tCalculator.mass < 20)
    {
      [self animateTemp];
    }
  });
}
*/

- (void)dialViewController:(DialViewController*)dialViewController newTemperature:(CGFloat)newTemperature
{
  NSNumber *nt = [NSNumber numberWithFloat:roundf((newTemperature*10.0))/10.0];
  tapPositionAndRange_t *pos = [self.tCalculator.position_table_for_temps objectForKey:nt];

  if (pos)
  {
    self.coldTap.currentValue = pos.coldTapPos;
    self.warmTap.currentValue = pos.warmTapPos;
  }
  else
  {
    [self updateTemperatureWithColdTap:self.coldTap.currentValue warmTap:self.warmTap.currentValue];
  }
}

- (BOOL)dialViewController:(DialViewController *)dialViewController isTemperatureValid:(CGFloat)newTemperature
{
  if (newTemperature < self.tCalculator.coldTemp)
  {
    return NO;
  }
  
  if (newTemperature > self.tCalculator.warmTemp)
  {
    return NO;
  }
  
  return YES;
}

- (void)showSettings:(UIButton*)button
{
  SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:nil bundle:nil temperatureCalculator:self.tCalculator];
  
  [self presentViewController:settings animated:YES completion:^{
  }];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // set background to tiles
  UIImage *tile = [UIImage imageNamed:@"tile.png"];
  //  self.view.backgroundColor = [UIColor colorWithPatternImage:tile ];
 
  UIImageView *imgView = [[UIImageView alloc] initWithImage:tile];
  imgView.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:imgView];
  
  // warm 20, 322
  // cold 190, 322
  self.coldTap = [[TapViewController alloc] initWithTap:tap_cold];
  self.warmTap = [[TapViewController alloc] initWithTap:tap_warm];
  
  [self addChildViewController:self.coldTap];
  [self addChildViewController:self.warmTap];
  
  [self.view addSubview:self.coldTap.view];
  [self.view addSubview:self.warmTap.view];
  
  
  self.coldTap.delegate = self;
  self.warmTap.delegate = self;
  
  self.temperatureDial = [[DialViewController alloc] init];
  [self addChildViewController:self.temperatureDial];
  [self.view addSubview:self.temperatureDial.view];
  self.temperatureDial.delegate = self;
  
  CGRect dialRect = self.temperatureDial.view.frame;
  dialRect.origin = CGPointMake(self.view.frame.size.width/2-self.temperatureDial.view.frame.size.width/2, 30);
  self.temperatureDial.view.frame = dialRect;
  
  self.temperatureDial.temperature = 0.0f;
  
  self.tCalculator = [[TemperatureCalculator alloc] init];
  self.lastTimeChange = [[NSDate date] timeIntervalSince1970];
  
  self.settingsButton = [UIButton buttonWithType:UIButtonTypeInfoLight];

  [self.settingsButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:self.settingsButton];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  CGFloat tapY = self.view.frame.size.height-180;
  
  if (tapY < 300.0)
  {
    tapY = 300;
  }

  self.coldTap.view.frame =  CGRectMake(190, tapY, self.coldTap.view.bounds.size.width, self.coldTap.view.bounds.size.height);
  self.warmTap.view.frame =  CGRectMake(20,  tapY, self.warmTap.view.bounds.size.width, self.warmTap.view.bounds.size.height);

  self.settingsButton.frame = CGRectMake(self.view.frame.size.width - 40, self.view.frame.size.height - 40,
                                         self.settingsButton.frame.size.width, self.settingsButton.frame.size.height);
  
  [self updateTemperatureWithColdTap:self.coldTap.currentValue warmTap:self.warmTap.currentValue];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
