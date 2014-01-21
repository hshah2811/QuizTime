//
//  ScoreBoardViewController.h
//  SlideTest
//
//  Created by Harshit on 1/1/14.
//  Copyright (c) 2014 iGEEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "QuestionSetManager.h"

@interface ScoreBoardViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>
{
    //NSArray *_sections;
    NSMutableArray *_testArray;
    QuestionSetManager *qSetManager;
}
@property (weak, nonatomic) IBOutlet UIButton *checkImage;
@property (weak, nonatomic)  NSString *q_categoryId;
@property (weak, nonatomic) IBOutlet UILabel *noOfCorrect;
@property (weak, nonatomic) IBOutlet UILabel *noOfWrong;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
