//
//  ViewController.m
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 03/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "ViewController.h"
#import "TapViewController.h"


@interface ViewController ()

@property(nonatomic, strong) TapViewController *coldTap;
@property(nonatomic, strong) TapViewController *warmTap;

@end

@implementation ViewController
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
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
