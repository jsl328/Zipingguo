//
//  DCInternalCamera.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-4.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCSelectImageDialogDefaultImpl.h"
#import "FileSystem.h"
#import "DCFilePathHelper.h"
#import "DCImageIO.h"

@implementation DCSelectImageDialogDefaultImpl {

    id _callback;
}


-(BOOL) isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

-(void) openSelectImageDialog:(BOOL)isCamera callback:(void (^)(void))callback {
    
    _callback = callback;

    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    controller.sourceType = isCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary + UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    controller.delegate = self;
    
    [[AppContext controller] presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSString* imageFilePath = [[AppContext storageResolver] pathForPickedFile:@"jpg"];
    [FileSystem ensureDirectoryExists:[DCFilePathHelper folderPathForFilePath:imageFilePath]];
    
    NSData* jpgImageData = UIImageJPEGRepresentation([DCImageIO downsampledImageFromImage:image withDimensionNoMoreThan:self.maxDimension], 1);
    [jpgImageData writeToFile:imageFilePath atomically:NO];
    
    
    self.selectedFilePath = imageFilePath;

    ((void (^)(void))_callback)();
    _callback = nil;
    
    [[AppContext controller] dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[AppContext controller] dismissViewControllerAnimated:YES completion:^{
        ((void (^)(void))_callback)();
        _callback = nil;
    }];
}

@end
