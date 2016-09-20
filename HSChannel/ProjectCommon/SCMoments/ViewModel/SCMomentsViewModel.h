
#import <Foundation/Foundation.h>
#import "SCMomentsModel.h"

extern CGFloat SCMomentsMaxContentLabelHeight;

@interface SCMomentsViewModel : NSObject{
    CGFloat _lastContentWidth;
    BOOL _isCommentOpening;
    BOOL _isOpening;
}

/// 微博模型
@property (nonatomic, strong) SCMomentsModel *status;

/// 用户头像
@property (nonatomic, readonly) NSString *iconName;

@property (nonatomic, readonly) NSString *iconPlaceholderName;

/// 用户名字
@property (nonatomic, readonly) NSString *name;

/// 内容
@property (nonatomic, copy) NSString *msgContent;

/// 配图
@property (nonatomic, strong) NSArray *picNamesArray;

@property (nonatomic, strong) NSArray *bigPicNamesArray;

@property (nonatomic, strong) NSArray<SCMomentsCellLikeItemModel *> *likeItemsArray;

@property (nonatomic, strong) NSArray<SCMomentsCellCommentItemModel *> *commentItemsArray;

/// 配图
@property (nonatomic, readonly) NSString *time;

// 是否点赞
@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, assign) NSInteger likeCount;

@property (nonatomic, assign) NSInteger replyCount;

// 点赞文字
@property (nonatomic, copy) NSMutableAttributedString *likesStr;

+ (instancetype)viewModelWithStatus:(SCMomentsModel *)status;

/// 是否展开
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign) BOOL isCommentOpening;
@property (nonatomic, assign) BOOL shouldShowMoreButton;
@property (nonatomic, assign) BOOL isShowAddition;

@end
