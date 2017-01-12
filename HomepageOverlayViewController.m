//
//  HomepageOverlayViewController.m
//  LiveRowing
//
//  Created by Akio Yamadera on 2/2/16.
//
//

#import "HomepageOverlayViewController.h"

#import "BuildCustomWorkoutViewController.h"
#import "CustomWorkoutIntervalTableViewCell.h"
#import "FeaturedWorkoutsViewController.h"
#import "FriendsSelectViewController.h"
#import "HomePageOverlayTableViewCell.h"
#import "HomepageProfileOverlayViewController.h"
#import "RaceWorkout1ViewController.h"
#import "RaceFriendNextViewController.h"
#import "WorkoutsCustomIntervalViewController.h"

@interface HomepageOverlayViewController (){
    BOOL isDetailBtnTapped;
}

@end

@implementation HomepageOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    // Do any additional setup after loading the view.
    self.workoutType = [self fetchSegmentFromWorkoutType];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (WorkoutType*)fetchSegmentFromWorkoutType {
    if (!self.isCWActive) {
        return self.workoutOfCW;
    }else{
        return self.workoutOfQS;
    }

}

- (void)setValue:(iDashBoardQuickStartSlideType)slideTypeOfQS workoutQS:(id)workoutQS slideTypeCW:(iDashBoardCustomWorkoutSlideType)slideTypeOfCW workoutCW:(id)workoutCW isCWActive:(BOOL)isCWActive{
    _slideTypeOfQS = slideTypeOfQS;
    _slideTypeOfCW = slideTypeOfCW;
    
    _workoutOfQS = workoutQS;
    _workoutOfCW = workoutCW;
    
    _isCWActive = isCWActive;
}

- (void)setupTableView {
    
    [self.tv registerClass:[CustomWorkoutIntervalTableViewCell class] forCellReuseIdentifier:[CustomWorkoutIntervalTableViewCell reuseIdentifier]];
    [self.tv registerNib:[UINib nibWithNibName:[CustomWorkoutIntervalTableViewCell nibName] bundle:nil] forCellReuseIdentifier:[CustomWorkoutIntervalTableViewCell reuseIdentifier]];
    
    [self.tv registerClass:[HomePageOverlayTableViewCell class] forCellReuseIdentifier:[HomePageOverlayTableViewCell reuseIdentifier]];
    [self.tv registerNib:[UINib nibWithNibName:[HomePageOverlayTableViewCell nibName] bundle:nil] forCellReuseIdentifier:[HomePageOverlayTableViewCell reuseIdentifier]];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == 0) {
        if (!self.isCWActive){
            UIFont *cfont = [UIFont fontWithName:@"Lato-LightItalic" size:14.0f];
            CGSize constraint = CGSizeMake(SCREEN_WIDTH - 30.f, 20000.0f);
            
            CGRect workoutSegmentRect = [self.workoutType.segmentsDisplayDescription boundingRectWithSize:constraint
                                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:cfont}
                                                     context:nil];
            
            CGRect workoutDescriptionRect = [self.workoutType.descriptionText boundingRectWithSize:constraint
                                                      options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                   attributes:@{NSFontAttributeName:cfont}
                                                      context:nil];;
            
            UIDeviceOrientation toOrientation = [[UIDevice currentDevice] orientation];
            
            CGFloat threshold = 0;
            if (toOrientation == UIDeviceOrientationPortrait || toOrientation == UIDeviceOrientationPortraitUpsideDown){
                threshold = SCREEN_HEIGHT - 270.f - SCREEN_WIDTH * 234.f / 375.f;
            }else{
                threshold = SCREEN_HEIGHT - 238.f;
            }
            
            if (workoutSegmentRect.size.height + workoutDescriptionRect.size.height < threshold){
                return [HomePageOverlayTableViewCell neededHeight];
            }else{
                return UITableViewAutomaticDimension;
            }
        }else{
            return [HomePageOverlayTableViewCell neededHeight];
        }
    }else {
        return UITableViewAutomaticDimension;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.workoutType != nil) {
        return isDetailBtnTapped ? self.workoutType.segments.count + 1 : 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        HomePageOverlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomePageOverlayTableViewCell reuseIdentifier] forIndexPath:indexPath];
        if (!self.isCWActive){
            [cell setValue:self workoutType:self.workoutType type:_slideTypeOfCW];
        }else{
            [cell setValue:self workoutType:self.workoutType type:None];
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        
        CustomWorkoutIntervalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CustomWorkoutIntervalTableViewCell reuseIdentifier] forIndexPath:indexPath];
        [cell setupForSegment:[self.workoutType.segments objectAtIndex:indexPath.row - 1] withSegments:self.workoutType.segments useIndex:YES];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [HomePageOverlayTableViewCell neededHeight];
    }else{
        return [CustomWorkoutIntervalTableViewCell neededHeight];
    }
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [self topCellBtnsHidden:NO];
        
        [self floatingBtnsHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {

        [self topCellBtnsHidden:YES];
        
        [self floatingBtnsHidden:NO];
    }
}

