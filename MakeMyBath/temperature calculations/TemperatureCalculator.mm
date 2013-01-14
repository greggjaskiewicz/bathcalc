//
//  TemperatureCalculation.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 06/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "TemperatureCalculator.h"
#include "TempAndValueTableCalculation.h"

@interface TemperatureCalculator()

@property CGFloat temperature;
@property CGFloat mass;
@property(strong) NSDictionary *position_table_for_temps;

@end


@implementation TemperatureCalculator

@synthesize coldFlow = _coldFlow, coldTemp = _coldTemp, warmFlow = _warmFlow, warmTemp = _warmTemp;

- (CGFloat)coldTemp
{
  if (_coldTemp == -1)
  {
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"coldTemp"])
    {
      _coldTemp = [[NSUserDefaults standardUserDefaults] floatForKey:@"coldTemp"];
    }
    else
    {
      _coldTemp = 10.0f; // default
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[NSUserDefaults standardUserDefaults] setFloat:_coldTemp forKey:@"coldTemp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      });
    }
  }
  
  return _coldTemp;
}

- (CGFloat)warmTemp
{
  if (_warmTemp == -1)
  {
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"warmTemp"])
    {
      _warmTemp = [[NSUserDefaults standardUserDefaults] floatForKey:@"warmTemp"];
    }
    else
    {
      _warmTemp = 60.0f; // default
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[NSUserDefaults standardUserDefaults] setFloat:_warmTemp forKey:@"warmTemp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      });
    }
  }
  
  return _warmTemp;
}


- (CGFloat)coldFlow
{
  if (_coldFlow == -1)
  {
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"coldFlow"])
    {
      _coldFlow = [[NSUserDefaults standardUserDefaults] floatForKey:@"coldFlow"];
    }
    else
    {
      _coldFlow = 12.0f; // default
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[NSUserDefaults standardUserDefaults] setFloat:_coldFlow forKey:@"coldFlow"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      });
    }
  }
  
  return _coldFlow;
}

- (CGFloat)warmFlow
{
  if (_warmFlow == -1)
  {
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"warmFlow"])
    {
      _warmFlow = [[NSUserDefaults standardUserDefaults] floatForKey:@"warmFlow"];
    }
    else
    {
      _warmFlow = 10.0f; // default
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [[NSUserDefaults standardUserDefaults] setFloat:_warmFlow forKey:@"warmFlow"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      });
    }
  }
  
  return _warmFlow;
}

- (void)setWarmFlow:(CGFloat)warmFlow
{
  if (_warmFlow != warmFlow)
  {
    _warmFlow = warmFlow;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
      
      [[NSUserDefaults standardUserDefaults] setFloat:warmFlow forKey:@"warmFlow"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      [self updatePositionTableUsing:self.coldTemp warmTemp:self.warmTemp coldFlow:self.coldFlow warmFlow:self.warmFlow];
    });
  }
}


- (void)setWarmTemp:(CGFloat)warmTemp
{
  if (warmTemp != _warmTemp)
  {
    _warmTemp = warmTemp;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
      
      [[NSUserDefaults standardUserDefaults] setFloat:warmTemp forKey:@"warmTemp"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      [self updatePositionTableUsing:self.coldTemp warmTemp:self.warmTemp coldFlow:self.coldFlow warmFlow:self.warmFlow];
    });
  }
}

- (void)setColdFlow:(CGFloat)coldFlow
{
  if (coldFlow != _coldFlow)
  {
    
    _coldFlow = coldFlow;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
      
      [[NSUserDefaults standardUserDefaults] setFloat:coldFlow forKey:@"coldFlow"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      [self updatePositionTableUsing:self.coldTemp warmTemp:self.warmTemp coldFlow:self.coldFlow warmFlow:self.warmFlow];
    });
  }
}

- (void)setColdTemp:(CGFloat)coldTemp
{
  if (coldTemp != _coldTemp)
  {
    _coldTemp = coldTemp;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
      
      [[NSUserDefaults standardUserDefaults] setFloat:coldTemp forKey:@"coldTemp"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      
      [self updatePositionTableUsing:self.coldTemp warmTemp:self.warmTemp coldFlow:self.coldFlow warmFlow:self.warmFlow];
    });
  }
}

- (id)init
{
  self = [super init];
  if (self)
  {
    [self reset];
    
    _coldTemp = -1;
    _coldFlow = -1;
    _warmFlow = -1;
    _warmTemp = -1;
    
    [self updatePositionTableUsing:self.coldTemp warmTemp:self.warmTemp coldFlow:self.coldFlow warmFlow:self.warmFlow];
  }
  
  return self;
}

- (void)setDefaults
{
  self.coldTemp = 10;
  self.warmTemp = 60;
  self.coldFlow = 12;
  self.warmFlow = 10;
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
  CGFloat t = (sampleMass*sampleTemperature) + (self.mass*self.temperature);
  CGFloat l = sampleMass + self.mass;
  self.temperature = t / l;
  
  self.mass += sampleMass;
  
  //  NSLog(@"sampleTemp: %f, sampleMass: %f, newTemperature:%f", sampleTemperature, sampleMass, self.temperature);
  
  return self.temperature;
}

- (void)updatePositionTableUsing:(CGFloat)coldTemp warmTemp:(CGFloat)warmTemp coldFlow:(CGFloat)coldFlow warmFlow:(CGFloat)warmFlow
{
  if (coldFlow == -1 || warmFlow == -1 || warmTemp == -1 || coldTemp == -1)
  {
    return;
  }
  
  temps_settings_t temps = precalcualte_table_for(coldFlow, warmFlow, coldTemp, warmTemp);
  
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:temps.size()];
  for(auto t : temps)
  {
    tapPositionAndRange_t *tp = [[tapPositionAndRange_t alloc] init];
    
    tp.coldTapPos = t.second.y;
    tp.warmTapPos = t.second.x;
    
    [dict setObject:tp forKey:[NSNumber numberWithFloat:t.first]];
  }
  
  self.position_table_for_temps = [dict copy];
}

@end


@implementation tapPositionAndRange_t
@end
