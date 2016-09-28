//
//  HSCCGMomentsViewModel.m
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCCGMomentsViewModel.h"

@implementation HSCCGMomentsViewModel

- (NSString *)description {
    return self.model.description;
}

- (NSString *)name
{
    return self.model.fromUser;
}

- (NSString *)iconName
{
    return self.model.fromUserImage;
}

- (NSString *)time
{
    return [Utils getCustomDateFromSeconds:self.model.createTim];
}

- (NSString *)msgContent
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGSize textSize = [self.model.content scm_sizeWithFont:[UIFont systemFontOfSize:15] maxW:contentW];
        if (textSize.height > SCMomentsMaxContentLabelHeight) {
            self.shouldShowMoreButton = YES;
        } else {
            self.shouldShowMoreButton = NO;
        }
    }
    
    return self.model.content;
}

-(BOOL)isOpening{
    return _isOpening;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!self.shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

-(BOOL)isCommentOpening{
    return _isCommentOpening;
}

- (void)setIsCommentOpening:(BOOL)isCommentOpening{
    
    _isCommentOpening = isCommentOpening;
    
}

-(BOOL)isShowAddition{
    return [[SCUserInfo sharedInstance].accountInfo.username isEqualToString:self.model.fromUsername];
}

- (NSArray<SCMomentsCellLikeItemModel *> *)likeItemsArray{
    
    return _likesArray;
    
}

-(void)setLikeItemsArray:(NSArray<SCMomentsCellLikeItemModel *> *)likeItemsArray{
    _likesArray = likeItemsArray;
}

- (NSArray<SCMomentsCellCommentItemModel *> *)commentItemsArray{
    
    return _commentsArray;
}

-(void)setCommentItemsArray:(NSArray<SCMomentsCellCommentItemModel *> *)commentItemsArray{
    
    _commentsArray = commentItemsArray;
    
}

- (BOOL)isLiked{
    return self.model.isLike;
}

- (void)setLiked:(BOOL)liked{
    self.model.isLike = liked;
}

- (NSMutableAttributedString *)likesStr{
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage sc_imageNamed:KSCImageMomentsModelAttack];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < self.likeItemsArray.count; i++) {
        SCMomentsCellLikeItemModel *model = self.likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        [attributedText appendAttributedString:[self generateAttributedStringWithLikeItemModel:model]];
        ;
    }
    
    return attributedText;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(SCMomentsCellLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [SCColor getColor:SC_COLOR_NAV_BG];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}

- (NSArray *)picNamesArray{

    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSDictionary *dict in _model.images) {
        if ([Utils isValidStr:dict[@"url"]]) {
            
            [tempArray addObject:dict[@"url"]];
        }
    }
    
    return tempArray;
}

-(void)setPicNamesArray:(NSArray *)picNamesArray{
    
}

- (NSArray *)bigPicNamesArray{
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSDictionary *dict in _model.images) {
        if ([Utils isValidStr:dict[@"urlB"]]) {
            
            [tempArray addObject:dict[@"urlB"]];
        }
    }
    
    return tempArray.count > 0 ? tempArray : [self picNamesArray];
    
}

- (void)setBigPicNamesArray:(NSArray *)bigPicNamesArray{
    
}

- (NSInteger)likeCount{
    return self.model.likeCount;
}

- (void)setLikeCount:(NSInteger)likeCount{
    self.model.likeCount = likeCount;
}

- (NSInteger)replyCount{
    return self.model.replyCount;
}

-(NSString *)id{
    return self.model.id;
}

@end
