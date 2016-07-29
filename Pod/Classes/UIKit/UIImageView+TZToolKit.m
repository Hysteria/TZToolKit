//
//  UIImageView+TZToolKit.m
//  TZToolKit
//
//  Created by Hangqing Zhou on 2/15/15.
//  Copyright (c) 2015 ThoughtEvil. All rights reserved.
//

#import "UIImageView+TZToolKit.h"

@implementation UIImageView (Animation)

- (instancetype)initWithFrameAnimationPrefix:(NSString *)prefix frameCount:(NSInteger)count
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d", prefix, 0]];
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (self) {
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d", prefix, i]];
            [images addObject:image];
        }
        self.animationImages = images;
    }
    return self;
}

@end
