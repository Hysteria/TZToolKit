//
//  FrameLineLayer.m
//  MulticolorLayerDemo
//
//  Created by Hangqing Zhou on 14/11/17.
//  Copyright (c) 2015年 ThoughtEvil. All rights reserved.
//

#import "TZAnimationFrameLayer.h"

#define kEncirclingDuration                     1.f
#define kSegments                               2.f
#define kDurationPerSegment                     kEncirclingDuration/kSegments
#define kTwinkleDuration                        0.7f

@interface AnimConfig : NSObject

@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat elapsed;
@property (nonatomic, assign) BOOL isStarted;
@property (nonatomic, strong) NSTimer *timer;

+ (AnimConfig *)config;

@end

@implementation AnimConfig

+ (AnimConfig *)config
{
    return [[self alloc] init];
}

@end

@interface TZAnimationFrameLayer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat elapsed;
@property (nonatomic, strong) NSArray *configs;
@property (nonatomic, assign) NSInteger configIndex;

@end

@implementation TZAnimationFrameLayer

- (void)dealloc
{
    for (AnimConfig *config in self.configs) {
        [config.timer invalidate];
        config.timer = nil;
        [config.layer removeFromSuperlayer];
        config.layer = nil;
    }
}

+ (TZAnimationFrameLayer *)layerWithFrameWidth:(CGFloat)frameWidth frameColor:(CGColorRef)frameColor frameCornerRadius:(CGFloat)radius
{
    return [[self alloc] initWithFrameWidth:frameWidth frameColor:frameColor frameCornerRadius:radius];
}

- (instancetype)initWithFrameWidth:(CGFloat)frameWidth frameColor:(CGColorRef)frameColor frameCornerRadius:(CGFloat)radius
{
    self = [super init];
    if (self) {
        [self setUp];
        
        self.frameWidth = frameWidth;
        self.frameColor = frameColor;
        self.frameCornerRadius = radius;
        
    }
    return self;
}

#pragma mark - Private

- (void)setUp
{
    _frameType = FrameTypeEncircling;
    
    NSMutableArray *configs = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        CALayer *animLayer = [CALayer layer];
        animLayer.frame = self.bounds;
        animLayer.backgroundColor = self.borderColor;
        animLayer.mask = [self shapeLayer];
        
        AnimConfig *config = [AnimConfig config];
        config.layer = animLayer;
        config.elapsed = 0.f;
        
        [configs addObject:config];
    }
    _configs = [configs copy];
}

- (CAShapeLayer *)shapeLayer
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = _frameWidth;
    shapeLayer.lineCap = @"round";
    shapeLayer.lineJoin = @"round";
    [CATransaction setDisableActions:YES];
    shapeLayer.strokeStart = 0.0f;
    shapeLayer.strokeEnd = 0.0f;
    [CATransaction setDisableActions:NO];
    
    return shapeLayer;
}

- (AnimConfig *)lastAnimConfig
{
    NSInteger lastIndex = [self lastAnimConfigIndexForIndex:self.configIndex];
    return self.configs[lastIndex];
}

- (AnimConfig *)curAnimConfig
{
    //    return self.animConfigs[_curAnimName];
    return self.configs[self.configIndex];
}

- (AnimConfig *)nextAnimConfig
{
    NSInteger nextIndex = [self lastAnimConfigIndexForIndex:self.configIndex];
    return self.configs[nextIndex];
}

- (NSInteger)lastAnimConfigIndexForIndex:(NSInteger)index
{
    index--;
    if (index < 0) {
        index = self.configs.count - 1;
    }
    return index;
}

- (NSInteger)nextAnimConfigIndexForIndex:(NSInteger)index
{
    index++;
    if (index > self.configs.count - 1) {
        index = 0;
    }
    return index;
}


#pragma mark - Accessories

- (void)setFrameColor:(CGColorRef)frameColor
{
    _frameColor = frameColor;
    
    for (AnimConfig *config in _configs) {
        config.layer.backgroundColor = _frameColor;
    }
}

