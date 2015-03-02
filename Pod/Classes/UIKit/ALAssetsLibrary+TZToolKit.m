//
//  ALAssetsLibrary+TZToolKit.m
//  TZToolKit
//
//  Created by Hangqing Zhou on 3/2/15.
//  Copyright (c) 2015 ThoughtEvil. All rights reserved.
//

#import "ALAssetsLibrary+TZToolKit.h"

@implementation ALAssetsLibrary(TZToolKit)

- (void)saveAsset:(id)asset toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    NSAssert([asset isKindOfClass:[UIImage class]] || [asset isKindOfClass:[NSURL class]], @"asset must be UIImage or URL of video");
    if ([asset isKindOfClass:[UIImage class]]) {
        [self saveImage:asset toAlbum:albumName withCompletionBlock:completionBlock];
    } else {
        [self saveVideoAtPath:asset toAlbum:albumName withCompletionBlock:completionBlock];
    }
}

- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    //write the image data to the assets library (camera roll)
    [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL* assetURL, NSError* error) {
        //error handling
        if (error != nil) {
            completionBlock(error);
            return;
        }
        
        //add the asset to the custom photo album
        [self addAssetURL:assetURL toAlbum:albumName withCompletionBlock:completionBlock];
    }];
}

- (void)saveVideoAtPath:(NSURL *)videoAtPath toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    if (![self videoAtPathIsCompatibleWithSavedPhotosAlbum:videoAtPath]) {
        NSLog(@"video at path %@ is not compatible", videoAtPath);
        return;
    }
    //write the video data to the assets library (camera roll)
    [self writeVideoAtPathToSavedPhotosAlbum:videoAtPath completionBlock:^(NSURL *assetURL, NSError *error) {
        //error handling
        if (error != nil) {
            completionBlock(error);
            return;
        }
        
        //add the asset to the custom photo album
        [self addAssetURL:assetURL toAlbum:albumName withCompletionBlock:completionBlock];
    }];
}

- (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    //search all photo albums in the library
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        //compare the names of the albums
        if ([albumName isEqualToString:[group valueForProperty:ALAssetsGroupPropertyName]]) {
            
            //get a hold of the photo's asset instance
            [self assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                              
              //add photo to the target album
              [group addAsset:asset];
              
              //run the completion block
              completionBlock(nil);
                
            } failureBlock: completionBlock];

            return;
        }
        
        if (!group) {
            
            //photo albums are over, target album does not exist, thus create it
            __weak ALAssetsLibrary* weakSelf = self;

            //create new assets album
            [self addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
                //get the photo's instance
                [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {

                    //add photo to the newly created album
                    [group addAsset:asset];
                    
                    //call the completion block
                    completionBlock(nil);
                    
                } failureBlock:completionBlock];
                
            } failureBlock:completionBlock];

            return;
        }
        
    } failureBlock: completionBlock];
}

@end
