//
//  TemperatureCalculation.h
//  BathCalc
//
//  Created by Greg Jaskiewicz on 06/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tapPositionAndRange_t : NSObject

@property  CGFloat coldTapPos;
@property  CGFloat warmTapPos;

@end


@interface TemperatureCalculator : NSObject

@property(readonly) CGFloat temperature;
@property(readonly) CGFloat mass;
@property(readonly, strong) NSDictionary *position_table_for_temps;

@property(readonly, nonatomic) CGFloat coldTemp;
@property(readonly, nonatomic) CGFloat warmTemp;
@property(readonly, nonatomic) CGFloat coldFlow;
@property(readonly, nonatomic) CGFloat warmFlow;


- (CGFloat)updateCalculationWithTemperature:(CGFloat)sampleTemperature sampleMass:(CGFloat)sampleMass;
- (void)reset;
- (void)updatePositionTableUsing:(CGFloat)coldTemp warmTemp:(CGFloat)warmTemp coldFlow:(CGFloat)coldFlow warmFlow:(CGFloat)warmFlow;

@end
