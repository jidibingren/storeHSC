//
//  SCImageSelector.m
//  ShiHua
//
//  Created by Pingan Yi on 9/25/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import "SCImageSelector.h"
#import "PECropViewController.h"
#import "UIImage+PECrop.h"
#import "UIImage+Resize.h"
#import <sys/utsname.h>

#define MAGNIFICATION         MAX(1,3264/(2448/ScreenWidth)/480)
#define MAGNIFICATION_WIDTH   ([self screenWidth] == 414 ? (5.5/4) : ([self screenWidth] == 375 ? (4.7/4) : 1))
#define MAGNIFICATION_HEIGHT  ([self screenWidth] == 414 ? (5.5/4) : ([self screenWidth] == 375 ? (4.7/4) : 1))

#define CUSTOM_CAMERA_CONTROL_HEIGHT  (ScreenHeight == 480 ? 74 : (ScreenHeight-3264/(2448/ScreenWidth)))

#define NORMAL_BUTTON_WIDTH           40
#define NORMAL_BUTTON_HEIGHT          (74-6)
#define TAKE_PICTURE_BUTTON_WIDTH     NORMAL_BUTTON_HEIGHT
#define TAKE_PICTURE_BUTTON_HEIGHT    NORMAL_BUTTON_HEIGHT
#define TAKE_PICTURE_BUTTON_CENTER_MARGIN 2
#define BORDER_WIDTH    6
#define MARGIN_LEFT     12
#define MARGIN_RIGHT    12
#define kSCNotificationShowSelectedImage  @"kSCNotificationShowSelectedImage"

@class SCImageSelector;
@interface SCCustomCameraControl : NSObject

STD_PROP UIButton *takePicture;
STD_PROP UIButton *cancel;
STD_PROP UIButton *reTakePicture;
STD_PROP UIButton *usePicture;
STD_PROP UIView   *tableBar;
STD_PROP UIImage  *image;
STD_PROP UIView   *contentView;
STD_PROP UIImageView *selectedImageView;
STD_PROP UIImagePickerController *imagePicker;
@property (nonatomic, weak)UIViewController *viewController;

@end

@implementation SCCustomCameraControl

