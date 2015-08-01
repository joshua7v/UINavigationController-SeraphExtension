//
//  UINavigationController+SE.m
//  SENavigationController
//
//  Created by Joshua on 15/7/30.
//  Copyright (c) 2015年 SigmaStudio. All rights reserved.
//

#import "UINavigationController+SE.h"
#import "SEPangestureRecognizer.h"
#import <objc/runtime.h>
#import "UIView+SE.h"

static NSString *const kSECustomTransitionErrorMessage =  @"need to set se_customTransition object of UINavigationController's navDelegate first \
if you were using custom transition";

static const void *screenShotsKey = &screenShotsKey;
static const void *lastVcViewKey = &lastVcViewKey;
static const void *coverKey = &coverKey;
static const void *navDelegateKey = &navDelegateKey;
static const void *defaultTransitionKey = &defaultTransitionKey;
static const void *se_hidesBottomBarWhenPushedKey = &se_hidesBottomBarWhenPushedKey;
static const void *se_animationDurationKey = &se_animationDurationKey;
static const void *se_customTransitionKey = &se_customTransitionKey;
static const CGFloat kSENavigationControllerAnimationDuration = 0.25;

@implementation UINavigationController (SE)
@dynamic screenShots;
@dynamic lastVcView;
@dynamic cover;
@dynamic defaultTransition;
@dynamic navDelegate;
@dynamic se_hidesBottomBarWhenPushed;
@dynamic se_animationDuration;
@dynamic se_customTransition;

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSe_hidesBottomBarWhenPushed:[NSNumber numberWithBool:NO]];
    [self setSe_animationDuration:[NSNumber numberWithDouble:kSENavigationControllerAnimationDuration]];
    [self setDefaultTransition:[SENavigationTransition new]];
    [self setSe_customTransition:self.defaultTransition];
}

- (void)se_pushViewController:(UIViewController *)viewController animated:(BOOL)animated type:(SENavigationControllerAnimationType)type {
    
    [viewController setHidesBottomBarWhenPushed:[self.se_hidesBottomBarWhenPushed boolValue]];
    
    switch (type) {
        case SENavigationControllerAnimationTypeSystem: {
            [self pushViewControllerWithSystemType:viewController animated:animated];
            break;
        }
        case SENavigationControllerAnimationTypeDefault: {
            [self pushViewControllerWithDefaultType:viewController animated:animated];
            break;
        }
        case SENavigationControllerAnimationTypeFade: {
            [self pushViewControllerWithFadeType:viewController animated:animated];
            break;
        }
        case SENavigationControllerAnimationTypeSwing: {
            [self pushViewControllerWithSwingType:viewController animated:animated];
            break;
        }
        case SENavigationControllerAnimationTypeCustom: {
            NSAssert(self.se_customTransition, kSECustomTransitionErrorMessage);
            [self pushViewControllerWithCustomType:viewController animated:animated transition:self.se_customTransition];
            break;
        }
        default: {
            break;
        }
    }
}

- (UIViewController *)se_popViewControllerAnimated:(BOOL)animated type:(SENavigationControllerAnimationType)type {
    
    switch (type) {
        case SENavigationControllerAnimationTypeSystem: {
            [self popViewControllerWithSystemTypeAnimated:animated];
            break;
        }
        case SENavigationControllerAnimationTypeDefault: {
            if (self.screenShots.count < 1) {
                [self popViewControllerWithSystemTypeAnimated:animated];
            }
            [self popViewControllerWithDefaultTypeAnimated:animated];
            break;
        }
        case SENavigationControllerAnimationTypeFade: {
            [self popViewControllerWithFadeTypeAnimated:animated];
            break;
        }
        case SENavigationControllerAnimationTypeSwing: {
            [self popViewControllerWithSwingTypeAnimated:animated];
            break;
        }
        case SENavigationControllerAnimationTypeCustom: {
            NSAssert(self.se_customTransition, kSECustomTransitionErrorMessage);
            [self popViewControllerWithCustomTypeAnimated:animated];
        }
        default: {
            break;
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.delegate = nil;
    });
    
    return nil;
    
}

