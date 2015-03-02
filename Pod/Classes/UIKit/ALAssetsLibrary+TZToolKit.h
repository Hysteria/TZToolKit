//
//  ALAssetsLibrary+TZToolKit.h
//  TZToolKit
//
//  Created by Hangqing Zhou on 3/2/15.
//  Copyright (c) 2015 ThoughtEvil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(NSError* error);

@interface ALAssetsLibrary(TZToolKit)

- (void)saveAsset:(id)asset toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
- (void)saveVideoAtPath:(NSURL *)videoAtPath toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

- (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

@end