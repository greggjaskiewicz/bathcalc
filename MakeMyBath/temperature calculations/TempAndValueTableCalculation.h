//
//  TempAndValueTableCalculation.h
//  BathCalc
//
//  Created by Greg Jaskiewicz on 12/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#ifndef __BathCalc__TempAndValueTableCalculation__
#define __BathCalc__TempAndValueTableCalculation__

#include <vector>
#include <map>

struct tapVal_t
{
  double cold;
  double warm;
};

typedef std::map<float, tapVal_t> tapValues_t;
tapValues_t precalcualte_table_for(const double coldFlow, const double warmFlow, const double coldTemp, const double warmTemp);


#endif /* defined(__BathCalc__TempAndValueTableCalculation__) */
