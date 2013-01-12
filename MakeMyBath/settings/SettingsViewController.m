//
//  SettingsViewController.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 12/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "SettingsViewController.h"
#import "TemperatureCalculator.h"

@interface SettingsViewController ()

@property(weak, nonatomic) IBOutlet UIButton    *doneButton;
@property(weak, nonatomic) IBOutlet UITextField *coldTapTemp;
@property(weak, nonatomic) IBOutlet UITextField *warmTapTemp;
@property(weak, nonatomic) IBOutlet UITextField *coldTapFlow;
@property(weak, nonatomic) IBOutlet UITextField *warmTapFlow;
@property(strong, nonatomic)        TemperatureCalculator *temperatureCalculator;

@end


@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
temperatureCalculator:(TemperatureCalculator*)temperatureCalculator
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    self.temperatureCalculator = temperatureCalculator;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.coldTapTemp.text = [NSString stringWithFormat:@"%.1f", self.temperatureCalculator.coldTemp];
  self.warmTapTemp.text = [NSString stringWithFormat:@"%.1f", self.temperatureCalculator.warmTemp];
  
  self.coldTapFlow.text = [NSString stringWithFormat:@"%.1f", self.temperatureCalculator.coldFlow];
  self.warmTapFlow.text = [NSString stringWithFormat:@"%.1f", self.temperatureCalculator.warmFlow];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIButton*)foo
{
  [self dismissModalViewControllerAnimated:YES];
}

@end
