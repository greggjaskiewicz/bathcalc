//
//  TemperatureCalculation.h
//  MakeMyBath
//
//  Created by Greg Jaskiewicz on 06/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemperatureCalculator : NSObject

@property(readonly) CGFloat temperature;
@property(readonly) CGFloat mass;

- (CGFloat)updateCalculationWithTemperature:(CGFloat)sampleTemperature sampleMass:(CGFloat)sampleMass;
- (void)reset;

@end
