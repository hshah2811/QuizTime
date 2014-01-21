//
//  AppDelegate.m
//  QuizTime
//
//  Created by Harshit on 11/20/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "AppDelegate.h"
#import "AppStateHandler.h"
#import "QuizCategory.h"
#import "QuizCategoryManager.h"
#import "Question.h"

@implementation AppDelegate
@synthesize notificationId;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AppStateHandler loadDataFromPlistIfRequired];
    
    
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification)
    {
        
        notificationId = [localNotification.userInfo objectForKey:@"notificationId"];
        
    }
    else
    {
        notificationId = nil;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Override point for customization after application launch.
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
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString* categoryId = [notification.userInfo objectForKey:@"categoryId"];
    
    QuizCategory *cat = [[QuizCategoryManager new] getCategoryById:categoryId];
    NSString *message = [NSString stringWithFormat:@"Its time for %@ quiz.",cat.categoryName];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
	[alertView show];
    
}
@end
