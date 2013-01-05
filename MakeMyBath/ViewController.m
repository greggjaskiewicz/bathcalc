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

@end

@implementation ViewController

- (void)tapViewController:(TapViewController *)tapViewController valueChangedTo:(CGFloat)newValue
{
  
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
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
