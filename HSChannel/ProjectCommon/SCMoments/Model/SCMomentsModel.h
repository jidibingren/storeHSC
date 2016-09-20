
#import <Foundation/Foundation.h>

@class SCMomentsCellLikeItemModel, SCMomentsCellCommentItemModel;

@interface SCMomentsModel : NSObject{
#ifdef SC_TP_KEYVALUE_MAPPING
    DCKeyValueObjectMapping *_dicParser;
#endif
}

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;
@property (nonatomic, strong) NSArray *bigPicNamesArray;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSArray<SCMomentsCellLikeItemModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<SCMomentsCellCommentItemModel *> *commentItemsArray;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign) BOOL isCommentOpening;

@property (nonatomic, assign) BOOL shouldShowMoreButton;

// 是否点赞
@property (nonatomic, assign, getter = isLiked) BOOL liked;


// 点赞文字
@property (nonatomic, copy) NSMutableAttributedString *likesStr;


- (id)initWithDictionary:(NSDictionary *)dic;

- (void)additionParserConfig:(DCParserConfiguration*)config;

- (void) updateWithDictionary: (NSDictionary*)dic;

@end


@interface SCMomentsCellLikeItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@end


@interface SCMomentsCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@end