- (instancetype)init{
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{

    _contentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x += 12;
    frame.origin.y += 12;
    frame.size.width -= 24;
    frame.size.height -= 24;
    _selectedImageView = [[UIImageView alloc]initWithFrame:frame];
    _selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    _selectedImageView.backgroundColor = [UIColor blackColor];
    [_selectedImageView setHidden:YES];
    [_contentView addSubview:_selectedImageView];
    [_contentView sendSubviewToBack:_selectedImageView];
    
    _tableBar = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-CUSTOM_CAMERA_CONTROL_HEIGHT, ScreenWidth, CUSTOM_CAMERA_CONTROL_HEIGHT)];
    _tableBar.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_tableBar];
    [_contentView bringSubviewToFront:_tableBar];
    
    DEFINE_WEAK(self);
    _takePicture = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-TAKE_PICTURE_BUTTON_WIDTH)/2, (CUSTOM_CAMERA_CONTROL_HEIGHT-TAKE_PICTURE_BUTTON_HEIGHT)/2, TAKE_PICTURE_BUTTON_WIDTH, TAKE_PICTURE_BUTTON_HEIGHT)];
    _takePicture.backgroundColor = [UIColor clearColor];
    _takePicture.layer.borderWidth = BORDER_WIDTH;
    _takePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    _takePicture.layer.cornerRadius = TAKE_PICTURE_BUTTON_WIDTH/2;
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(TAKE_PICTURE_BUTTON_CENTER_MARGIN, TAKE_PICTURE_BUTTON_CENTER_MARGIN, TAKE_PICTURE_BUTTON_WIDTH-TAKE_PICTURE_BUTTON_CENTER_MARGIN*2, TAKE_PICTURE_BUTTON_HEIGHT-TAKE_PICTURE_BUTTON_CENTER_MARGIN*2)];
    centerView.backgroundColor = [UIColor clearColor];
    centerView.layer.cornerRadius = centerView.frame.size.width/2;
    UIButton *centerView2 = [[UIButton alloc]initWithFrame:CGRectMake(BORDER_WIDTH, BORDER_WIDTH, centerView.frame.size.width-BORDER_WIDTH*2, centerView.frame.size.height-BORDER_WIDTH*2)];
    centerView2.backgroundColor = [UIColor whiteColor];
    centerView2.layer.cornerRadius = centerView2.frame.size.width/2;
    [centerView2 bk_addEventHandler:^(UIButton *sender) {
        dispatch_main_async_safe(^{
            sender.backgroundColor = [UIColor whiteColor];
            [wself.imagePicker takePicture];
            [wself.contentView setBackgroundColor:[UIColor blackColor]];
        });
    } forControlEvents:UIControlEventTouchUpInside];
    
    [centerView2 bk_addEventHandler:^(UIButton *sender) {
        sender.backgroundColor = [UIColor clearColor];
    } forControlEvents:UIControlEventTouchDown];
    
    [centerView addSubview:centerView2];
    [_takePicture addSubview:centerView];
    [_tableBar addSubview:_takePicture];
    
    _cancel = [[UIButton alloc]initWithFrame:CGRectMake(MARGIN_LEFT, (CUSTOM_CAMERA_CONTROL_HEIGHT-NORMAL_BUTTON_HEIGHT)/2, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT)];
    _cancel.backgroundColor = [UIColor clearColor];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    _cancel.titleLabel.textColor = [UIColor whiteColor];
    _cancel.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_cancel bk_addEventHandler:^(id sender) {
        [wself.imagePicker.delegate imagePickerControllerDidCancel:wself.imagePicker];
        wself.imagePicker = nil;
        [wself.contentView removeFromSuperview];
    } forControlEvents:UIControlEventTouchUpInside];
    [_cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_tableBar addSubview:_cancel];
    
    _reTakePicture = [[UIButton alloc]initWithFrame:CGRectMake(MARGIN_LEFT, (CUSTOM_CAMERA_CONTROL_HEIGHT-NORMAL_BUTTON_HEIGHT)/2, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT)];
    _reTakePicture.backgroundColor = [UIColor clearColor];
    [_reTakePicture setTitle:@"重拍" forState:UIControlStateNormal];
    _reTakePicture.titleLabel.textColor = [UIColor whiteColor];
    _reTakePicture.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_reTakePicture bk_addEventHandler:^(id sender) {
        [wself.takePicture setHidden:NO];
        [wself.cancel setHidden:NO];
        [wself.usePicture setHidden:YES];
        [wself.reTakePicture setHidden:YES];
        [wself.selectedImageView setHidden:YES];
        [wself.viewController presentViewController:wself.imagePicker animated:NO completion:^{
            [wself.contentView setBackgroundColor:[UIColor clearColor]];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    [_reTakePicture setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_reTakePicture setHidden:YES];
    [_tableBar addSubview:_reTakePicture];
    
    _usePicture = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-MARGIN_RIGHT-80, (CUSTOM_CAMERA_CONTROL_HEIGHT-NORMAL_BUTTON_HEIGHT)/2, 80, NORMAL_BUTTON_HEIGHT)];
    _usePicture.backgroundColor = [UIColor clearColor];
    [_usePicture setTitle:@"使用照片" forState:UIControlStateNormal];
    _usePicture.titleLabel.textColor = [UIColor whiteColor];
    _usePicture.titleLabel.textAlignment = NSTextAlignmentRight;
    [_usePicture bk_addEventHandler:^(id sender) {
        [wself.imagePicker.delegate performSelector:@selector(callCallback:) withObject:_image];
        wself.imagePicker = nil;
        [wself.contentView removeFromSuperview];
    } forControlEvents:UIControlEventTouchUpInside];
    [_usePicture setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_usePicture setHidden:YES];
    [_tableBar addSubview:_usePicture];

}

