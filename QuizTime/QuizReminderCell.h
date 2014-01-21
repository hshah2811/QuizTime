//
//  QuizReminderCell.h
//  QuizTime
//
//  Created by Harshit on 1/4/14.
//  Copyright (c) 2014 iGEEK. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuizReminderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reminderTime;
@property (weak, nonatomic) IBOutlet UILabel *quizName;
@property (weak, nonatomic) IBOutlet UIButton *addReminder;
@property (weak, nonatomic) IBOutlet UILabel *addNewText;
@property (weak, nonatomic) IBOutlet UISwitch *controlSwitch;
@end