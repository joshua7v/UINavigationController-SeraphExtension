//
//  SENavigationTransition.h
//  SENavigationController
//
//  Created by Joshua on 15/7/30.
//  Copyright (c) 2015年 SigmaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SENavigationTransitionAnimationType) {
    SENavigationTransitionAnimationTypeFade = 0,
    SENavigationTransitionAnimationTypeSwing = 1
};

@interface SENavigationTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) CGFloat animationDuration;
@property (assign, nonatomic) SENavigationTransitionAnimationType animationType;
@property (assign, nonatomic) UINavigationControllerOperation navigationControllerOperation;
@end