- (void)showSelectedImage:(NSNotification*)noti{
    UIImage *image = noti.object;
    _image = image;
    
    [_selectedImageView setImage:image];
    [_selectedImageView setHidden:NO];
    [_takePicture setHidden:YES];
    [_cancel setHidden:YES];
    [_usePicture setHidden:NO];
    [_reTakePicture setHidden:NO];
}

@end


@interface SCImageSelector() <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate> {
    //下拉菜单
    UIActionSheet * _myActionSheet;
    SCImageSelector* _self;
}

STD_PROP UIViewController* viewController;
STD_PROP SCImageSelectorCallback callback;
STD_PROP NSDictionary *attrs;
STD_PROP SCCustomCameraControl *customCamerControl;
@property (nonatomic) CGFloat aspectRatio;
@property (nonatomic)BOOL isEditing;
@property (nonatomic)CGFloat cameraValidAreaWidth;
@property (nonatomic)CGFloat cameraValidAreaHeight;
- (void) show;

@end

@implementation SCImageSelector

+ (void) showIn: (UIViewController*)viewController isEditing:(BOOL)isEditing callback:(SCImageSelectorCallback)callback {
    SCImageSelector* selector = [[SCImageSelector alloc]init];
    selector.viewController = viewController;
    selector.callback = callback;
    selector.isEditing = isEditing;
    [selector show];
}

+ (void) showIn: (UIViewController*)viewController callback:(SCImageSelectorCallback)callback {
    [self showIn:viewController isEditing:NO callback:callback];
}

+ (void) showIn:(UIViewController *)viewController callback:(SCImageSelectorCallback)callback cropAspectRatio:(CGFloat)ratio
{
    SCImageSelector* selector = [[SCImageSelector alloc]init];
    selector.viewController = viewController;
    selector.callback = callback;
    selector.isEditing = YES;
    selector.aspectRatio = ratio;
    [selector show];
}

+ (void) showIn: (UIViewController*)viewController callback:(SCImageSelectorCallback)callback attributes:(NSDictionary *)attrs{
    SCImageSelector* selector = [[SCImageSelector alloc]init];
    selector.viewController = viewController;
    selector.callback = callback;
    selector.isEditing = NO;
    selector.attrs = attrs;
    [selector show];
}
- (void) show {
    _self = self;
    _myActionSheet = [[UIActionSheet alloc]
                      initWithTitle:nil
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"取消", nil)
                      destructiveButtonTitle:nil
                      otherButtonTitles: NSLocalizedString(@"打开照相机", nil), NSLocalizedString(@"从手机相册获取", nil),nil];

    [_myActionSheet showInView:self.viewController.view];
}

- (void) callCallback: (UIImage*) image {
    if (_callback) {
        
        CGFloat width = image.size.width;
        if (width > 512) {
            image = [Utils scaleImage:image toSize:512];
        }
        
        _callback(image);
        _callback = nil;
    }
    _self = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == _myActionSheet.cancelButtonIndex) {
        [self callCallback:nil];
        return;
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self selectLocalPhoto];
            break;
    }
}

- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        picker.sourceType = sourceType;
        picker.cameraOverlayView = [self createCameraOverlayView];
        if ([[_attrs valueForKey:kUseCameraControls] boolValue] == YES) {
            picker.showsCameraControls = NO;
            if (_customCamerControl == nil) {
                _customCamerControl = [SCCustomCameraControl new];
                _customCamerControl.imagePicker = picker;
                _customCamerControl.viewController = self.viewController;
                [[NSNotificationCenter defaultCenter]addObserver:_customCamerControl selector:@selector(showSelectedImage:) name:kSCNotificationShowSelectedImage object:nil];
                [[Utils getDefaultWindow]addSubview:_customCamerControl.contentView];
                [[Utils getDefaultWindow]bringSubviewToFront:_customCamerControl.contentView];
            }
        }
        [self.viewController presentViewController:picker animated:YES completion:nil];
    } else {
        [self.viewController.view makeShortToastAtCenter:NSLocalizedString(@"相机不可用", nil)];
        [self callCallback:nil];
    }
}

