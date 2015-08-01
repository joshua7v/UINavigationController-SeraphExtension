//
//  SENavigationTransition.m
//  SENavigationController
//
//  Created by Joshua on 15/7/30.
//  Copyright (c) 2015年 SigmaStudio. All rights reserved.
//

#import "SENavigationTransition.h"

@implementation SENavigationTransition

- (instancetype)init {
    if (self = [super init]) {
        self.animationDuration = 0.25;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // Get the two view controllers
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // where the animation has to happen
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    switch (self.animationType) {
        case SENavigationTransitionAnimationTypeFade: {
            
            toVC.view.alpha = 0.0;
            
            // Perform the animation
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                                  delay:0
                                options:0
                             animations:^{
                                 toVC.view.alpha = 1.f;
                             }
                             completion:^(BOOL finished) {
                                 [fromVC.view removeFromSuperview];
                                 [transitionContext completeTransition:YES];
                             }];

            
            break;
        }
        case SENavigationTransitionAnimationTypeSwing: {
            
            CGAffineTransform transform;
            CGAffineTransform oppTransform;
            BOOL isPoping = NO;
            if (self.navigationControllerOperation == UINavigationControllerOperationPush) {
                isPoping = NO;
            } else {
                isPoping = YES;
            }
            
            transform = CGAffineTransformMakeRotation(M_PI_2);
            oppTransform = CGAffineTransformMakeRotation(-M_PI_2);
            
            toVC.view.transform = isPoping ? transform : oppTransform;
            
            toVC.view.layer.anchorPoint = CGPointMake(0, 0);
            fromVC.view.layer.anchorPoint = CGPointMake(0, 0);
            toVC.view.layer.position = CGPointMake(0, 0);
            fromVC.view.layer.position = CGPointMake(0, 0);
            
            // Perform the animation
            [UIView
                animateWithDuration:[self transitionDuration:transitionContext]
                delay:0
                usingSpringWithDamping:0.7
                initialSpringVelocity:0.8
                options:0
                animations:^{
                  toVC.view.transform = CGAffineTransformIdentity;
                  fromVC.view.transform = isPoping ? oppTransform : transform;
                }
                completion:^(BOOL finished) {
                  fromVC.view.transform = CGAffineTransformIdentity;
                  [fromVC.view removeFromSuperview];
                  [transitionContext completeTransition:YES];

                  toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
                  fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
                  toVC.view.layer.position =
                      CGPointMake(toVC.view.bounds.size.width / 2,
                                  toVC.view.bounds.size.height / 2);
                  fromVC.view.layer.position =
                      CGPointMake(toVC.view.bounds.size.width / 2,
                                  toVC.view.bounds.size.height / 2);
                }];

            break;
        }
        default:
            break;
    }
    
    
}

@end
