//
//  NSDateFormatter+TZToolKit.h
//  TZToolKit
//
//  Created by Hangqing Zhou on 2/15/15.
//  Copyright (c) 2015 ThoughtEvil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDateFormatter (TZToolKit)

+ (instancetype)currentDateFormatter;
+ (instancetype)dateFormatterWithLocale:(NSLocale *)locale;

@end
