//
//  TZHelper.h
//  TZToolKit
//
//  Created by Hangqing Zhou on 15/1/6.
//  Copyright (c) 2015年 ThoughtEvil. All rights reserved.
//

#ifndef TZToolKit_TZHelper_h
#define TZToolKit_TZHelper_h

#define TZ_DESIGNATED_INITIALIZER                   __attribute__((objc_designated_initializer))
#define TZ_UNAVAILABLE_INSTEAD(INSTEAD)             __attribute__((unavailable(#INSTEAD)))

#ifdef DEBUG
#define DLog(format, ...)       fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(DDLogInfo)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");
#else
#define DLog(...){};
#endif

#define ARRSIZE(a)      (sizeof(a) / sizeof(a[0]))

#pragma mark - OS

static inline BOOL tz_OSVersionIsAtLeastiOS7() {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}

static inline BOOL tz_OSVersionIsAtLeastiOS8() {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1);
}

static inline BOOL tz_OSVersionIsAtLeast(float versionValue) {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= versionValue;
}

#pragma mark - Bundle

static inline NSString *tz_APPDisplayName()
{
    NSString *APPName = [[NSBundle mainBundle] localizedInfoDictionary][@"CFBundleDisplayName"];
    return APPName;
}

#endif
