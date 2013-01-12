//
//  DialTemperatureEntryViewController.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 09/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "DialTemperatureEntryViewController.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat fontSize = 25;

@interface DialTemperatureEntryViewController() <UITextFieldDelegate>

@property(nonatomic, strong) UITextField *inputTextField;
@property(nonatomic, strong) UIButton    *doneButton;

@end



@implementation DialTemperatureEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    // Custom initialization
  }
  return self;
}

- (void)viewWillLayoutSubviews
{
  CGPoint c =  CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
  self.inputTextField.center = c;
}

- (void)viewDidAppear:(BOOL)animated
{
  [UIView animateWithDuration:0.3 animations:^{
    self.view.alpha = 1.0;
  }];
  
  [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.alpha = 0.0f;
  
  self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, fontSize*1.2*4, fontSize*1.2)];
  self.view.backgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
  
  self.inputTextField.font          = [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
  self.inputTextField.keyboardType  = UIKeyboardTypeNumberPad;
  self.inputTextField.delegate      = self;
  self.inputTextField.textColor     = [UIColor whiteColor];
  self.inputTextField.textAlignment = NSTextAlignmentCenter;
  self.inputTextField.backgroundColor = [UIColor lightGrayColor];
  
  self.inputTextField.text = [NSString stringWithFormat:@"%d", (int)round(self.dialMain.temperature)];
  
  [self.view addSubview:self.inputTextField];
  [self.inputTextField becomeFirstResponder];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
  
  self.view.layer.cornerRadius = 7.0f;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)keyboardWillShow:(NSNotification *)note
{
  self.doneButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 106, 53)];
  self.doneButton.adjustsImageWhenHighlighted = NO;
  
  [self.doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
  [self.doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
  
  [self.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
  UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
  UIView* keyboard;
  for(NSUInteger i=0; i<[tempWindow.subviews count]; i++)
  {
    keyboard = [tempWindow.subviews objectAtIndex:i];
    
    if ([[keyboard description] hasPrefix:@"<UIPeripheralHost"])
    {
      [keyboard addSubview:self.doneButton];
    }
  }
  
}

- (void)doneButton:(id)sender
{
  [self textFieldShouldReturn:self.inputTextField];
}



- (BOOL)isTemperatureValid:(CGFloat)temp
{
  if (self.dialMain.delegate && [self.dialMain.delegate respondsToSelector:@selector(dialViewController:isTemperatureValid:)])
  {
    return [self.dialMain.delegate dialViewController:self.dialMain isTemperatureValid:temp];
  }
  
  if (temp >= 0 && temp <= 100)
  {
    return YES;
  }
  return NO;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  NSInteger newTemp = [textField.text integerValue];
  if ([self isTemperatureValid:newTemp])
  {
    self.dialMain.temperature = newTemp;
  }
  
  if (self.dialMain.delegate && [self.dialMain.delegate respondsToSelector:@selector(dialViewController:newTemperature:)])
  {
    [self.dialMain.delegate dialViewController:self.dialMain newTemperature:newTemp];
  }
}

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
  
  // now that we have resulting string in foo
  
  NSInteger newTemp = [foo integerValue];
  
  if (newTemp >= 0 && newTemp <= 100)
  {
    return YES;
  }
  
  if ([self isTemperatureValid:newTemp])
  {
    self.dialMain.temperature = newTemp;
    
  }
  
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self textFieldDidEndEditing:textField];
  [self.inputTextField resignFirstResponder];
  
  [UIView animateWithDuration:0.2
                   animations:^{
                     self.view.alpha = 0;
                   }
                   completion:^(BOOL f) {
                     [self.view removeFromSuperview];
                     [self removeFromParentViewController];
                   }];
  
  
  return YES;
}

@end
