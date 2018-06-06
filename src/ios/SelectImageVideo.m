//
//  SelectImageVideo.m
//  BoyueApp
//
//  Created by Embrace on 2017/6/19.
//
//

#import "SelectImageVideo.h"

@implementation SelectImageVideo

-(NSMutableArray *)ImgArr {
    if (!_ImgArr) {
        _ImgArr = [[NSMutableArray alloc] init];
    }
    return _ImgArr;
}

///图片视频都可以选择
-(void)selectAll:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    weakSelf.picker.pickingVideoEnable = NO;
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:9 delegate:nil];
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = [NSString stringWithFormat:@"file:"];
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            //            NSURL* url = [NSURL fileURLWithPath:PathString];
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:PathString]) {
            //                [[NSFileManager defaultManager] removeItemAtPath:PathString error:nil];
            //            }
            //
            //            PathString = url.absoluteString;
            
            [self.ImgArr addObject:PathString];
            
        }
        [self array:self.ImgArr string:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}

/// 只选图片
-(void)selectImage:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:9 delegate:nil];
    weakSelf.picker.pickingVideoEnable = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        [self array:self.ImgArr string:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}


/// 只选择视频
-(void)selectVideo:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    //    weakSelf.picker.pickingVideoEnable = NO;
    //    weakSelf.picker.autoPushToPhotoCollection = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        [self array:self.ImgArr string:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}

/// 选择一个视频或者1张图片
-(void)selectAllSingle:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    //    weakSelf.picker.pickingVideoEnable = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        [self array:self.ImgArr string:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}

///选择一张图片
-(void)selectImageSingle:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    weakSelf.picker.pickingVideoEnable = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        [self array:self.ImgArr string:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}

///选择一个视频
-(void)selectVideoSingle:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:0 delegate:nil];
    weakSelf.picker.pickingVideoEnable = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        [self array:self.ImgArr string:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}



///视频回调
-(void)compressVideo:(PHAsset*)asset{
    [MediaUtils writePHVedio:asset toPath:nil block:^(NSURL *url) {
        if (!url) {
            //            NSLog(@"写入失败");
            
        }else{
            
            
            //            NSLog(@"写入完毕 %@", url);
            NSString *pathStr = url.absoluteString;
            [self array:nil string:pathStr];
            
            self.hasPendingOperation = NO;
            
            [MediaUtils convertVideoQuailtyWithInputURL:url outputURL:nil completeHandler:^(AVAssetExportSession *exportSession, NSURL* compressedOutputURL) {
                
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    //                    NSLog(@"压缩成功");
                    
                    [MediaUtils deleteFileByPath:url.path];
                    
                    if ([MediaUtils getFileSize:compressedOutputURL.path] > 1024 * 1024 * 5) {
                        //                        NSLog(@"压缩后还是大于5M");
                    }
                    
                    
                }else{
                    //                    NSLog(@"压缩失败");
                }
                
            }];
        }
    }];
}


/// 模态页面消失
-(void)dismissController {
    __weak SelectImageVideo *weakSelf = self;
    
    [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --- callBackToWebForPassUrl
-(void)array:(NSMutableArray *)Arr string:(NSString *)Str {
    NSDictionary *upLoadDic;
    
    if (Arr.count > 0 && Str.length == 0) {
        upLoadDic = [NSDictionary dictionaryWithObjectsAndKeys:Arr,@"picture", nil];
    } else if (Arr.count == 0 && Str.length != 0) {
        
        upLoadDic = [NSDictionary dictionaryWithObjectsAndKeys:Str,@"video", nil];
    }
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:upLoadDic];
    [self.commandDelegate sendPluginResult:result callbackId:self.latestCommand.callbackId];
    
    [_ImgArr removeAllObjects];
}
@end
