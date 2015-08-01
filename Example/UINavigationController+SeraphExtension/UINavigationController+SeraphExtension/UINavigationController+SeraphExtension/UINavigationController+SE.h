//
//  UINavigationController+SE.h
//  SENavigationController
//
//  Created by Joshua on 15/7/30.
//  Copyright (c) 2015年 SigmaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SENavigationDelegate.h"
@class SENavigationDelegate;

typedef NS_ENUM(NSInteger, SENavigationControllerAnimationType) {
    SENavigationControllerAnimationTypeSystem = 0,
    SENavigationControllerAnimationTypeDefault,
    SENavigationControllerAnimationTypeFade,
    SENavigationControllerAnimationTypeSwing,
    SENavigationControllerAnimationTypeCustom
};

@interface UINavigationController (SE)
@property (strong, nonatomic, readonly) NSMutableArray *screenShots;
@property (strong, nonatomic, readonly) UIImageView *lastVcView;
@property (strong, nonatomic, readonly) UIView *cover;
@property (strong, nonatomic, readonly) SENavigationTransition *defaultTransition;
@property (strong, nonatomic, readonly) SENavigationDelegate *navDelegate;
/**
 *  create a subclass of SENavigationTransition to custom animation
 */
@property (strong, nonatomic) SENavigationTransition *se_customTransition;
/**
 *  need a NSNumber wrapper, but actually its a BOOL value, default is NO
 */
@property (strong, nonatomic) NSNumber *se_hidesBottomBarWhenPushed;
/**
 *  need a NSNumber wrapper, but actually its a Double value, default is 0.25
 */
@property (strong, nonatomic) NSNumber *se_animationDuration;

/**
 *  push a viewController using different style
 *
 *  @param viewController the vc will be pushed
 *  @param animated       whether using animation
 *  @param type           animation type
 */
- (void)se_pushViewController:(UIViewController *)viewController animated:(BOOL)animated type:(SENavigationControllerAnimationType)type;
/**
 *  pop a viewController using different style
 *
 *  @param animated whether using animation
 *  @param type     animation type
 *
 *  @return the vc will be poped
 */
- (UIViewController *)se_popViewControllerAnimated:(BOOL)animated type:(SENavigationControllerAnimationType)type;
@end