- (void)selectLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if (![type isEqualToString:@"public.image"]) {
        [self.viewController.view makeShortToastAtCenter:NSLocalizedString(@"您选择的不是图片", nil)];
        [self callCallback:nil];
        return;
    }
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        if (_isEditing)
            [self openEditor:image];
        else {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && picker.cameraOverlayView && ([[_attrs valueForKey:kUseCameraControls] boolValue] == YES || [_attrs valueForKey:kCameraOverlayView] != nil)) {
                
                UIImage *tempImage = nil;
                CGFloat validWidth = [[_attrs valueForKey:kCameraValidAreaWidth] floatValue];
                CGFloat validHeight = MIN([[_attrs valueForKey:kCameraValidAreaHeight] floatValue], (ScreenHeight-CUSTOM_CAMERA_CONTROL_HEIGHT));
                CGFloat imageWidth  = MIN(image.size.width, image.size.height);
                CGFloat imageHeight = MAX(image.size.width, image.size.height);
                CGFloat coefficientX = imageWidth/(ScreenHeight == 480 ? (ScreenHeight*(imageWidth/imageHeight)) : (ScreenWidth*MAGNIFICATION_WIDTH));
                CGFloat coefficientY = imageHeight/(ScreenHeight == 480 ? 480 : ((ScreenHeight-CUSTOM_CAMERA_CONTROL_HEIGHT)*MAGNIFICATION_HEIGHT));
                
                CGRect tempFrame = CGRectMake(((ScreenHeight == 480 ? (ScreenHeight*(imageWidth/imageHeight)) : (ScreenWidth*MAGNIFICATION_WIDTH))-validWidth)/2*coefficientX, (ScreenHeight*MAGNIFICATION_HEIGHT-validHeight-CUSTOM_CAMERA_CONTROL_HEIGHT*MAGNIFICATION_HEIGHT)/2*coefficientY, validWidth*coefficientX, validHeight*coefficientY);
                
                if (image.size.width > image.size.height) {
                    tempImage = [[UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight] rotatedImageWithtransform:CGAffineTransformMakeRotation(0) croppedToRect:tempFrame];
                }else {
                    tempImage = [image rotatedImageWithtransform:CGAffineTransformMakeRotation(0) croppedToRect:tempFrame];
                }
                
                UIImage *smallImage = [UIImage imageWithCGImage:tempImage.CGImage scale:tempImage.size.width/validWidth/2 orientation:UIImageOrientationUp];

                if (([[_attrs valueForKey:kUseCameraControls] boolValue] == YES)) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kSCNotificationShowSelectedImage object:smallImage];
                }else {
                    [self callCallback:smallImage];
                }
            }else {
                [self callCallback:image];
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self callCallback:nil];
}

- (void)openEditor:(UIImage*)image
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    controller.toolbarHidden = YES;
    if (_aspectRatio > 1e-4) {
        controller.cropAspectRatio = _aspectRatio;
        controller.keepingCropAspectRatio = YES;
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.viewController presentViewController:navigationController animated:YES completion:NULL];
}

