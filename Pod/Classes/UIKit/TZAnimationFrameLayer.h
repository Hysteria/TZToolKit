//
//  FrameLineLayer.h
//  MulticolorLayerDemo
//
//  Created by Hangqing Zhou on 14/11/17.
//  Copyright (c) 2015年 ThoughtEvil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, FrameType) {
    FrameTypeEncircling,
    FrameTypeTwinkle,
    FrameTypeFadeSegment,
};

@interface TZAnimationFrameLayer : CALayer

@property (nonatomic, assign) FrameType frameType;
@property (nonatomic, assign) CGPathRef path;
@property (nonatomic, assign) CGRect animationRect;
@property (nonatomic, assign) CGColorRef frameColor;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameCornerRadius;

+ (TZAnimationFrameLayer *)layerWithFrameWidth:(CGFloat)frameWidth frameColor:(CGColorRef)frameColor frameCornerRadius:(CGFloat)radius;
- (instancetype)initWithFrameWidth:(CGFloat)frameWidth frameColor:(CGColorRef)frameColor frameCornerRadius:(CGFloat)radius;

- (void)startAnimation;
- (void)endAnimation;

@end