- (void)setFrameWidth:(CGFloat)frameWidth
{
    _frameWidth = frameWidth;
    
    for (AnimConfig *config in _configs) {
        CAShapeLayer *maskLayer = (CAShapeLayer *)config.layer.mask;
        maskLayer.lineWidth = _frameWidth;
    }
}

- (void)setPath:(CGPathRef)path
{
    _path = path;

    for (AnimConfig *config in _configs) {
        CAShapeLayer *maskLayer = (CAShapeLayer *)config.layer.mask;
        maskLayer.path = _path;
    }
}

- (void)setAnimationRect:(CGRect)animationRect
{
    _animationRect = animationRect;
    
    CGRect bounds = _animationRect;
    bounds.origin = CGPointZero;
    CGRect pathBounds = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(_frameWidth * 0.5, _frameWidth * 0.5, _frameWidth * 0.5, _frameWidth * 0.5));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathBounds cornerRadius:_frameCornerRadius];
    
    for (AnimConfig *config in _configs) {
        CALayer *layer = config.layer;
        layer.bounds = bounds;
        layer.anchorPoint = CGPointMake(0.5, 0.5);
        layer.position = CGPointMake(CGRectGetMidX(_animationRect), CGRectGetMidY(_animationRect));
        
        CAShapeLayer *mask = (CAShapeLayer *)layer.mask;
        mask.frame = layer.bounds;
        mask.path = path.CGPath;
    }
}


#pragma mark - Animation

- (void)update:(NSTimer *)timer
{
    NSInteger index = [timer.userInfo integerValue];
    AnimConfig *config = self.configs[index];
    CGFloat elapsed = config.elapsed;
    elapsed += timer.timeInterval;
    
    NSLog(@"anim %@ elapsed %.2f", @(index), elapsed);
    
    if (elapsed >= kEncirclingDuration && elapsed < kEncirclingDuration + kDurationPerSegment) {
        if (!config.isStarted) {
            config.isStarted = YES;
            [self startAnimation];
        }
        
    } else if (elapsed >= kEncirclingDuration + kDurationPerSegment) {
        elapsed = 0.f;
        [timer invalidate];
        
        AnimConfig *lastConfig = [self lastAnimConfig];
        [lastConfig.layer removeFromSuperlayer];
        lastConfig.isStarted = NO;
    }

    CALayer *animLayer = config.layer;
    if (animLayer.superlayer) {
        CAShapeLayer *shapeLayer = (CAShapeLayer *)animLayer.mask;
        [CATransaction setDisableActions:YES];
        shapeLayer.strokeStart = (elapsed - kDurationPerSegment) / kEncirclingDuration * 1.f;
        shapeLayer.strokeEnd = elapsed / kEncirclingDuration * 1.f ;
        [CATransaction setDisableActions:NO];
    }
    
    config.elapsed = elapsed;
}

- (void)startAnimation
{
    if (_frameType == FrameTypeEncircling) {
        self.configIndex = [self nextAnimConfigIndexForIndex:self.configIndex];
        
        AnimConfig *config = self.configs[self.configIndex];
        CALayer *curAnimLayer = config.layer;
        [self addSublayer:curAnimLayer];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kDurationPerSegment * 0.125 target:self selector:@selector(update:) userInfo:@(self.configIndex) repeats:YES];
        if (timer) {
            config.timer = timer;
        }
    } else if (_frameType == FrameTypeTwinkle) {
        AnimConfig *config = self.configs[self.configIndex];
        CALayer *layer = config.layer;
        if (!layer) {
            return;
        }
        [self addSublayer:layer];
        
        CAShapeLayer *shapeLayer = (CAShapeLayer *)layer.mask;
        if (!shapeLayer) {
            return ;
        }

        shapeLayer.strokeStart = 0.f;
        shapeLayer.strokeEnd = 1.f;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = kTwinkleDuration;
        animation.repeatCount = MAXFLOAT;
        animation.fromValue = @(0.95f);
        animation.toValue = @(1.05f);
        animation.autoreverses = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [layer addAnimation:animation forKey:nil];
    }
}

- (void)endAnimation
{
    for (AnimConfig *config in self.configs) {
        [config.timer invalidate];
        [config.layer removeFromSuperlayer];
    }
}

@end
