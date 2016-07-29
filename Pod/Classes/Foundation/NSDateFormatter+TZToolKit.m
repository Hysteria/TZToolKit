//
//  NSDateFormatter+TZToolKit.m
//  TZToolKit
//
//  Created by Hangqing Zhou on 2/15/15.
//  Copyright (c) 2015 ThoughtEvil. All rights reserved.
//

#import "NSDateFormatter+TZToolKit.h"

@implementation NSDateFormatter (TZToolKit)

+ (instancetype)currentDateFormatter
{
    NSLocale *locale = [NSLocale currentLocale];
    return [self dateFormatterWithLocale:locale];
}

+ (instancetype)dateFormatterWithLocale:(NSLocale *)locale
{
    NSString *cacheKey = [NSString stringWithFormat:@"CachedDateFormatter_%@", locale.localeIdentifier];
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDict[cacheKey];
    if (!dateFormatter) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.locale = locale;
        threadDict[cacheKey] = dateFormatter;
    }
    return dateFormatter;

}

@end