#pragma mark - private methods
- (void)createScreenShotWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self.screenShots addObject:image];
}

- (void)removeScreenShot {
    // remove from screents
    [self.screenShots removeLastObject];
    
    self.view.x = 0;
    [self.cover removeFromSuperview];
    [self.lastVcView removeFromSuperview];
}

- (void)initBeforePush {
    self.tabBarController.view.backgroundColor = [UIColor clearColor];
    self.delegate = nil;
    self.navDelegate.animationDuration = kSENavigationControllerAnimationDuration;
    self.navDelegate.transition = self.defaultTransition;
}

- (void)initBeforePop {
    self.delegate = nil;
    self.navDelegate.transition = self.defaultTransition;
}

- (void)clearPanGestureBeforePush:(UIViewController *)viewController {
    UIPanGestureRecognizer *pan = [viewController.view.gestureRecognizers lastObject];
    if ([NSStringFromClass([pan class]) isEqualToString:NSStringFromClass([SEPanGestureRecognizer class])]) {
        NSMutableArray *array = viewController.view.gestureRecognizers.mutableCopy;
        [array removeObject:pan];
        viewController.view.gestureRecognizers = array.copy;
    }
}

- (void)pushViewControllerWithSystemType:(UIViewController *)viewController animated:(BOOL)animated {
    [self initBeforePush];
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    
    [self clearPanGestureBeforePush:viewController];
    
    if (self.viewControllers.count >= 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    [self pushViewController:viewController animated:animated];
}

- (void)pushViewControllerWithDefaultType:(UIViewController *)viewController animated:(BOOL)animated {
    [self initBeforePush];
    
    [self clearPanGestureBeforePush:viewController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat duration = animated ? [self.se_animationDuration doubleValue] : 0;
        
        [self createScreenShotWithView:[UIApplication sharedApplication].keyWindow];
        [self pushViewController:viewController animated:NO];
        
        if (!animated) {
            return;
        }
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        // insert to back
        self.lastVcView.x = 0;
        self.lastVcView.image = self.screenShots[self.screenShots.count - 1];
        [window insertSubview:self.lastVcView atIndex:0];
        [window insertSubview:self.cover aboveSubview:self.lastVcView];
        
        self.view.x = self.view.width;
        self.cover.alpha = 0;
        [UIView animateWithDuration:duration animations:^{
            self.view.x = 0;
            self.cover.alpha = 0.7;
            self.lastVcView.x = -(self.view.width / 4);
        } completion:^(BOOL finished) {
            [self.lastVcView removeFromSuperview];
            [self.cover removeFromSuperview];
            //        self.panGesture.enabled = YES;
            
            SEPanGestureRecognizer *pan = [[SEPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
            [viewController.view addGestureRecognizer:pan];
        }];
    });
}

- (void)pushViewControllerWithFadeType:(UIViewController *)viewController animated:(BOOL)animated {
    [self initBeforePush];
    [self clearPanGestureBeforePush:viewController];
    self.navDelegate.animationType = SENavigationTransitionAnimationTypeFade;
    self.navDelegate.animationDuration = [self.se_animationDuration doubleValue];
    self.delegate = self.navDelegate;
    
    if (self.viewControllers.count >= 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    [self pushViewController:viewController animated:animated];
}

- (void)pushViewControllerWithSwingType:(UIViewController *)viewController animated:(BOOL)animated {
    [self initBeforePush];
    [self clearPanGestureBeforePush:viewController];
    self.navDelegate.animationType = SENavigationTransitionAnimationTypeSwing;
    self.navDelegate.animationDuration = [self.se_animationDuration doubleValue];
    self.delegate = self.navDelegate;
    [self pushViewController:viewController animated:animated];
}

- (void)pushViewControllerWithCustomType:(UIViewController *)viewController animated:(BOOL)animated transition:(id<UIViewControllerAnimatedTransitioning>)transition {
    [self initBeforePush];
    [self clearPanGestureBeforePush:viewController];
    self.navDelegate.animationType = SENavigationControllerAnimationTypeCustom;
    self.navDelegate.animationDuration = [self.se_animationDuration doubleValue];
    self.navDelegate.transition = transition;
    self.delegate = self.navDelegate;
    [self pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerWithSystemTypeAnimated:(BOOL)animated {
    self.delegate = nil;
    return [self popViewControllerAnimated:animated];
}

- (void)popViewControllerWithDefaultTypeAnimated:(BOOL)animated {
    [self initBeforePop];
    
    CGFloat duration = animated ? [self.se_animationDuration doubleValue] : 0;
    
    if (!animated) {
        [self popViewControllerAnimated:NO];
        return;
    }
    
    __block UIViewController *popVc = nil;
    
    //    if (self.viewControllers.count <= 2) {
    //        self.panGesture.enabled = NO;
    //    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // insert to back
    self.lastVcView.x = 0;
    self.lastVcView.image = self.screenShots[self.screenShots.count - 1];
    [window insertSubview:self.lastVcView atIndex:0];
    [window insertSubview:self.cover aboveSubview:self.lastVcView];
    
    self.lastVcView.x = -(self.view.width / 4);
    [UIView animateWithDuration:duration animations:^{
        self.view.x = self.view.width;
        self.lastVcView.x = 0;
        self.cover.alpha = 0;
    } completion:^(BOOL finished) {
        
        //        self.tabBarController.view.x = 0;
        popVc = [self popViewControllerAnimated:NO];
        [self removeScreenShot];
        
    }];
}

- (UIViewController *)popViewControllerWithFadeTypeAnimated:(BOOL)animated {
    [self initBeforePop];
    self.navDelegate.animationType = SENavigationTransitionAnimationTypeFade;
    self.navDelegate.animationDuration = [self.se_animationDuration doubleValue];
    self.delegate = self.navDelegate;
    return [self popViewControllerAnimated:animated];
}

- (UIViewController *)popViewControllerWithSwingTypeAnimated:(BOOL)animated {
    [self initBeforePop];
    self.navDelegate.animationType = SENavigationTransitionAnimationTypeSwing;
    self.navDelegate.animationDuration = [self.se_animationDuration doubleValue];
    self.delegate = self.navDelegate;
    return [self popViewControllerAnimated:animated];
}

- (UIViewController *)popViewControllerWithCustomTypeAnimated:(BOOL)animated {
    [self initBeforePop];
    self.navDelegate.animationType = SENavigationControllerAnimationTypeCustom;
    self.navDelegate.transition = self.se_customTransition;
    self.delegate = self.navDelegate;
    return [self popViewControllerAnimated:animated];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    //     only 1 sub controller do nothing
    if (self.viewControllers.count <= 1 || !self.screenShots.count) return;
    
    UIView *view = self.se_hidesBottomBarWhenPushed ? self.view : self.tabBarController.view;
    
    // translation in x
    CGFloat tx = [pan translationInView:self.view].x;
    if (tx < 0) return;
    
    // progress
    CGFloat progress = view.x / self.view.width;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        view.x = 0;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        // insert to back
        self.lastVcView.x = -(self.view.width / 4);
        self.lastVcView.image = self.screenShots[self.screenShots.count - 1];
        [window insertSubview:self.lastVcView atIndex:0];
        [window insertSubview:self.cover aboveSubview:self.lastVcView];
        self.cover.alpha = 0.7;
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        // decide to pop or push
        //        CGFloat x = self.view.frame.origin.x;
        if (progress >= 0.5) { // pop
            [UIView animateWithDuration:[self.se_animationDuration doubleValue] animations:^{
                view.transform = CGAffineTransformMakeTranslation(self.view.width, 0);
                self.lastVcView.transform = CGAffineTransformMakeTranslation((self.view.width / 4), 0);
                self.cover.alpha = 0;
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                
                view.x =  self.view.width;
                
                [self.screenShots removeLastObject];
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    view.transform = CGAffineTransformIdentity;
                    view.x = 0;
                    self.lastVcView.transform = CGAffineTransformIdentity;
                    [self.cover removeFromSuperview];
                    [self.lastVcView removeFromSuperview];
                });
            }];
        } else { // push
            [UIView animateWithDuration:[self.se_animationDuration doubleValue] animations:^{
                view.transform = CGAffineTransformIdentity;
                self.lastVcView.transform = CGAffineTransformIdentity;
                self.cover.alpha = 0.7;
            } completion:^(BOOL finished) {
                self.lastVcView.x = -(self.view.width / 4);
                self.cover.alpha = 0.7;
            }];
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        // move view
        view.transform = CGAffineTransformMakeTranslation(tx, 0);
        self.lastVcView.transform = CGAffineTransformMakeTranslation(tx / 4, 0);
        // cover
        self.cover.alpha = 0.7 * (1 - progress);
    }
}

#pragma mark - properties
- (NSMutableArray *)screenShots {
//    return objc_getAssociatedObject(self, screenShotsKey);
    
    NSMutableArray *array = objc_getAssociatedObject(self, screenShotsKey);
    if (!array) {
        array = [NSMutableArray array];
        [self setScreenShots:array];
    }
    return array;
}

- (void)setScreenShots:(NSMutableArray *)screenShots {
    objc_setAssociatedObject(self, screenShotsKey, screenShots,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)lastVcView {
    UIImageView *last = objc_getAssociatedObject(self, lastVcViewKey);
    if (!last) {
        last = [[UIImageView alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        last.frame = window.bounds;
        [self setLastVcView:last];
    }
    return last;
}

- (void)setLastVcView:(UIImageView *)lastVcView {
    objc_setAssociatedObject(self, lastVcViewKey, lastVcView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)cover {
    UIView *co = objc_getAssociatedObject(self, coverKey);
    if (!co) {
        co = [[UIView alloc] init];
        co.backgroundColor = [UIColor blackColor];
        co.frame = self.view.bounds;
        co.alpha = 0.7;
        [self setCover:co];
    }
    return co;
}

- (void)setCover:(UIView *)cover {
    objc_setAssociatedObject(self, coverKey, cover,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SENavigationDelegate *)navDelegate {
    SENavigationDelegate *nav = objc_getAssociatedObject(self, navDelegateKey);
    if (!nav) {
        nav = [SENavigationDelegate new];
        [self setNavDelegate:nav];
    }
    return nav;
    
}

- (void)setNavDelegate:(SENavigationDelegate *)navDelegate {
    objc_setAssociatedObject(self, navDelegateKey, navDelegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)se_hidesBottomBarWhenPushed {
    return objc_getAssociatedObject(self, se_hidesBottomBarWhenPushedKey);
}

- (void)setSe_hidesBottomBarWhenPushed:(NSNumber *)se_hidesBottomBarWhenPushed {
    objc_setAssociatedObject(self, se_hidesBottomBarWhenPushedKey, se_hidesBottomBarWhenPushed,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)se_animationDuration {
    return objc_getAssociatedObject(self, se_animationDurationKey);
}

- (void)setSe_animationDuration:(NSNumber *)se_animationDuration {
    objc_setAssociatedObject(self, se_animationDurationKey, se_animationDuration,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SENavigationTransition *)se_customTransition {
    return objc_getAssociatedObject(self, se_customTransitionKey);
}

- (void)setSe_customTransition:(SENavigationTransition *)se_customTransition {
    objc_setAssociatedObject(self, se_customTransitionKey, se_customTransition,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SENavigationTransition *)defaultTransition {
    return objc_getAssociatedObject(self, defaultTransitionKey);
}

- (void)setDefaultTransition:(SENavigationTransition *)defaultTransition {
    objc_setAssociatedObject(self, defaultTransitionKey, defaultTransition,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
