//
//  UIViewController+TZToolKit.m
//  HiddenCam
//
//  Created by Zhou Hangqing on 2/10/15.
//  Copyright (c) 2015 ThoughtEvil Studio. All rights reserved.
//

#import "UIViewController+TZToolKit.h"

@implementation UIViewController (TZToolKit)

- (UIInterfaceOrientation)currentOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return orientation;
}

- (BOOL)isLandscape
{
    return UIInterfaceOrientationIsLandscape(self.currentOrientation);
}

- (BOOL)isPortrait
{
    return UIInterfaceOrientationIsPortrait(self.currentOrientation);
}


@end
