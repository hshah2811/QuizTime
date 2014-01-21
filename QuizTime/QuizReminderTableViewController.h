//
//  QuizReminderTableViewController.h
//  QuizTime
//
//  Created by Harshit on 1/4/14.
//  Copyright (c) 2014 iGEEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectConstants.h"
@interface QuizReminderTableViewController : UITableViewController
{
    NSMutableArray *totalReminders;
    QuizCategoryManager *manager;
    NotificationManager *notificationManager;
    NSString* selectedReminderId;
}
@property (strong,nonatomic) IBOutlet UITableView *reminderTable;
@end

