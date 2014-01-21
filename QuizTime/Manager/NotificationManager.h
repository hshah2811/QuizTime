//
//  NotificationManager.h
//  SlideTest
//
//  Created by Harshit on 12/28/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"
#import "QuizNotification.h"

@interface NotificationManager : NSObject
{
    DatabaseManager *dbManager;
}
-(NSMutableArray*)getAllNotification;
-(void)removeNotification:(NSString*)notificationId;
-(void)addNewNotification:(QuizNotification*)notification;
-(void)updateNotification:(QuizNotification*)notification;
-(void)reScheduleAllReminders;
-(QuizNotification*)getNotificationById:(NSString*)notificationId;
@end
