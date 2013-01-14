//
//  SettingsViewController.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 12/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "SettingsViewController.h"
#import "TemperatureCalculator.h"
#import "NSString+bath.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UIView      *busyView;

@property(weak, nonatomic) IBOutlet UIButton    *doneButton;
@property(weak, nonatomic) IBOutlet UIButton    *defaultbutton;
@property(weak, nonatomic) IBOutlet UIButton    *cancel;
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


/*
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
 - (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
 - (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
 - (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
 
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
 
 - (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
 - (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
 */


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  // is it equal the string with only decimals in it. If so - we're good
  NSString *dec = [string stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  if (![string isEqualToString:dec])
  {
    return NO;
  }
  
  // if more then 100 deg put in, refuse
  NSString *foo = textField.text;
  
  foo = [foo stringByReplacingCharactersInRange:range withString:string];
  
  self.doneButton.enabled = NO;
  
  if (![foo length])
  {
    self.doneButton.enabled = NO;
    return YES;
  }
  
  // now that we have resulting string in foo
  CGFloat newValue = [foo floatValue];
  
  // ballpark
  if (newValue <= 0 || newValue > 90)
  {
    return YES;
  }
  
  if (textField == self.warmTapFlow || textField == self.coldTapFlow)
  {
    if (newValue < 1 || newValue > 100)
    {
      return YES;
    }
  }
  
  if (textField == self.warmTapTemp)
  {
    if (newValue < 30 || newValue > 90)
    {
      return YES;
    }
  }
  
  if (textField == self.coldTapTemp)
  {
    if (newValue < 1 || newValue > 20)
    {
      return YES;
    }
  }
  
  self.doneButton.enabled = YES;
  return YES;
}

- (void)setFields
{
  self.coldTapTemp.text = [NSString stringWithFormat:@"%.1f", self.temperatureCalculator.coldTemp];
  self.warmTapTemp.text = [NSString stringWithFormat:@"%.1f", self.temperatureCalculator.warmTemp];
  
  self.coldTapFlow.text = [NSString stringWithFormat:@"%.1f", self.temperatureCalculator.coldFlow];
  self.warmTapFlow.text = [NSString stringWithFormat:@"%.1f", self.temperatureCalculator.warmFlow];
}

- (void)saveValues
{
  self.temperatureCalculator.coldTemp = [self.coldTapTemp.text floatValue];
  self.temperatureCalculator.warmTemp = [self.warmTapTemp.text floatValue];
  
  self.temperatureCalculator.coldFlow = [self.coldTapFlow.text floatValue];
  self.temperatureCalculator.warmFlow = [self.warmTapFlow.text floatValue];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.busyView.hidden = YES;
  self.busyView.layer.cornerRadius = 8;
  [self setFields];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIButton*)foo
{
  self.busyView.hidden = NO;

  self.warmTapFlow.enabled = NO;
  self.coldTapFlow.enabled = NO;
  self.warmTapTemp.enabled = NO;
  self.coldTapTemp.enabled = NO;
  self.doneButton.enabled  = NO;
  self.cancel.enabled      = NO;
  self.defaultbutton.enabled = NO;
  
  [self saveValues];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    [self.temperatureCalculator updatePositionTableUsing:self.temperatureCalculator.coldTemp
                                                warmTemp:self.temperatureCalculator.warmTemp
                                                coldFlow:self.temperatureCalculator.coldFlow
                                                warmFlow:self.temperatureCalculator.warmFlow];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      self.busyView.hidden = NO;
      [self dismissModalViewControllerAnimated:YES];
    });
  });
}

- (IBAction)cancel:(UIButton*)foo
{
  [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)setDefaults:(UIButton*)foo
{
  [self.temperatureCalculator setDefaults];
  [self setFields];
}



@end
