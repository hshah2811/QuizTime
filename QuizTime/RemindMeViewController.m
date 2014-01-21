//
//  RemindMeViewController.m
//
//  Created by Keith Harrison on 12/07/2010 http://useyourloaf.com
//  Copyright (c) 2010 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  Neither the name of Keith Harrison nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ''AS IS'' AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

#import "RemindMeViewController.h"
#import "AppDelegate.h"

#include <stdlib.h>
@implementation RemindMeViewController
@synthesize datePicker;



#pragma mark -
#pragma mark === Initialization and shutdown ===
#pragma mark -

- (void)viewDidLoad {
	
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"17.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *bck = [UIImage imageNamed:@"bg.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bck]];

    
    QuizCategoryManager *manager =  [QuizCategoryManager new];
    notificationManager = [NotificationManager new];
     totalCategories = [manager getAllCategories];
//	datePicker.minimumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeTime;
  //  _sidebarButton.target = self.revealViewController;
//    _sidebarButton.action = @selector(revealToggle:);
    
    //configure swipe view
    _swipeView.alignment = SwipeViewAlignmentCenter;
    _swipeView.pagingEnabled = YES;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    
    if (_reminderDetailToPresent != nil) {
        QuizNotification *not = [notificationManager getNotificationById:_reminderDetailToPresent];
        QuizCategory *category = [manager getCategoryById:not.quizCategory];
        [datePicker setDate:not.notificationTime];
        [self performSelector:@selector(defaultCategorySelected:) withObject:category afterDelay:0.5f];
    }
    
}

-(void)defaultCategorySelected:(QuizCategory*)categoryToBePresent
{
    int itemIndex = -1;
    NSLog(@"%@",categoryToBePresent.categoryName);
    for (int i=0;i<totalCategories.count;i++)
    {
        QuizCategory *category = [totalCategories objectAtIndex:i];
        if ([category.categoryId isEqualToString:categoryToBePresent.categoryId]) {
            itemIndex = i;
            break;
        }
    }
    if (itemIndex != -1)
    {
        lastSelectedItemIndex = itemIndex;
        [_swipeView scrollToItemAtIndex:itemIndex duration:1.0f];
        UIView *lastSeletedview = [_swipeView itemViewAtIndex:lastSelectedItemIndex];
        UIButton *pressBtn = (UIButton*)[lastSeletedview viewWithTag:4444];
        if ([pressBtn isKindOfClass:[UIButton class]]) {
            //UIButton *btn = (UIButton*)lastSeletedview;
            [pressBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
        }

        
    }
}
- (void)viewDidUnload {
	
	[super viewDidUnload];
	self.datePicker = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return NO;
}


#pragma mark -
#pragma mark === Text Field Delegate ===
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark === View Actions ===
#pragma mark -

- (void)clearNotification {
	
	//[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)scheduleNotification {

    if (lastSelectedItemIndex == -1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Please select QUIZ category." delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    QuizCategory *cat = [totalCategories objectAtIndex:lastSelectedItemIndex];
    
    QuizNotification *notification =  nil;
    if (_reminderDetailToPresent != nil) {
        notification = [notificationManager getNotificationById:_reminderDetailToPresent];
    }
    else
    {
        notification = [[QuizNotification alloc]init];
        int number = arc4random_uniform(1000000);
        notification.notificationID = [NSString stringWithFormat:@"%d",number];
    }

    notification.quizCategory = cat.categoryId;
    notification.isActivated= @"YES";
    NSDate *date = [datePicker date];
    NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    notification.notificationTime =  [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    notification.numberOfQuestions= @"5";
    if (_reminderDetailToPresent != nil) {
    [notificationManager updateNotification:notification];
    }
    else
    {
       [notificationManager addNewNotification:notification];
    }
    [notificationManager reScheduleAllReminders];
//    [self scheduleQuizNotification:notification];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    return totalCategories.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
    	//load new item view instance from nib
        //control events are bound to view controller in nib file
        //note that it is only safe to use the reusingView if we return the same nib for each
        //item view, if different items have different contents, ignore the reusingView value
    	view = [[NSBundle mainBundle] loadNibNamed:@"ItemView" owner:self options:nil][0];
        UIButton *pressBtn = (UIButton*)[view viewWithTag:4444];
        if (pressBtn) {
            QuizCategory *cat = [totalCategories objectAtIndex:index];
            [pressBtn setTitle:cat.categoryName forState:UIControlStateNormal];
        }

    }
        return view;
}


#pragma mark -
#pragma mark === Public Methods ===
#pragma mark -

static int lastSelectedItemIndex = -1;
- (IBAction)pressedButton:(id)sender
{
    int index = [_swipeView indexOfItemViewOrSubview:sender];
    //Reset Last selected Item index.
    if (lastSelectedItemIndex != -1 && lastSelectedItemIndex != index) {
        UIView *lastSeletedview = [_swipeView itemViewAtIndex:lastSelectedItemIndex];
        UIButton *pressBtn = (UIButton*)[lastSeletedview viewWithTag:4444];
        if ([pressBtn isKindOfClass:[UIButton class]]) {
            //UIButton *btn = (UIButton*)lastSeletedview;
            [pressBtn setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        }
        
    }
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *currentBtn = (UIButton*)sender;
        [currentBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    }
    lastSelectedItemIndex = index;
    [_swipeView scrollToItemAtIndex:index duration:0.5];
  }

- (void)showReminder:(NSString *)text {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" 
											message:text delegate:nil
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
	[alertView show];
	//[alertView release];
}
- (IBAction)dismissMe:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
