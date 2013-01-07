//
//  TemperatureCalculation.m
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 06/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "TemperatureCalculator.h"

@interface TemperatureCalculator()

@property CGFloat temperature;
@property CGFloat mass;

@end


@implementation TemperatureCalculator

- (id)init
{
  self = [super init];
  if (self)
  {
    [self reset];
  }
  
  return self;
}

- (void)reset
{
  self.mass = 0.0f;
  self.temperature = 0.0f;
}

- (CGFloat)updateCalculationWithTemperature:(CGFloat)sampleTemperature sampleMass:(CGFloat)sampleMass
{
  if (sampleTemperature < 0 || sampleTemperature > 100)
  {
    return -100; // or we could throw
  }
  
  // not enough to make calculation, so just don't
  if (sampleMass < FLT_EPSILON)
  {
    //    NSLog(@"don't!");
    return self.temperature;
  }
  
  //  ((Va * Ta) + (Vb * Tb)) / (Va+Vb) = Tf , because both are water and their heat constants are the same
  CGFloat t = (sampleMass*sampleTemperature + self.mass*self.temperature);
  CGFloat l = (sampleMass + self.mass);
  self.temperature = t / l;
  
  self.mass += sampleMass;
  
  //  NSLog(@"sampleTemp: %f, sampleMass: %f, newTemperature:%f", sampleTemperature, sampleMass, self.temperature);
  
  return self.temperature;
}

@end
