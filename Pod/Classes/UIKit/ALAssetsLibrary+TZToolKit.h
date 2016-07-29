//
//  ALAssetsLibrary+TZToolKit.h
//  TZToolKit
//
//  Created by Hangqing Zhou on 3/2/15.
//  Copyright (c) 2015 ThoughtEvil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^CompletionBlock)(NSError* error);

@interface ALAssetsLibrary(TZToolKit)

- (void)saveAssetAtPath:(NSURL *)assetAtPath toAlbum:(NSString *)albumName withCompletionBlock:(CompletionBlock)completionBlock;
- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName withCompletionBlock:(CompletionBlock)completionBlock;
- (void)saveVideoAtPath:(NSURL *)videoAtPath toAlbum:(NSString *)albumName withCompletionBlock:(CompletionBlock)completionBlock;

- (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName withCompletionBlock:(CompletionBlock)completionBlock;

@end