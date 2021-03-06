//
//  AppDelegate.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 03/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568.0f)

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ViewController *vc;
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Override point for customization after application launch.
  vc = [[ViewController alloc] initWithNibName:nil bundle:nil];

  self.viewController = vc;
  
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  
  NSString *d = @"Default.png";
  
  if (IS_IPHONE_5)
  {
    d = @"Default-568h.png";
  }
  
  UIImageView *splashScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:d]];
  [self.window.rootViewController.view addSubview:splashScreen];
  
  [self.window makeKeyAndVisible];
  
  [UIView animateWithDuration:0.3
                   animations:
   ^{
     splashScreen.alpha = 0.0;
   }
                   completion:(void (^)(BOOL))
   ^{
     [splashScreen removeFromSuperview];
   }
   ];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
