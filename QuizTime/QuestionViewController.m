//
//  QuestionViewController.m
//  SlideTest
//
//  Created by Harshit on 12/26/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "QuestionViewController.h"
//#import "SWRevealViewController.h"
#import "QuestionSetManager.h"
#import "QuizCategoryManager.h"
#import "ScoreBoardViewController.h"
@interface QuestionViewController ()

@end

@implementation QuestionViewController
@synthesize quizCategoryToStart;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) updateThemeAndGesture
{
    UITapGestureRecognizer* gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(option1Selected:)];
    
    
    [gesture1 setNumberOfTapsRequired:1];
    [_qOption1 setUserInteractionEnabled:YES];
    [_qOption1 addGestureRecognizer:gesture1];
    
    
    UITapGestureRecognizer* gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(option2Selected:)];
    
    [gesture2 setNumberOfTapsRequired:1];
    [_qOption2 setUserInteractionEnabled:YES];
    [_qOption2 addGestureRecognizer:gesture2];
    
    
    
    UITapGestureRecognizer* gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(option3Selected:)];
    
    [gesture3 setNumberOfTapsRequired:1];
    [_qOption3 setUserInteractionEnabled:YES];
    [_qOption3 addGestureRecognizer:gesture3];
    
    
    
    UITapGestureRecognizer* gesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(option4Selected:)];
    [gesture4 setNumberOfTapsRequired:1];
    [_qOption4 setUserInteractionEnabled:YES];
    [_qOption4 addGestureRecognizer:gesture4];
    
    
    _qOption1.layer.borderColor =  [[UIColor lightGrayColor] CGColor];
    _qOption1.layer.borderWidth =  1.0f;
    _qOption1.layer.cornerRadius =  6.0f;
    
    _qOption2.layer.borderColor =  [[UIColor lightGrayColor] CGColor];
    _qOption2.layer.borderWidth =  1.0f;
    _qOption2.layer.cornerRadius =  6.0f;
    
    _qOption3.layer.borderColor =  [[UIColor lightGrayColor] CGColor];
    _qOption3.layer.borderWidth =  1.0f;
    _qOption3.layer.cornerRadius =  6.0f;
    
    _qOption4.layer.borderColor =  [[UIColor lightGrayColor] CGColor];
    _qOption4.layer.borderWidth =  1.0f;
    _qOption4.layer.cornerRadius =  6.0f;
}
-(void)option1Selected:(id)sender
{
    NSLog(@"%@",self.currentQuestion.option1);
    [self markedAttempted:self.currentQuestion.option1 label:_qOption1];
}
-(void)option2Selected:(id)sender
{
    NSLog(@"%@",self.currentQuestion.option2);
    [self markedAttempted:self.currentQuestion.option2 label:_qOption2];
}
-(void)option3Selected:(id)sender
{
    NSLog(@"%@",self.currentQuestion.option3);
    
    [self markedAttempted:self.currentQuestion.option3 label:_qOption3];
}
-(void)option4Selected:(id)sender
{
    NSLog(@"%@",self.currentQuestion.option4);
    [self markedAttempted:self.currentQuestion.option4 label:_qOption4];
}

-(void) markedAttempted:(NSString*)option label:(id)sender
{
    UILabel *lbl = (UILabel*)sender;
    BOOL isValid = [self.currentQuestion isValidAnwer:option];
    [UIView transitionWithView:lbl duration:0.50 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        if (isValid) {
            lbl.backgroundColor= [UIColor greenColor];
        }
        else
        {
            lbl.backgroundColor = [UIColor redColor];
        }
    } completion:^(BOOL finished){
        if (finished){
            lbl.backgroundColor = [UIColor clearColor];
            [self.currentQuestion markAsAttempted:option isCorrectAnswer:isValid];
            [self loadNextQuestion];
        }
        
    }];
    
    
}
- (void)viewDidLoad
{
    //[self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"17.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *bck = [UIImage imageNamed:@"bg.png"];

    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bck]];
    QuizCategoryManager *categoryManager = [QuizCategoryManager new
                                            ];
    if (quizCategoryToStart == nil) {
        quizCategoryToStart = Q_CATEGORY_GK;
    }
    QuizCategory *category = [categoryManager getCategoryById:quizCategoryToStart];
    self.title = category.categoryName;
    qSetManager = [QuestionSetManager new];
    qSetManager.qCategory= category.categoryId;
   
    
