//
//  NotificationManager.m
//  SlideTest
//
//  Created by Harshit on 12/28/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "NotificationManager.h"
#import "QuizCategoryManager.h"
#import "QuizCategory.h"
#define Q_NOTIFICATION_TABLE @"QUIZ_NOTIFICATION"
@implementation NotificationManager
-(id)init
{
    
    if (self = [super init])
    {
        dbManager = [DatabaseManager getDatabaseManager];
    }
    return self;
}
-(void)updateNotification:(QuizNotification*)notification
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notification];
    
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE %@ set notification = ?,category = ? ,status = ? WHERE id = ?",Q_NOTIFICATION_TABLE];
    [dbManager executeUpdateQuery:updateQuery withArgumetns:@[data,notification.quizCategory,notification.isActivated,notification.notificationID]];
}
-(void)addNewNotification:(QuizNotification*)notification
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notification];
    
    NSString *createTableQuery = [NSString stringWithFormat:@"create table if not exists %@ (id TEXT PRIMARY KEY DEFAULT NULL, notification BLOB, category TEXT, status TEXT);",Q_NOTIFICATION_TABLE];
    [dbManager executeUpdateQuery:createTableQuery];
    
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?,?)",Q_NOTIFICATION_TABLE];
    [dbManager executeUpdateQuery:insertQuery withArgumetns:@[notification.notificationID,data,notification.quizCategory,notification.isActivated]];
    
}
-(void)removeNotification:(NSString*)notificationId
{
     NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?",Q_NOTIFICATION_TABLE];
    [dbManager executeUpdateQuery:deleteQuery withArgumetns:@[notificationId]];
}
-(QuizNotification*)getNotificationById:(NSString*)notificationId
{
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ where id=?",Q_NOTIFICATION_TABLE];
    FMResultSet *resultSet =[dbManager executeDbQuery:selectQuery withArgumetns:@[notificationId]];
    while([resultSet next])
    {
        NSData *archivedData = [resultSet objectForColumnName:@"notification"];
        QuizNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        if(notification)
        {
            return notification;
        }
    }
    return nil;
}
-(NSMutableArray*)getAllNotification
{
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@",Q_NOTIFICATION_TABLE];
    FMResultSet *resultSet =[dbManager executeDbQuery:selectQuery withArgumetns:nil];
    NSMutableArray *notifications = [NSMutableArray array];
    while([resultSet next])
    {
        NSData *archivedData = [resultSet objectForColumnName:@"notification"];
        QuizNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        if(notification)
        {
            [notifications addObject:notification];
        }
    }
    return notifications;
}
-(void)reScheduleAllReminders
{
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil)
    {
        QuizCategoryManager *manager = [QuizCategoryManager new];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSMutableArray *allNotifications = [self getAllNotification];
        for (QuizNotification *notification in allNotifications)
        {
            if ([notification.isActivated boolValue] == FALSE) {
                continue;
            }
            QuizCategory *ct  = [manager getCategoryById:notification.quizCategory];
            NSDate *fireDate = notification.notificationTime;
            UILocalNotification *notif = [[cls alloc] init];
            notif.fireDate = fireDate;
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.alertBody = [NSString stringWithFormat:@"Its time for %@ Quiz",ct.categoryName];
            notif.alertAction = @"Let me try!!";
            notif.soundName = UILocalNotificationDefaultSoundName;
            notif.applicationIconBadgeNumber = 1;
            notif.repeatInterval = NSDayCalendarUnit;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:notification.notificationID  forKey:@"notificationId"];
            notif.userInfo = dic;
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        }
    }
}
@end
