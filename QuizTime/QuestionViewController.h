//
//  QuestionViewController.h
//  SlideTest
//
//  Created by Harshit on 12/26/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectConstants.h"

@interface QuestionViewController : UIViewController
{
    QuestionSetManager *qSetManager;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *qText;
@property (weak, nonatomic) IBOutlet UILabel *qOption1;
@property (weak, nonatomic) IBOutlet UILabel *qOption2;
@property (weak, nonatomic) IBOutlet UILabel *qOption3;
@property (weak, nonatomic) IBOutlet UILabel *qOption4;
@property (strong, nonatomic) Question *currentQuestion;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (strong, nonatomic) NSString *quizCategoryToStart;
-(void) markedAttempted:(NSString*)option label:(id)sender;
@end