//    _sidebarButton.target = self.revealViewController;
//    _sidebarButton.action = @selector(revealToggle:);
//    
    [self updateThemeAndGesture];
    [self loadNextQuestion];
     [super viewDidLoad];
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
	// Do any additional setup after loading the view.
}
-(IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)skipTheQuestion:(id)sender
{
    [self.currentQuestion markAsSkipped];
    [self loadNextQuestion];
}
-(void)loadNextQuestion
{
    NSMutableArray *questions = [qSetManager getQuestionsByStatus:Q_STATUS_PENDING];
    
//    int totalQ = [qSetManager getQuestionCountByStatus:nil];
//    int correctQ = [qSetManager getQuestionCountByStatus:Q_STATUS_CORRECT];
//    int wrongQ = [qSetManager getQuestionCountByStatus:Q_STATUS_WRONG];
//    int skippedQ = [qSetManager getQuestionCountByStatus:Q_STATUS_SKIPPED];
//    _noOfQuestions.text = [NSString stringWithFormat:@"%d",totalQ];
//    _CorrectLbl.text = [NSString stringWithFormat:@"%d",correctQ];
//    _WrongLbl.text = [NSString stringWithFormat:@"%d",wrongQ];
//    _SkippedLbl.text = [NSString stringWithFormat:@"%d",skippedQ];
//    
    if (questions.count>0) {
        self.currentQuestion = [questions objectAtIndex:0];
        _qOption1.text = self.currentQuestion.option1;
        _qOption2.text = self.currentQuestion.option2;
        _qOption3.text = self.currentQuestion.option3;
        _qOption4.text = self.currentQuestion.option4;
        _qText.text = self.currentQuestion.qContent;
        //_skipQuestion.hidden = FALSE;
        _qOption1.hidden = FALSE;
        _qOption2.hidden = FALSE;
        _qOption3.hidden = FALSE;
        _qOption4.hidden = FALSE;
        [self doPublicCATransition:0];
    }
    else
    {
        [self pushScoreBoard];
        self.currentQuestion = nil;
      //  _skipQuestion.hidden = TRUE;
        _qText.text = @"Quiz Finished!!";
        _qOption1.hidden = TRUE;
        _qOption2.hidden = TRUE;
        _qOption3.hidden = TRUE;
        _qOption4.hidden = TRUE;
    }
    
}
-(void)pushScoreBoard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScoreBoardViewController *scoreBoardViewController = (ScoreBoardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ScoreBoardViewController"];
    scoreBoardViewController.q_categoryId = qSetManager.qCategory;
    [self.navigationController pushViewController:scoreBoardViewController animated:YES];
    return;
    
}
- (void)doPublicCATransition:(int)tag
{
	CATransition *animation = [CATransition animation];
    //animation.delegate = self;
    animation.duration = 0.4f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
    
	//animation.removedOnCompletion = NO;
	
	//UIButton *theButton = (UIButton *)sender;
    
	/*
	 kCATransitionFade;
	 kCATransitionMoveIn;
	 kCATransitionPush;
	 kCATransitionReveal;
	 */
	/*
	 kCATransitionFromRight;
	 kCATransitionFromLeft;
	 kCATransitionFromTop;
	 kCATransitionFromBottom;
	 */
	switch (tag) {
		case 0:
			animation.type = kCATransitionPush;
			animation.subtype = kCATransitionFromRight;
			break;
		case 1:
			animation.type = kCATransitionMoveIn;
			animation.subtype = kCATransitionFromRight;
			break;
		case 2:
			animation.type = kCATransitionReveal;
			animation.subtype = kCATransitionFromLeft;
			break;
		case 3:
			animation.type = kCATransitionFade;
			animation.subtype = kCATransitionFromRight;
			break;
		default:
			break;
	}
	
	[self.questionView.layer addAnimation:animation forKey:@"animation"];
}
-(void)dealloc
{
    if(qSetManager)
    {
        qSetManager = nil;
    }
}



@end
