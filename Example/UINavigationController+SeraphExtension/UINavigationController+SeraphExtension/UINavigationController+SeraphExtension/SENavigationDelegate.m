//
//  SENavigationDelegate.m
//  SENavigationController
//
//  Created by Joshua on 15/7/30.
//  Copyright (c) 2015年 SigmaStudio. All rights reserved.
//

#import "SENavigationDelegate.h"
#import "SENavigationTransition.h"

@implementation SENavigationDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    self.transition.navigationControllerOperation = operation;
    
    return self.transition;
}

- (void)setAnimationType:(SENavigationTransitionAnimationType)animationType {
    _animationType = animationType;
    
    self.transition.animationType = _animationType;
}

- (SENavigationTransition *)transition {
    if (!_transition) {
        _transition = [SENavigationTransition new];
    }
    return _transition;
}

- (void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
    
    self.transition.animationDuration = animationDuration;
}

@end
