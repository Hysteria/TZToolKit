//
//  UIView+TZToolKit.h
//  UIViewTransformDemo
//
//  Created by Hangqing Zhou on 15/1/5.
//  Copyright (c) 2015年 ThoughtEvil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TZPresentationStyle) {
    TZPresentationNone = 0,
    TZPresentationPopOver = 1 << 1,
    TZPresentationFade = 1 << 2,
    TZPresentationDrop = 1 << 3,
    TZPresentationBounceUp = 1 << 4,
    TZPresentationBounceDown = 1 << 5,
    TZPresentationSlideUp = 1 << 6,
    TZPresentationSlideDown = 1 << 7,
};

typedef NS_ENUM(NSInteger, TZDirection) {
    TZDirectionCenter,
    TZDirectionTop,
    TZDirectionBottom,
    TZDirectionLeft,
    TZDirectionRight,
    TZDirectionTopLeft,
    TZDirectionTopRight,
    TZDirectionBottomLeft,
    TZDirectionBottomRight,
};

@interface UIView (Transform)

@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign, getter=isFlipX) BOOL flipX;
@property (nonatomic, assign, getter=isFlipY) BOOL flipY;

- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (CGRect)superviewBoundsForCurrentOrientation;

@end

@interface UIView (Animation)

@property (nonatomic, assign) TZPresentationStyle presentationStyle;

@end
