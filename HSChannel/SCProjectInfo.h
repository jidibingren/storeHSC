//
//  SCProjectInfo.h
//  HSChannel
//
//  Created by SC on 16/9/20.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KSCImageAttendanceRecordCellUncheck         @"attendance_icon_none"
#define KSCImageAttendanceRecordCellCheck           @"attendance_icon_ok"

#define KSCImageCGOperationMenuLikeNormal           @"moments_icon_like_normal"
#define KSCImageCGOperationMenuLikeSelect           @"moments_icon_like_selected"
#define KSCImageCGOperationMenuCommentNormal        @"moments_icon_comment"

#define KSCImageContactHeaderSelectButtonNormal     @"connection_ch_uncheck"
#define KSCImageContactHeaderSelectButtonSelect     @"connection_ch_checked"

#define KSCImageContactCellSelectButtonNormal       @"connection_ch_uncheck"
#define KSCImageContactCellSelectButtonSelect       @"connection_ch_checked"
#define KSCImageContactCellSignedDefault            @"connection_head_default"

#define KSCImageImageSelectCellDeleteButtonNormal   @"moments_icon_del"
#define KSCImageImageSelectCellBackground           @"daohangbeijing"
#define KSCImageImageSelectCellIconView             @"moments_icon_addpic"

#define KSCImageMessageCellSystemNotice             @"message_icon_notice"
#define KSCImageMessageCellSchoolNotice             @"message_icon_work"
#define KSCImageMessageCellClassNotice              @"message_icon_work"
#define KSCImageMessageCellClassDynamic             @"message_icon_work"
#define KSCImageMessageCellWork                     @"message_icon_work"
#define KSCImageMessageCellHeadDefault              @"message_head_default"

#define KSCImageMineBaseInfoBgHead                  @"info_bg_head"
#define KSCImageMineBaseInfoIconHead                @"info_icon_head"

#define KSCImageMineIconHead                        @"me_icon_head"

#define KSCImageSNDRangeCellIconHead                @"message_head_default"

#define KSCImageSTransCardCellIconDelete            @"icon_delete"

#define KSCImageSTransCardControllerSelectDown      @"icon_select_down"
#define KSCImageSTransCardControllerIconTitle       @"icon_title"

#define KSCImageSysNoticeDetailControllerIconTitle  @"icon_title"

#define KSCImageJYImageScrollBaseCellImageView      @"Launchimage"

#define KSCImageNewFeatureCellStartButtonNormal     @"btn_nor"
#define KSCImageNewFeatureCellStartButtonPressed    @"btn_pressed"

#define KSCImageNavibackground                      @"navibackground"

#define KSCImageHeadLineCellPlaceholder             @"school_pic_top"
#define KSCImageHeadLineCellBackground              @"school_pic_top"

#define KSCImageImageSelectorScan                   @"scan_bg"

#define KSCImageMessageViewControllerAvatar         @"EaseUIResource.bundle/user"
#define KSCImageMessageViewControllerFailed         @"imageDownloadFail"

#define KSCImageMomentsCellCommentBg                @"LikeCmtBg"

#define KSCImageMomentsCellLiekHeaderFooterAttach   @"moments_icon_like_selected"

#define KSCImageMomentsHeaderViewBackground         @"AlbumHeaderBackgrounImage.jpg"
#define KSCImageMomentsHeaderViewIcon               @"me.jpg"

#define KSCImageMomentsModelAttack                  @"moments_icon_like_selected"

#define KSCImageNormalTableViewCellMore             @"moments_icon_more"
#define KSCImageNormalTableViewCellRightView        @"real_icon_head"

#define KSCImageOperationMenuLikeButton             @"AlbumLike"
#define KSCImageOperationMenuCommentButton          @"AlbumComment"

#define KSCImagePictureBrowserDownloadNormal        @"picture_download_icon"
#define KSCImagePictureBrowserDownloadHighlight     @"picture_download_icon"
#define KSCImagePictureBrowserDownloadDisable       @"picture_download_icon"

#define KSCImageSchoolControllerSummary             @"school_icon_summary"
#define KSCImageSchoolControllerNotice              @"school_icon_notice"
#define KSCImageSchoolControllerNews                @"school_icon_news"
#define KSCImageSchoolControllerTeacher             @"school_icon_teacher"
#define KSCImageSchoolControllerCookBook            @"school_icon_cookbook"
#define KSCImageSchoolControllerTransCard           @"school_icon_cookbook"

#define KSCImageClassSircleControllerTimes          @"moments_icon_times"
#define KSCImageClassSircleControllerNotice         @"moments_icon_notice"
#define KSCImageClassSircleControllerWork           @"moments_icon_work"
#define KSCImageClassSircleControllerAttendance     @"moments_icon_attendance"
#define KSCImageClassSircleControllerLeave          @"moments_icon_leave"

#define KSCImageClassPublishControllerNotice        @"moments_icon_notice"

#define KSCImageMineBaseInfoControllerName          @"info_icon_name"
#define KSCImageMineBaseInfoControllerPassword      @"info_icon_password"
#define KSCImageMineBaseInfoControllerAccount       @"info_icon_account"
#define KSCImageMineBaseInfoControllerJoin          @"info_icon_join"
#define KSCImageMineBaseInfoControllerLocal         @"info_icon_local"
#define KSCImageMineBaseInfoControllerSchool        @"info_icon_school"
#define KSCImageMineBaseInfoControllerGrade         @"info_icon_grade"
#define KSCImageMineBaseInfoControllerPhone         @"info_icon_phone"
#define KSCImageMineBaseInfoControllerConnection    @"info_icon_connection"

#define KSCImageMineControllerAlbum                 @"me_icon_album"
#define KSCImageMineControllerLeave                 @"me_icon_leave"
#define KSCImageMineControllerShare                 @"me_icon_share"
#define KSCImageMineControllerFeedback              @"me_icon_feedback"
#define KSCImageMineControllerAbout                 @"me_icon_about"



typedef NS_ENUM(NSInteger, SCProjectType) {
    SCProjectShuXiangYuan = 0,
    SCProjectHaMi,
};

@interface SCProjectInfo : NSObject

@property (nonatomic, assign)SCProjectType type;

@property (nonatomic, strong)NSArray *tabbarTitles;

@property (nonatomic, strong)NSArray *tabbarNormalimages;

@property (nonatomic, strong)NSArray *tabbarSelectedimages;

@property (nonatomic, strong)NSDictionary *images;

@property (nonatomic, strong)NSDictionary *colors;

@property (nonatomic, strong)NSDictionary *strings;

@property (nonatomic, strong)NSDictionary *fonts;

@property (nonatomic, strong)NSDictionary *urls;

@end
