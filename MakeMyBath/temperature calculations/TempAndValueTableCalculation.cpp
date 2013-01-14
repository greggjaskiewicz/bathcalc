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

typedef std::vector<xy_t> xys_t;
typedef std::map<double, xys_t> temps_t;

// calculate x and y
// (x*a) +  (y*b) = (c*x) + (c*y)

static const double calc_temp(double a, double b, double x, double y)
{
  double temperature = 0.0;
  double t, l;
  // ((Va * Ta) + (Vb * Tb)) / (Va+Vb) = Tf
  
  t = (x*a) + (y*b);
  l = x + y;
  temperature = t / l;

  return temperature;
}

static const temps_t discover(double flowx, double flowy, double tempx, double tempy)
{
  temps_t temps;
  
  for(double x=0.0001; x<=1.0; x+=0.001)
  {
    for(double y=0.0001; y<=1.0; y+=0.001)
    {
      double temp = roundf(calc_temp(tempy, tempx, y*flowy, x*flowx)*10);
      temp = temp/10.0;
      if (!(temp >= tempy && temp <= tempx))
      {
        continue;
      }
      
      xy_t xy;
      
      xy.x = x;
      xy.y = y;
      
      temps[temp].push_back(xy);
    }
  }
  
  return temps;
}

static const xy_t pick_best(xys_t &xys)
{
  xy_t best;
  best.x = 0;
  best.y = 0;
  
  for(xy_t xy : xys)
  {
    if (xy.y*xy.x > best.x*best.y && 1-(xy.x+xy.y) > 0 && 1-(xy.x+xy.y) < 1-(best.x+best.y)  )
    {
      best = xy;
    }
  }
  
  return best;
}

temps_settings_t precalcualte_table_for(double flowx, double flowy, double tempx, double tempy)
{
  temps_t temps;
  temps_settings_t best_settings;
  
  temps = discover(tempx, flowx, tempy, flowy);
  
  for(auto tempx : temps)
  {
    double temp = tempx.first;
    xys_t xys = tempx.second;
    xy_t best = pick_best(xys);

#ifdef _DEBUG_
    std::cout << "for temp:" << temp << " found " << xys.size() << " entries, best x:" << best.x << ", y: " << best.y << std::endl;
#endif
    
    best_settings[temp] = best;
  }
  
  //  std::cout << "done" << std::endl;
  return best_settings;
}

