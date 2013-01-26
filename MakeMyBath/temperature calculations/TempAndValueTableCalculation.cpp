//
//  TempAndValueTableCalculation.cpp
//  BathCalc
//
//  Created by Greg Jaskiewicz on 12/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#include "TempAndValueTableCalculation.h"

#include <iostream>
#include <cmath>
#include <limits>
#include <vector>
#include <map>

typedef std::vector<tapVal_t> tapsValArray_t;

typedef std::map<double, tapsValArray_t> temps_t;

// calculate x and y
// (x*a) +  (y*b) = (c*x) + (c*y)

static const double calc_temp(const double warmtemp, const double coldtemp, const double warmflow, const double coldflow)
{
  double temperature = 0.0;
  double t, l;
  // ((Va * Ta) + (Vb * Tb)) / (Va+Vb) = Tf
  
  t = (coldflow*coldtemp) + (warmflow*warmtemp);
  l = warmflow + coldflow;
  temperature = t / l;

  return temperature;
}

static const temps_t discover(const double coldFlow, const double warmFlow, const double coldTemp, const double warmTemp)
{
  temps_t temps;
  
  for(double coldtap=0.0001; coldtap<=1.0; coldtap+=0.0025)
  {
    for(double warmtap=0.0001; warmtap<=1.0; warmtap+=0.0025)
    {
      double temp = roundf(calc_temp(warmTemp, coldTemp, warmtap*warmFlow, coldtap*coldFlow)*5);
      temp = temp/5.0;
      if (!(temp >= coldTemp && temp <= warmTemp))
      {
        continue;
      }
      
      tapVal_t xy;
      
      xy.warm = warmtap;
      xy.cold = coldtap;
      
      temps[temp].push_back(xy);
    }
  }
  
  return temps;
}

static const tapVal_t pick_best(const tapsValArray_t &xys)
{
  tapVal_t best;
  best.warm = 0;
  best.cold = 0;
  
  for(tapVal_t xy : xys)
  {
    if (xy.cold+xy.warm > best.warm+best.cold  &&  1-(xy.warm+xy.cold) > 0  &&  1-(xy.warm+xy.cold) < 1-(best.warm+best.cold))
    {
      best = xy;
    }
  }
  
  return best;
}

tapValues_t precalcualte_table_for(const double coldFlow, const double warmFlow, const double coldTemp, const double warmTemp)
{
  temps_t temps;
  tapValues_t best_settings;

  temps = discover(coldFlow, warmFlow, coldTemp, warmTemp);
  
  for(auto tempx : temps)
  {
    double temp = tempx.first;
    tapsValArray_t xys = tempx.second;
    tapVal_t best = pick_best(xys);

#ifdef DEBUG
    //    std::cout << "for temp:" << temp << " found " << xys.size() << " entries, best warm:" << best.warm << ", cold: " << best.cold << std::endl;
#endif
    
    best_settings[temp] = best;
  }
  
  //  std::cout << "done" << std::endl;
  return best_settings;
}

