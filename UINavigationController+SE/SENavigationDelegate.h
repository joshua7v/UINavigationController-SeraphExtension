//
//  SENavigationDelegate.h
//  SENavigationController
//
//  Created by Joshua on 15/7/30.
//  Copyright (c) 2015年 SigmaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SENavigationTransition.h"
@class SENavigationTransition;

@interface SENavigationDelegate : NSObject <UINavigationControllerDelegate>
@property (assign, nonatomic) SENavigationTransitionAnimationType animationType;
@property (strong, nonatomic) SENavigationTransition *transition;
@property (assign, nonatomic) CGFloat animationDuration;
@end
