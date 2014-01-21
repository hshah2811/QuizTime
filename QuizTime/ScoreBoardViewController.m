//
//  ScoreBoardViewController.m
//  SlideTest
//
//  Created by Harshit on 1/1/14.
//  Copyright (c) 2014 iGEEK. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "UMTableViewCell.h"
//#import "SWRevealViewController.h"

@interface ScoreBoardViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL useCustomCells;
@end

@implementation ScoreBoardViewController

@synthesize q_categoryId;

- (void)viewDidLoad
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"17.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *bck = [UIImage imageNamed:@"bg.png"];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(backClicked:)];
    [leftBtn setTintColor:[UIColor blackColor]];
    self.title = @"Score";
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bck]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.allowsSelection = NO; // We essentially implement our own selection
    

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"lastQuizCategory"];
    [userDefaults synchronize];
    
    qSetManager = [QuestionSetManager new];
    qSetManager.qCategory= q_categoryId;

    int noOfCorrectAns = [qSetManager getQuestionCountByStatus:Q_STATUS_CORRECT];
    int noOfWrongAns = [qSetManager getQuestionCountByStatus:Q_STATUS_WRONG];
    
    int totalQuest = [qSetManager getQuestionCountByStatus:nil];
    
    _noOfCorrect.text = [NSString stringWithFormat:@"%d/%d",noOfCorrectAns,totalQuest];
    _noOfWrong.text = [NSString stringWithFormat:@"%d/%d",noOfWrongAns,totalQuest];
    // If you set the seperator inset on iOS 6 you get a NSInvalidArgumentException...weird
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
   
    
    _testArray = [[NSMutableArray alloc] init];
    
    self.useCustomCells = YES;
    
 
    NSMutableArray *totalQuestions = [qSetManager getQuestionsByStatus:nil];
    for (int i = 0; i < totalQuestions.count; ++i) {
        Question *q = [totalQuestions objectAtIndex:i];
//        NSString *string = [NSString stringWithFormat:@"%d", i];
        [_testArray addObject:q];
    }
    [super viewDidLoad];

   
}
-(IBAction)backClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_testArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"cell selected at index path %d:%d", indexPath.section, indexPath.row);
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return _sections[section];
//}
// BOOL flagLastCorrect = FALSE;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.useCustomCells)
    {
        UMTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UMCell" forIndexPath:indexPath];
        [cell setCellHeight:cell.frame.size.height];
        cell.containingTableView = tableView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Question *q = _testArray[indexPath.row];
        cell.label.text = q.qContent;
        
        if ([q.status isEqualToString:Q_STATUS_CORRECT])

        {
            [cell.resultImage setBackgroundColor:[UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]];
            [cell.resultImage setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.resultImage setBackgroundColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]];
            [cell.resultImage setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
            
        }
        cell.correctAns.text = q.correctAnswer;
        [cell.correctAns setTextColor:[UIColor magentaColor]];
//        [cell.correctAns setTintColor:[UIColor magentaColor]];
        //flagLastCorrect = !flagLastCorrect;
//        cell.label.text = [NSString stringWithFormat:@"Section: %d, Seat: %d", indexPath.section, indexPath.row];
        
// rightButtons       cell.leftUtilityButtons = [self leftButtons];
//        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Cell";
        
        SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:_tableView // Used for row height and selection
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:nil];
            cell.delegate = self;
        }
       // NSLog(@"%d",indexPath.row);
        Question *q = _testArray[indexPath.row];
        cell.textLabel.text = q.qContent;
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
       // cell.detailTextLabel.text = @"Some detail text";
        
        return cell;
    }
}

//- (NSArray *)rightButtons
//{
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    
//       [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"check.png"]];
//      [rightUtilityButtons sw_addUtilityButtonWithColor:
//         [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
//                                                    icon:[UIImage imageNamed:@"cross.png"]];
//    
//    return rightUtilityButtons;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
