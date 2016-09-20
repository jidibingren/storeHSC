//
//  SCImageSelector.h
//  ShiHua
//
//  Created by Pingan Yi on 9/25/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

DEFINE_CONST_STRING(kCameraOverlayView)
DEFINE_CONST_STRING(kCameraValidAreaWidth)
DEFINE_CONST_STRING(kCameraValidAreaHeight)
DEFINE_CONST_STRING(kUseCameraControls)
DEFINE_CONST_STRING(kCameraOverlayViewNote)
DEFINE_CONST_STRING(kCameraOverlayViewNoteDirection)

typedef NS_ENUM(NSUInteger, SCImageSelectorNoteDirection){
    SCImageSelectorNoteHorizontal,
    SCImageSelectorNoteVertical
};

typedef void(^SCImageSelectorCallback)(UIImage* image);

// 一个图片选择器
@interface SCImageSelector : NSObject 

+ (void) showIn: (UIViewController*)viewController isEditing:(BOOL)isEditing callback:(SCImageSelectorCallback)callback;
+ (void) showIn: (UIViewController*)viewController callback:(SCImageSelectorCallback)callback;
+ (void) showIn: (UIViewController*)viewController callback:(SCImageSelectorCallback)callback cropAspectRatio:(CGFloat)ratio;
+ (void) showIn: (UIViewController*)viewController callback:(SCImageSelectorCallback)callback attributes:(NSDictionary *)attrs;

@end
