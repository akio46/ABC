//
//  HomepageOverlayViewController.h
//  LiveRowing
//
//  Created by Akio Yamadera on 2/2/16.
//
//

#import "DebugViewController.h"
#import "HomePageViewController.h"

@interface HomepageOverlayViewController : DebugViewController <UITableViewDataSource, UITableViewDelegate> {
    
}

/// ----------- Workout Data -------------
@property (nonatomic, assign) iDashBoardQuickStartSlideType slideTypeOfQS;
@property (nonatomic, weak) id workoutOfQS;

@property (nonatomic, assign) iDashBoardCustomWorkoutSlideType slideTypeOfCW;
@property (nonatomic, weak) id workoutOfCW;

@property BOOL isCWActive;
@property (nonatomic, weak) UIViewController* homeVC;

@property (nonatomic, weak) WorkoutType *workoutType;
// ------------ UI Instances -------------

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIButton *workAloneBtn;
@property (weak, nonatomic) IBOutlet UIButton *challengeWithFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

// ------------ Method -------------------

- (void)setValue:(iDashBoardQuickStartSlideType)slideTypeOfQS workoutQS:(id)workoutQS slideTypeCW:(iDashBoardCustomWorkoutSlideType)slideTypeOfCW workoutCW:(id)workoutCW isCWActive:(BOOL)isCWActive;

- (void)goToLeaderBoardPopUp:(id)sender;
- (void)workOutAloneBtnTapped:(id)sender;
- (void)challengeFriendsBtnTapped:(id)sender;
- (void)closeToDashboardBtnTapped:(id)sender;
- (void)editBtnTapped:(id)sender;
- (void)shareBtnTapped:(id)sender;
- (void)detailBtnTapped:(id)sender;

@end
