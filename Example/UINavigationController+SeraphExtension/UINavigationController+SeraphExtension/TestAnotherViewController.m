//
//  TestAnotherViewController.m
//  SENavigationController
//
//  Created by Joshua on 15/7/30.
//  Copyright (c) 2015年 SigmaStudio. All rights reserved.
//

#import "TestAnotherViewController.h"
#import "TestTransition.h"
#import "UINavigationController+SE.h"

@interface TestAnotherViewController ()
@property (strong, nonatomic) UITableViewController *nextTableViewController;
@property (assign, nonatomic) SENavigationControllerAnimationType animationType;
@property (strong, nonatomic) TestTransition *transition;
@end

@implementation TestAnotherViewController

- (IBAction)systemType {
    self.animationType = SENavigationControllerAnimationTypeSystem;
//    self.navigationController.se_hidesBottomBarWhenPushed = [NSNumber numberWithBool:NO];
    [self.navigationController se_pushViewController:self.nextTableViewController animated:YES type:self.animationType];
}

- (IBAction)defaultType {
    self.animationType = SENavigationControllerAnimationTypeDefault;
    self.navigationController.se_animationDuration = [NSNumber numberWithDouble:0.25];
    self.navigationController.se_hidesBottomBarWhenPushed = [NSNumber numberWithBool:NO];
    [self.navigationController se_pushViewController:self.nextTableViewController animated:YES type:self.animationType];
}

- (IBAction)fadeType {
    self.animationType = SENavigationControllerAnimationTypeFade;
//    self.navigationController.se_hidesBottomBarWhenPushed = [NSNumber numberWithBool:NO];
    [self.navigationController se_pushViewController:self.nextTableViewController animated:YES type:self.animationType];
}

- (IBAction)swingType {
    self.animationType = SENavigationControllerAnimationTypeSwing;
    [self.navigationController se_pushViewController:self.nextTableViewController animated:YES type:self.animationType];
}

- (IBAction)customType {
    self.animationType = SENavigationControllerAnimationTypeCustom;
    self.transition = [[TestTransition alloc] init];
    self.navigationController.se_customTransition = self.transition;
//    self.navigationController.se_hidesBottomBarWhenPushed = [NSNumber numberWithBool:NO];
    [self.navigationController se_pushViewController:self.nextTableViewController animated:YES type:self.animationType];
}

- (void)handlePop {
    [self.navigationController se_popViewControllerAnimated:YES type:self.animationType];
}

- (UITableViewController *)nextTableViewController {
    if (!_nextTableViewController) {
        _nextTableViewController = [UITableViewController new];
        _nextTableViewController.view.backgroundColor = [UIColor whiteColor];
        _nextTableViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"pop" style:UIBarButtonItemStylePlain target:self action:@selector(handlePop)];
    }
    return _nextTableViewController;
}

@end
