//
//  ViewController.m
//  QuizTime
//
//  Created by Harshit on 11/20/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "ViewController.h"
#import "QuestionViewController.h"
#import "ScoreBoardViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController
-(void)viewDidLoad
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if(delegate.notificationId != nil)
    {
        NotificationManager *notManager = [NotificationManager new];
        QuizNotification *notification = [notManager getNotificationById:delegate.notificationId];
        quizCategoryToBePresent = notification.quizCategory;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:quizCategoryToBePresent forKey:@"lastQuizCategory"];
        [userDefaults synchronize];
        delegate.notificationId = nil;
        [self startQuizForCategory];
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *lastQuizCategory = [userDefaults objectForKey:@"lastQuizCategory"];
        if (lastQuizCategory != nil)
        {
            quizCategoryToBePresent = lastQuizCategory;
        }
    }
    


    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"17.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *bck = [UIImage imageNamed:@"bg.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bck]];
    self.title = @"Quiz Time";
    [super viewDidLoad];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"QuestionView"])
    {
        // Get reference to the destination view controller
        QuestionViewController *vc = [segue destinationViewController];
        vc.quizCategoryToStart = quizCategoryToBePresent;
    }
    else if([[segue identifier] isEqualToString:@"scoreboard"])
    {
        // Get reference to the destination view controller
        ScoreBoardViewController *vc = [segue destinationViewController];
        vc.q_categoryId = quizCategoryToBePresent;
        
    }
}
-(IBAction)quizBtnClicked:(id)sender
{
    
    [self startQuizForCategory];
}
-(void)startQuizForCategory
{
    if(quizCategoryToBePresent == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No on going quiz available. Please set up reminder first." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
    QuestionSetManager *manger = [QuestionSetManager new];
    manger.qCategory = quizCategoryToBePresent;
    NSMutableArray *questions = [manger getQuestionsByStatus:Q_STATUS_PENDING];
    if (questions.count ==0)
    {
        [self performSegueWithIdentifier:@"scoreboard" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"QuestionView" sender:self];
    }
    }

    
}


@end
