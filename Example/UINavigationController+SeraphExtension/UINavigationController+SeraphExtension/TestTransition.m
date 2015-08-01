//
//  SETransition.m
//  SEAlertView
//
//  Created by Joshua on 15/5/26.
//  Copyright (c) 2015年 SigmaStudio. All rights reserved.
//

#import "TestTransition.h"

@implementation TestTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Get the two view controllers
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Get the container view - where the animation has to happen
    UIView *containerView = [transitionContext containerView];
    
    // Add the two VC views to the container.
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    
    toVC.view.alpha = 0.0;
    toVC.view.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
    // Perform the animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:0
                     animations:^{
                         toVC.view.alpha = 1.f;
                         toVC.view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         // Let's get rid of the old VC view
                         [fromVC.view removeFromSuperview];
                         // And then we need to tell the context that we're done
                         [transitionContext completeTransition:YES];
                     }];
}

@end