- (void)goToLeaderBoardPopUp:(id)sender {
    NSString *identifierOfVC = @"HomepageProfileOverlayViewController";
    HomepageProfileOverlayViewController *vc = [[Helper getStoryboard] instantiateViewControllerWithIdentifier: identifierOfVC];
    vc.user = [PFUser currentUser];
    vc.directLeaderboardWorkoutType = self.workoutType;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)workOutAloneBtnTapped:(id)sender {
    if (!self.isCWActive) {
        switch (self.slideTypeOfCW) {
            case Featured:
            case AffiliateType:
            case Shared:
            case MyCustom:
            {
                [[CoreMachine sharedInstance] resetMachine];
                [CoreMachine sharedInstance].pfWorkoutType = self.workoutOfCW;
                RaceWorkout1ViewController *raceWorkout = [[Helper getStoryboard] instantiateViewControllerWithIdentifier:@"RaceWorkout1ViewController"];
                raceWorkout.pfFriend = nil;
                [self.homeVC.navigationController pushViewController:raceWorkout animated:YES];
                break;
            }
            case ChallengeReceived:
                
                break;
            default:
                break;
        }
    }else{
        switch (self.slideTypeOfQS) {
            case Meter:
            case Time:
            {
                [[CoreMachine sharedInstance] resetMachine];
                [CoreMachine sharedInstance].pfWorkoutType = self.workoutOfQS;
                RaceWorkout1ViewController *raceWorkout = [[Helper getStoryboard] instantiateViewControllerWithIdentifier:@"RaceWorkout1ViewController"];
                raceWorkout.pfFriend = nil;
                [self.homeVC.navigationController pushViewController:raceWorkout animated:YES];
                break;
            }
            case JustRow:
            {
                [[CoreMachine sharedInstance] resetMachine];
                
                [CoreMachine sharedInstance].isPaceBoat = NO;
                [CoreMachine sharedInstance].avgPaceSplit = @(0);
                
                [Helper startRowing:self.workoutOfQS withNavigationController:self.homeVC.navigationController];
                break;
            }
            default:
                break;
        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)challengeFriendsBtnTapped:(id)sender {
    
    if (!self.isCWActive) {
        switch (self.slideTypeOfCW) {
            case Featured:
            case AffiliateType:
            case Shared:
            case MyCustom:
            {
                [[CoreMachine sharedInstance] resetMachine];
                [CoreMachine sharedInstance].pfWorkoutType = self.workoutOfCW;
                
                RaceFriendNextViewController *vcSub = [[Helper getStoryboard] instantiateViewControllerWithIdentifier:@"RaceFriendNextViewController"];
                [self.homeVC.navigationController pushViewController:vcSub animated:YES];
                break;
            }
            case ChallengeReceived:
                
                break;
            default:
                break;
        }
    }else{
        switch (self.slideTypeOfQS) {
            case Meter:
            case Time:
            {
                [[CoreMachine sharedInstance] resetMachine];
                [CoreMachine sharedInstance].pfWorkoutType = self.workoutOfQS;
                
                RaceFriendNextViewController *vcSub = [[Helper getStoryboard] instantiateViewControllerWithIdentifier:@"RaceFriendNextViewController"];
                [self.homeVC.navigationController pushViewController:vcSub animated:YES];
                break;
            }
            case JustRow:
            {
                [[CoreMachine sharedInstance] resetMachine];
                
                [CoreMachine sharedInstance].isPaceBoat = NO;
                [CoreMachine sharedInstance].avgPaceSplit = @(0);
                
                [Helper startRowing:self.workoutOfQS withNavigationController:self.homeVC.navigationController];
                break;
            }
            default:
                break;
        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeToDashboardBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editBtnTapped:(id)sender {
    if (self.isCWActive) {
        [self presentCannotShareEditWorkoutInformation:@"Sorry, you can only Edit custom workouts built by you."];
    }else{

        [Helper showHUDWithStatus:nil blocking:YES];
        
        PFQuery *containedInChallengeQuery = [PFQuery queryWithClassName:[Challenge parseClassName]];
        [containedInChallengeQuery whereKey:PFChallengeWorkoutTypeKey equalTo:self.workoutType];
        
        [containedInChallengeQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (object != nil) {
                [Helper hideHUD];
                
                [self presentCannotShareEditWorkoutInformation:@"Sorry, Shared workouts can not be edited."];
            } else {
                [self.workoutType.sharedWith.query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    if (object != nil) {
                        [Helper hideHUD];
                        
                        [self presentCannotShareEditWorkoutInformation:@"Sorry, Shared workouts can not be edited."];
                    } else {
                        [self presentCustomWorkoutEditWorkflow:self.workoutType];
                    }
                }];
            }
        }];
    }
}

- (void)shareBtnTapped:(id)sender {
    if (self.isCWActive){
        [self presentCannotShareEditWorkoutInformation:@"Sorry, you cannot Share this workout. Only Custom Workouts built by you are sharable to friends."];
    }else {
        [WorkoutEditor sharedInstance].editingWorkoutType = self.workoutType;
        [WorkoutEditor sharedInstance].isEditingNewWorkoutType = NO;
        
        FriendsSelectViewController *viewController = [[Helper getStoryboard] instantiateViewControllerWithIdentifier:@"FriendsSelectViewController"];
        //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:viewController];
        //[self presentViewController:nc animated:YES completion:nil];
        [self.homeVC.navigationController showViewController:viewController sender:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)detailBtnTapped:(id)sender {
    if (self.workoutType.segments.count > 0){
        if (!isDetailBtnTapped){
            isDetailBtnTapped = YES;
            [self.tv reloadData];
            
            [self floatingBtnsHidden:YES];
        }

        [self.tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)presentCannotShareEditWorkoutInformation:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Not Allowed" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil] init];
    [alertController addAction:okayAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentCustomWorkoutEditWorkflow:(WorkoutType *)customWorkoutType {
    DLog(@"numID:%li", (long)[customWorkoutType.objectId integerValue]);
    [WorkoutEditor sharedInstance].editingWorkoutType = customWorkoutType;
    [WorkoutEditor sharedInstance].isEditingNewWorkoutType = NO;
    
    PFQuery *queryBest = [PFQuery queryWithClassName:[PersonalBest parseClassName]];
    [queryBest whereKey:PFPersonalBestUserKey equalTo:[PFUser currentUser]];
    [queryBest whereKey:PFPersonalBestWorkoutTypeKey equalTo:customWorkoutType];
    
    [queryBest getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [Helper hideHUD];
        
        if (object != nil) {
            [object deleteEventually];
        }
        
        if (customWorkoutType.valueType.integerValue == iWorkoutTypesCustom) {
            WorkoutsCustomIntervalViewController *customIntervalWorkoutVC = [[Helper getStoryboard] instantiateViewControllerWithIdentifier:[WorkoutsCustomIntervalViewController storyboardIdentifier]];
            [self.homeVC.navigationController showViewController:customIntervalWorkoutVC sender:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
            //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:customIntervalWorkoutVC];
            //[self presentViewController:nc animated:YES completion:nil];
        } else {
            BuildCustomWorkoutViewController *buildCustomWorkoutVC = [[Helper getStoryboard] instantiateViewControllerWithIdentifier:[BuildCustomWorkoutViewController storyboardIdentifier]];
            [self.homeVC.navigationController showViewController:buildCustomWorkoutVC sender:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
            //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:buildCustomWorkoutVC];
            //[self presentViewController:nc animated:YES completion:nil];
        }
    }];
}

/////// Utils

- (void)topCellBtnsHidden:(BOOL)hidden {
    HomePageOverlayTableViewCell *mainCell = (HomePageOverlayTableViewCell*)[self.tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (mainCell){
        mainCell.workAloneBtn.hidden = hidden;
        mainCell.challengeAFriendBtn.hidden = hidden;
        mainCell.closeBtn.hidden = hidden;
    }
}

- (void)floatingBtnsHidden:(BOOL)hidden {
    HomePageOverlayTableViewCell *mainCell = (HomePageOverlayTableViewCell*)[self.tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (mainCell){
        self.workAloneBtn.hidden = hidden;
        self.challengeWithFriendBtn.hidden = hidden;
        self.closeBtn.hidden = hidden;
    }
}

/////// Btn Handlers - outlets

- (IBAction)closeBtnTapped:(id)sender {
    [self closeToDashboardBtnTapped:sender];
}

- (IBAction)workAloneBtnTapped:(id)sender {
    [self workOutAloneBtnTapped:sender];
}

- (IBAction)challengeWithFriendsBtnTapped:(id)sender {
    [self challengeFriendsBtnTapped:sender];
}

@end