- (UIView *)createCameraOverlayView{
    
    if ([_attrs valueForKey:kCameraOverlayView]) {
        return [_attrs valueForKey:kCameraOverlayView];
    }
    
    if (![_attrs valueForKey:kCameraValidAreaWidth] || ![_attrs valueForKey:kCameraValidAreaHeight]) {
        return nil;
    }
    CGFloat height = MIN(self.cameraValidAreaHeight, ScreenHeight-CUSTOM_CAMERA_CONTROL_HEIGHT);
    CGRect tempFrame = CGRectMake((ScreenWidth-self.cameraValidAreaWidth)/2, (ScreenHeight-CUSTOM_CAMERA_CONTROL_HEIGHT-height)/2, self.cameraValidAreaWidth, height);
    UIGraphicsBeginImageContext(CGSizeMake(ScreenWidth, ScreenHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.3);
    CGRect drawRect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    CGContextFillRect(context, drawRect);
    drawRect = tempFrame;
    CGContextClearRect(context, drawRect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *cameraOverlayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    cameraOverlayView.backgroundColor = [UIColor clearColor];
    cameraOverlayView.image = image;
    
    UIImageView *scanImageView = [[UIImageView alloc]initWithFrame:tempFrame];
    scanImageView.image = [UIImage sc_imageNamed:KSCImageImageSelectorScan];
    [cameraOverlayView addSubview:scanImageView];
    
    if ([_attrs valueForKey:kCameraOverlayViewNote]) {
        UILabel *noteLabel = nil;
        if ([[_attrs valueForKey:kCameraOverlayViewNoteDirection] integerValue] == SCImageSelectorNoteVertical) {
            noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(-(ScreenHeight-CUSTOM_CAMERA_CONTROL_HEIGHT)/2+tempFrame.origin.x/2, (ScreenHeight-CUSTOM_CAMERA_CONTROL_HEIGHT)/2-10, ScreenHeight-CUSTOM_CAMERA_CONTROL_HEIGHT, 20)];

            noteLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else {
            noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (tempFrame.size.height-20)/2, tempFrame.size.width, 20)];
        }
        
        noteLabel.text = [_attrs valueForKey:kCameraOverlayViewNote];
        noteLabel.textColor = [UIColor whiteColor];
        noteLabel.font = [UIFont systemFontOfSize:13];
        noteLabel.textAlignment = NSTextAlignmentCenter;
        noteLabel.backgroundColor = [UIColor clearColor];
        [cameraOverlayView addSubview:noteLabel];
    }
    
    return cameraOverlayView;
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage;
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self callCallback:croppedImage];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self callCallback:nil];
}

- (void) dealloc {
    
}

#pragma mark - Getters And Setters

- (CGFloat)cameraValidAreaWidth{
    return [[_attrs valueForKey:kCameraValidAreaWidth] floatValue]/MAGNIFICATION_WIDTH;
}

- (CGFloat)cameraValidAreaHeight{
    return [[_attrs valueForKey:kCameraValidAreaHeight] floatValue]/MAGNIFICATION_HEIGHT;
}

- (CGFloat)screenWidth{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    CGFloat width = 320;
    
    if ([platform isEqualToString:@"iPhone7,2"]) {
        width = 375;
    } else if ([platform isEqualToString:@"iPhone7,1"]){
        width = 414;
    }
    return width;
}

- (CGFloat)screenHeight{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    CGFloat height = 480;
    
    if ([platform isEqualToString:@"iPod1,1"] ||
        [platform isEqualToString:@"iPod2,1"] ||
        [platform isEqualToString:@"iPod3,1"] ||
        [platform isEqualToString:@"iPod4,1"] ||
        [platform isEqualToString:@"iPhone3,1"] ||
        [platform isEqualToString:@"iPhone3,2"] ||
        [platform isEqualToString:@"iPhone4,1"]) {
        
        height = 480;
        
    } else if ([platform isEqualToString:@"iPod5,1"] ||
               [platform isEqualToString:@"iPhone5,1"] ||
               [platform isEqualToString:@"iPhone5,2"] ||
               [platform isEqualToString:@"iPhone5,3"] ||
               [platform isEqualToString:@"iPhone5,4"] ||
               [platform isEqualToString:@"iPhone6,1"] ||
               [platform isEqualToString:@"iPhone6,2"]){
        
        height = 568;
        
    } else if ([platform isEqualToString:@"iPhone7,2"] ||
               [platform isEqualToString:@"iPhone8,1"]) {
        height = 667;
    } else if ([platform isEqualToString:@"iPhone7,1"] ||
               [platform isEqualToString:@"iPhone8,2"]){
        height = 736;
    }
    
    return height;
}

@end
