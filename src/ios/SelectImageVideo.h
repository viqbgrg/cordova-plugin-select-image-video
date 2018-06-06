//
//  SelectImageVideo.h
//  BoyueApp
//
//  Created by Embrace on 2017/6/19.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "XMNPhotoPickerFramework.h"
#import "MediaUtils.h"

@interface SelectImageVideo : CDVPlugin
-(void)selectAll:(CDVInvokedUrlCommand *)command;
-(void)selectImage:(CDVInvokedUrlCommand *)command;
-(void)selectVideo:(CDVInvokedUrlCommand *)command;
-(void)selectAllSingle:(CDVInvokedUrlCommand *)command;
-(void)selectImageSingle:(CDVInvokedUrlCommand *)command;
-(void)selectVideoSingle:(CDVInvokedUrlCommand *)command;




-(void)dismissController ;
@property (nonatomic,strong) NSMutableArray *ImgArr;
@property (nonatomic, strong) NSMutableArray<XMNAssetModel*>* models;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;
@property (readwrite, assign) BOOL hasPendingOperation;
@property (nonatomic, strong) XMNPhotoPickerController* picker;
@property (nonatomic, strong) UINavigationController *nav;
-(void) array:(NSMutableArray *)Arr string:(NSString *)Str;
@end
