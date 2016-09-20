
#import "SCMomentsViewModel.h"

extern CGFloat SCMomentsMaxContentLabelHeight;

@implementation SCMomentsViewModel

+ (instancetype)viewModelWithStatus:(SCMomentsModel *)status {
    SCMomentsViewModel *obj = [[self alloc] init];
    
    obj.status = status;
    
    return obj;
}

- (NSString *)description {
    return self.status.description;
}

- (NSString *)name
{
    return self.status.name;
}

- (NSString *)iconName
{
    return self.status.iconName;
}

- (NSString *)iconPlaceholderName{
    return @"connection_head_default";
}

- (NSString *)time
{
    return self.status.time;
}

- (NSString *)msgContent
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGSize textSize = [self.status.msgContent scm_sizeWithFont:[UIFont systemFontOfSize:15] maxW:contentW];
        if (textSize.height > SCMomentsMaxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }

    return self.status.msgContent;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
        _status.isOpening = NO;
    } else {
        _isOpening = isOpening;
        _status.isOpening = isOpening;
    }
}

- (void)setIsCommentOpening:(BOOL)isCommentOpening{
    
    _isCommentOpening = isCommentOpening;
    _status.isCommentOpening = isCommentOpening;
    
}

- (NSArray<SCMomentsCellLikeItemModel *> *)likeItemsArray{
    
    return _status.likeItemsArray;
    
}

-(void)setLikeItemsArray:(NSArray<SCMomentsCellLikeItemModel *> *)likeItemsArray{
    
    self.status.likeItemsArray = likeItemsArray;
    
}

- (NSArray<SCMomentsCellCommentItemModel *> *)commentItemsArray{
    
    return _status.commentItemsArray;
}

-(void)setCommentItemsArray:(NSArray<SCMomentsCellCommentItemModel *> *)commentItemsArray{
    
    self.status.commentItemsArray = commentItemsArray;
    
}

- (BOOL)isLiked{
    return _status.isLiked;
}

- (void)setLiked:(BOOL)liked{
    self.status.liked = liked;
}

- (NSMutableAttributedString *)likesStr{
    return _status.likesStr;
}

- (NSArray *)picNamesArray{
    
    return _status.picNamesArray;
}

-(void)setPicNamesArray:(NSArray *)picNamesArray{
    self.status.picNamesArray = picNamesArray;
}

- (NSArray *)bigPicNamesArray{
    
    return _status.bigPicNamesArray.count > 0 ? _status.bigPicNamesArray : _status.picNamesArray;
    
}

- (void)setBigPicNamesArray:(NSArray *)bigPicNamesArray{
    self.status.bigPicNamesArray = bigPicNamesArray;
}

@end
