//
//  UIView+TZToolKit.m
//  UIViewTransformDemo
//
//  Created by Hangqing Zhou on 15/1/5.
//  Copyright (c) 2015年 ThoughtEvil. All rights reserved.
//

#import "UIView+TZToolKit.h"
#import "NSObject+TZToolKit.h"
#import <objc/runtime.h>
#import "TZHelper.h"

#pragma mark - Transform

@implementation UIView (Transform)
@dynamic rotation;
@dynamic scale;
@dynamic flipX;
@dynamic flipY;


- (NSString *)tz_description
{
    NSString *desc = [super description];
    return [NSString stringWithFormat:@"%@ frame: %@ rotation: %.4f scale: %.4f isFlipX: %d isFlipY: %d", desc, NSStringFromCGRect(self.frame), self.rotation, self.scale, self.isFlipX, self.isFlipY];
}

- (void)setRotation:(CGFloat)rotation
{
    objc_setAssociatedObject(self, @selector(rotation), @(rotation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGFloat radians = rotation * M_PI / 180.f;
    self.transform = CGAffineTransformRotate(self.transform, radians);
}

- (CGFloat)rotation
{
    return [objc_getAssociatedObject(self, @selector(rotation)) floatValue];
}

- (void)setScale:(CGFloat)scale
{
    objc_setAssociatedObject(self, @selector(scale), @(scale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
}

- (CGFloat)scale
{
    return [objc_getAssociatedObject(self, @selector(scale)) floatValue];
}

- (void)setFlipX:(BOOL)flipX
{
    objc_setAssociatedObject(self, @selector(isFlipX), @(flipX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transform = CGAffineTransformScale(self.transform, -1.f, 1.f);
}

- (BOOL)isFlipX
{
    return [objc_getAssociatedObject(self, @selector(isFlipX)) boolValue];
}

- (void)setFlipY:(BOOL)flipY
{
    objc_setAssociatedObject(self, @selector(isFlipY), @(flipY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transform = CGAffineTransformScale(self.transform, 1.f, -1.f);
}

- (BOOL)isFlipY
{
    return [objc_getAssociatedObject(self, @selector(isFlipY)) boolValue];
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        return;
    }
    // Stay in sync with the superview
    if (self.superview) {
        self.bounds = self.superview.bounds;
        [self setNeedsDisplay];
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat radians = 0;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            radians = -(CGFloat)M_PI_2;
        } else {
            radians = (CGFloat)M_PI_2;
        }
        // Window coordinates differ!
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            radians = (CGFloat)M_PI;
        }
        else {
            radians = 0;
        }
    }
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
    }
    [self setTransform:rotationTransform];
    if (animated) {
        [UIView commitAnimations];
    }
}

- (CGRect)superviewBoundsForCurrentOrientation
{
    UIView *superview = [self superview];
    CGRect bounds = superview.bounds;
    if (tz_OSVersionIsAtLeastiOS8()) {
        return bounds;
    }
    
    if ([superview isKindOfClass:[UIWindow class]]) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            bounds = CGRectMake(0, 0, bounds.size.height, bounds.size.width);
        }
    }
    return bounds;
}

@end

#pragma mark - Animation

#define TZPresetationAnimationDurationPart1             0.3f
#define TZPresetationAnimationDurationPart2             0.15f

typedef void(^VoidBlock) ();

@implementation UIView (Animation)

@dynamic presentationStyle;

- (void)tz_removeFromSuperview
{
    if (self.presentationStyle == TZPresentationNone) {
        [self tz_removeFromSuperview];
        return;
    }
    
    [self startDismissalAniamtionWithCompletion:^{
        [self tz_removeFromSuperview];
    }];
}

- (void)setPresentationStyle:(TZPresentationStyle)presentationStyle
{
    objc_setAssociatedObject(self, @selector(presentationStyle), @(presentationStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TZPresentationStyle)presentationStyle
{
    return [objc_getAssociatedObject(self, @selector(presentationStyle)) unsignedIntegerValue];
}

- (void)startPresentationAniamtion
{
    VoidBlock sourceBlock;
    VoidBlock targetBlock1;
    VoidBlock targetBlock2;
    
    CGRect superviewBounds = [self superviewBoundsForCurrentOrientation];
    CGPoint center = self.center;

    CGAffineTransform originalTransform = self.transform;
    switch (self.presentationStyle) {
        case TZPresentationPopOver: {
            sourceBlock = ^() {
                self.transform = CGAffineTransformScale(originalTransform, 0.1f, 0.1f);
            };
            targetBlock1 = ^() {
                self.transform = CGAffineTransformScale(originalTransform, 1.3f, 1.3f);
            };
            targetBlock2 = ^() {
                self.transform = CGAffineTransformScale(originalTransform, 1.0f, 1.0f);
            };
        }
            break;
        case TZPresentationFade: {
            sourceBlock = ^() {
                self.alpha = 0.f;
            };
            targetBlock1 = ^() {
                self.alpha = 1.f;
            };

        }
            break;
        case TZPresentationDrop: {
            sourceBlock = ^() {
                self.transform = CGAffineTransformScale(originalTransform, 2.f, 2.f);
            };
            targetBlock1 = ^() {
                self.transform = CGAffineTransformScale(originalTransform, 1.f, 1.f);
            };
        }
            break;
        case TZPresentationBounceUp:
        case TZPresentationBounceDown: {
            TZDirection direction = self.presentationStyle == TZPresentationBounceUp ? TZDirectionBottom : TZDirectionTop;
   
            CGPoint outerCenter = [self outOfBoundsCenterForView:self direction:direction boundaryFrame:superviewBounds];
            CGPoint bounceCenter = [self bounceCenterForView:self direction:direction];
            sourceBlock = ^() {
                self.center = outerCenter;
            };
            targetBlock1 = ^() {
                self.center = bounceCenter;
            };
            targetBlock2 = ^() {
                self.center = center;
            };
        }
            break;
        case TZPresentationSlideUp:
        case TZPresentationSlideDown: {
            TZDirection direction = self.presentationStyle == TZPresentationSlideUp ? TZDirectionBottom : TZDirectionTop;
            sourceBlock = ^() {
                self.center = [self outOfBoundsCenterForView:self direction:direction boundaryFrame:superviewBounds];
            };
            targetBlock1 = ^() {
                self.center = center;
            };
        }
            break;
            
        default:
            break;
    }
    
    if (sourceBlock) {
        sourceBlock();
    }
    [UIView animateWithDuration:TZPresetationAnimationDurationPart1 animations:^{
        if (targetBlock1) {
            targetBlock1();
        }
    } completion:^(BOOL finished) {
        if (finished) {
            
            [UIView animateWithDuration:TZPresetationAnimationDurationPart2 animations:^{
                if (targetBlock2) {
                    targetBlock2();
                }
            }];
        }
    }];
    
}

- (void)startDismissalAniamtionWithCompletion:(void (^)(void))completion
{
    VoidBlock sourceBlock;
    VoidBlock targetBlock1;
    VoidBlock targetBlock2;
    
    CGRect superviewBounds = [self superviewBoundsForCurrentOrientation];

    CGAffineTransform originalTransform = self.transform;
    switch (self.presentationStyle) {
        case TZPresentationPopOver: {
            sourceBlock = ^() {
                self.transform = CGAffineTransformScale(originalTransform, 1.0f, 1.0f);
            };
            targetBlock1 = ^() {
                self.transform = CGAffineTransformScale(originalTransform, 1.5f, 1.5f);
            };
            targetBlock2 = ^() {
                self.transform = CGAffineTransformScale(originalTransform, .1f, .1f);
            };
        }
            break;
        case TZPresentationFade: {
            sourceBlock = ^() {
                self.alpha = 1.f;
            };
            targetBlock2 = ^() {
                self.alpha = 0.f;
            };
            
        }
            break;
        case TZPresentationDrop: {
            sourceBlock = ^() {
                self.transform = CGAffineTransformScale(self.transform, 1.f, 1.f);
            };
            targetBlock2 = ^() {
                self.transform = CGAffineTransformScale(self.transform, 0.f, 0.f);
            };
        }
            break;
        case TZPresentationBounceUp:
        case TZPresentationBounceDown: {
            TZDirection direction = self.presentationStyle == TZPresentationBounceUp ? TZDirectionBottom : TZDirectionTop;
            
            CGPoint bounceCenter = [self bounceCenterForView:self direction:direction];
            CGPoint outerCenter = [self outOfBoundsCenterForView:self direction:direction boundaryFrame:superviewBounds];
            targetBlock1 = ^() {
                self.center = bounceCenter;
            };
            targetBlock2 = ^() {
                self.center = outerCenter;
            };
        }
            break;
        case TZPresentationSlideUp:
        case TZPresentationSlideDown: {
            TZDirection direction = self.presentationStyle == TZPresentationSlideUp ? TZDirectionBottom : TZDirectionTop;
            targetBlock2 = ^() {
                self.center = [self outOfBoundsCenterForView:self direction:direction boundaryFrame:superviewBounds];
            };
        }
            break;
            
        default:
            break;
    }
    
    if (sourceBlock) {
        sourceBlock();
    }
    [UIView animateWithDuration:TZPresetationAnimationDurationPart2 animations:^{
        if (targetBlock1) {
            targetBlock1();
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:TZPresetationAnimationDurationPart1 animations:^{
                if (targetBlock2) {
                    targetBlock2();
                }
            } completion:^(BOOL finished) {
                if (finished && completion) {
                    completion();
                }
            }];
        }
    }];
}

- (void)didMoveToWindow
{
    if (self.presentationStyle == TZPresentationNone) {
        return;
    }
    
    if (self.window) {
        [self startPresentationAniamtion];
    }
}

- (CGPoint)bounceCenterForView:(UIView*)view direction:(TZDirection)direction
{
    float bounceOffset = 15.0f;
    
    if (direction == TZDirectionLeft) {
        return CGPointMake( view.center.x + bounceOffset, view.center.y );
    }
    else if (direction == TZDirectionRight) {
        return CGPointMake( view.center.x - bounceOffset, view.center.y );
    }
    else if (direction == TZDirectionTop) {
        return CGPointMake( view.center.x, view.center.y + bounceOffset );
    }
    else if (direction == TZDirectionBottom) {
        return CGPointMake( view.center.x, view.center.y - bounceOffset );
    }
    else if (direction == TZDirectionTopLeft) {
        return CGPointMake( view.center.x + bounceOffset, view.center.y + bounceOffset );
    }
    else if (direction == TZDirectionTopRight) {
        return CGPointMake( view.center.x - bounceOffset, view.center.y + bounceOffset );
    }
    else if (direction == TZDirectionBottomLeft) {
        return CGPointMake( view.center.x + bounceOffset, view.center.y - bounceOffset );
    }
    else if(direction == TZDirectionBottomRight) {
        return CGPointMake( view.center.x - bounceOffset, view.center.y - bounceOffset );
    }
    
    return CGPointZero;
}


- (CGPoint)outOfBoundsCenterForView:(UIView*)view direction:(TZDirection)direction boundaryFrame:(CGRect)boundaryFrame
{
    if (direction == TZDirectionLeft) {
        return CGPointMake( boundaryFrame.origin.x - ( view.bounds.size.width / 2.0f ), view.center.y );
    } else if (direction == TZDirectionRight) {
        return CGPointMake( boundaryFrame.origin.x + boundaryFrame.size.width + ( view.bounds.size.width / 2.0f ), view.center.y );
    }
    else if (direction == TZDirectionTop) {
        return CGPointMake( view.center.x, boundaryFrame.origin.y - ( view.bounds.size.height / 2.0f ));
    } else if (direction == TZDirectionBottom) {
        return CGPointMake( view.center.x, boundaryFrame.origin.y + boundaryFrame.size.height + ( view.bounds.size.height / 2.0f ));
    } else if (direction == TZDirectionTopLeft) {
        return CGPointMake( boundaryFrame.origin.x - ( view.bounds.size.width / 2.0f ), boundaryFrame.origin.y - ( view.bounds.size.height / 2.0f ));
    } else if (direction == TZDirectionTopRight) {
        return CGPointMake( boundaryFrame.origin.x + boundaryFrame.size.width + ( view.bounds.size.width / 2.0f ), boundaryFrame.origin.y - ( view.bounds.size.height / 2.0f ));
    } else if (direction == TZDirectionBottomLeft) {
        return CGPointMake( boundaryFrame.origin.x - ( view.bounds.size.width / 2.0f ), boundaryFrame.origin.y + boundaryFrame.size.height + ( view.bounds.size.height / 2.0f ));
    } else if (direction == TZDirectionBottomRight) {
        return CGPointMake( boundaryFrame.origin.x + boundaryFrame.size.width + ( view.bounds.size.width / 2.0f ), boundaryFrame.origin.y + boundaryFrame.size.height + ( view.bounds.size.height / 2.0f ));
    }
    
    return CGPointZero;
}


@end

@interface UIView (SwizzleMethod)

@end

@implementation UIView (SwizzleMethod)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzle:@selector(removeFromSuperview) with:@selector(tz_removeFromSuperview)];
        [self swizzle:@selector(description) with:@selector(tz_description)];
    });
}

@end

