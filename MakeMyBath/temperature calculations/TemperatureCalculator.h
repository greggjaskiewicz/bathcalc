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

@property(readonly, strong) NSDictionary *position_table_for_temps;
@property(readonly)  CGFloat temperature;
@property(readonly)  CGFloat mass;

@property(nonatomic) CGFloat coldTemp;
@property(nonatomic) CGFloat warmTemp;
@property(nonatomic) CGFloat coldFlow;
@property(nonatomic) CGFloat warmFlow;


- (CGFloat)updateCalculationWithTemperature:(CGFloat)sampleTemperature sampleMass:(CGFloat)sampleMass;
- (void)reset;
- (void)setDefaults;
- (void)updatePositionTable;

@end
