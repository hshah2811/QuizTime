//
//  QuizReminderTableViewController.m
//  QuizTime
//
//  Created by Harshit on 1/4/14.
//  Copyright (c) 2014 iGEEK. All rights reserved.
//

#import "QuizReminderTableViewController.h"
#import "QuizReminderCell.h"
#import "RemindMeViewController.h"

@interface QuizReminderTableViewController ()

@end

@implementation QuizReminderTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self populateTable];
    
}
-(void)populateTable
{
    if (totalReminders) {
        [totalReminders removeAllObjects];
        totalReminders = nil;
    }
    NSMutableArray *noOfScheduled = [NSMutableArray arrayWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];
    NSLog(@"%d",noOfScheduled.count);
    
    totalReminders = [NSMutableArray arrayWithArray:[notificationManager getAllNotification]];
    
    selectedReminderId = nil;
    [_reminderTable reloadData];
    
}

- (void)viewDidLoad
{
    manager = [QuizCategoryManager new];
    notificationManager = [NotificationManager new];
   
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                style:UIBarButtonItemStyleDone target:self action:@selector(backClicked:)];
    [leftBtn setTintColor:[UIColor blackColor]];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.title = @"Quiz Reminders";

  
     [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return totalReminders.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"ReminderCell";
    static NSString *AddReminderCell = @"AddReminderCell";
    if (indexPath.row == totalReminders.count )
    {
        QuizReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:AddReminderCell];
        cell.addNewText.hidden = FALSE;
        cell.addReminder.hidden = FALSE;
        //cell.reminderTime.hidden = TRUE;
        //cell.quizName.hidden = TRUE;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    else
    {
        QuizReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        QuizNotification *notification = [totalReminders objectAtIndex:indexPath.row];
        if (notification)
        {
            //NSString *category = [notification.userInfo objectForKey:@"categoryId"];
            QuizCategory *ct  = [manager getCategoryById:notification.quizCategory];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setTimeStyle:NSDateFormatterShortStyle];
            cell.reminderTime.text = [format stringFromDate:notification.notificationTime];
            cell.quizName.text = ct.categoryName;
            cell.addNewText.hidden = TRUE;
            cell.addReminder.hidden = TRUE;
            cell.controlSwitch.tag = indexPath.row;
            [cell.controlSwitch setOn:[notification.isActivated boolValue]];
        }
    
    // Configure the cell...
    
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    QuizNotification *notification = [totalReminders objectAtIndex:indexPath.row];
    selectedReminderId = notification.notificationID;
    [self performSegueWithIdentifier:@"AddNewReminder" sender:self];
}
- (IBAction)changeSwitch:(id)sender{
    
    UISwitch *swth = (UISwitch*)sender;
    QuizNotification *notificaion = [totalReminders objectAtIndex:swth.tag];
    if([sender isOn]){
        notificaion.isActivated = @"TRUE";
        NSLog(@"Switch is ON");
    } else
    {
        notificaion.isActivated = @"FALSE";
        NSLog(@"Switch is OFF");
    }
    [notificationManager updateNotification:notificaion];
    [notificationManager reScheduleAllReminders];
}
-(IBAction)addNewReminder:(id)sender
{
     [self performSegueWithIdentifier:@"AddNewReminder" sender:self];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == totalReminders.count) {
        return FALSE;
    }
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
                [tableView beginUpdates];
        QuizNotification *selectedNotification = [totalReminders objectAtIndex:indexPath.row];
        [notificationManager removeNotification:selectedNotification.notificationID];
       // int pth = indexPath.row;
       // int sec = indexPath.section;
      //  NSIndexPath *path = [NSIndexPath indexPathForItem:(indexPath.row-1) inSection:0];
        [totalReminders removeObjectAtIndex:indexPath.row];
        [notificationManager reScheduleAllReminders];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];

    }   
    
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddNewReminder"])
    {
        // Get reference to the destination view controller
        
        RemindMeViewController *vc = [segue destinationViewController];
        vc.reminderDetailToPresent = selectedReminderId;
    }
}


@end


