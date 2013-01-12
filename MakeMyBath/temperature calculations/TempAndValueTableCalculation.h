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

struct xy_t
{
  double x;
  double y;
};

typedef std::map<float, xy_t> temps_settings_t;
temps_settings_t precalcualte_table_for(double flowx, double flowy, double tempx, double tempy);


#endif /* defined(__BathCalc__TempAndValueTableCalculation__) */
