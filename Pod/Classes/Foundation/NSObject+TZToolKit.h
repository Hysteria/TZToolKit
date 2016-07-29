//
//  NSObject+TZToolKit.h
//  UIViewTransformDemo
//
//  Created by Hangqing Zhou on 15/1/5.
//  Copyright (c) 2015年 ThoughtEvil. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef IMP *IMPPointer;

@interface NSObject (Runtime)

+ (void)swizzle:(SEL)original with:(SEL)replacement;
+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer)store;
+ (void)swizzleStatic:(SEL)original with:(SEL)replacement;
+ (BOOL)swizzleStatic:(SEL)original with:(IMP)replacement store:(IMPPointer)store;
@end
