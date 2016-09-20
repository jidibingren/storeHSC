
#import "SCMomentsCellCommentViewCell.h"
#import "MLLabel.h"
#import "MLLinkLabel.h"
#import "SCMomentsModel.h"

@interface SCMomentsCellCommentViewCell()<MLLinkLabelDelegate>

@end

@implementation SCMomentsCellCommentViewCell 
{
    MLLinkLabel *_likeLabel;
//    YYLabel *_likeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _likeLabel = [MLLinkLabel new];
        UIColor *highLightColor = [UIColor blueColor];
        _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        _likeLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
        _likeLabel.font = [UIFont systemFontOfSize:14];
        _likeLabel.delegate = self;
        _likeLabel.numberOfLines = 0;
        _likeLabel.lineHeightMultiple = 1.1f;
//        _likeLabel.textInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [self.contentView addSubview:_likeLabel];
        
        
        [_likeLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLink:cellModel:)]) {
                [self.delegate didClickLink:linkText cellModel:self.status];
            }
            
        }];
        
        [_likeLabel setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressLink:cellModel:)]) {
                [self.delegate didLongPressLink:linkText cellModel:self.status];
            }
        }];
        
//        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
//        tapG.delegate = self;
//        [self.contentView addGestureRecognizer:tapG];
        
        [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressLink:cellModel:)]) {
        [self.delegate didTapedCell:self.status];
    }
}

- (void)setStatus:(SCMomentsCellCommentItemModel *)status
{
    _status = status;
    
    _likeLabel.attributedText = [self generateAttributedStringWithCommentItemModel:status];
    [_likeLabel sizeToFit];
}

#pragma mark - private actions
- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(SCMomentsCellCommentItemModel *)model
{
    NSString *text = model.firstUserName;
    NSRange range = {};
    if (model.secondUserName.length) {
        range.location = text.length+2;
        range.length = model.secondUserName.length;
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondUserName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.commentString]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    if (model.firstUserId) {
        
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.firstUserId} range:[text rangeOfString:model.firstUserName]];
    }
    
    if (model.secondUserName.length && model.secondUserId) {
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.secondUserId} range:range];
    }
    return attString;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
}
@end
