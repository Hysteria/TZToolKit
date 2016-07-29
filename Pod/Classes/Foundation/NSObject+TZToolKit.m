//
//  NSObject+TZToolKit.m
//  UIViewTransformDemo
//
//  Created by Hangqing Zhou on 15/1/5.
//  Copyright (c) 2015年 ThoughtEvil. All rights reserved.
//

#import "NSObject+TZToolKit.h"
#import <objc/runtime.h>

// These swizzle method code referenced from
// http://stackoverflow.com/questions/5339276/what-are-the-dangers-of-method-swizzling-in-objective-c
// and NSHipster http://nshipster.com/method-swizzling/

@implementation NSObject (Runtime)

+ (void)swizzle:(SEL)original with:(SEL)replacement
{
    Class class = [self class];

    Method originalMethod = class_getInstanceMethod(class, original);
    Method replacementMethod = class_getInstanceMethod(class, replacement);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    original,
                    method_getImplementation(replacementMethod),
                    method_getTypeEncoding(replacementMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            replacement,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
    
}

+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer)store {
    IMP imp = NULL;
    Class class = [self class];
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) {
        *store = imp;
    }
    return (imp != NULL);
}

+ (void)swizzleStatic:(SEL)original with:(SEL)replacement
{
    // swizzling a class method, use the following:
    Class class = object_getClass((id)self);
    
    Method originalMethod = class_getInstanceMethod(class, original);
    Method replacementMethod = class_getInstanceMethod(class, replacement);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    original,
                    method_getImplementation(replacementMethod),
                    method_getTypeEncoding(replacementMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            replacement,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}

+ (BOOL)swizzleStatic:(SEL)original with:(IMP)replacement store:(IMPPointer)store
{
    IMP imp = NULL;
    Class class = object_getClass((id)self);
    Method method = class_getClassMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) {
        *store = imp;
    }
    return (imp != NULL);
}

@end
