//
//  UIViewController+TZToolKit.h
//  HiddenCam
//
//  Created by Zhou Hangqing on 2/10/15.
//  Copyright (c) 2015 ThoughtEvil Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TZToolKit)

@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;
@property (nonatomic, readonly) BOOL isLandscape;
@property (nonatomic, readonly) BOOL isPortrait;


@end
