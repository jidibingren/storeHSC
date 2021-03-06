
#define SHOW_SIMPLE_TIPS(m) [[[UIAlertView alloc] initWithTitle:@"" message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

#import "SCMomentsCellLikeViewCell.h"
#import "MLLinkLabel.h"
#import "SCMomentsViewModel.h"

@interface SCMomentsCellLikeHeaderFooterView() <MLLinkLabelDelegate>

@end

@implementation SCMomentsCellLikeHeaderFooterView
{
    MLLinkLabel *_label;
    
    UIImageView *_divider;
}

+ (instancetype)cellWithTable:(UITableView *)tableView
{
    static NSString *ID = nil;
    if (ID == nil) {
        ID = [NSString stringWithFormat:@"%@ID", NSStringFromClass(self)];
    }
    id header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!header) {
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
    
        self.backgroundColor = [SCColor getColor:@"f3f3f3"];
        
        _label = [MLLinkLabel new];
        
        _label.numberOfLines = 0;
//        _label.lineHeightMultiple = 1.1f;
        _label.font = [UIFont systemFontOfSize:14];
        UIColor *highLightColor = [SCColor getColor:SC_COLOR_NAV_BG];
        _label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        _label.activeLinkTextAttributes = @{NSForegroundColorAttributeName:highLightColor,NSBackgroundColorAttributeName:[UIColor clearColor]};
        _label.delegate = self;
        
        
//        [_label setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
//            SHOW_SIMPLE_TIPS(tips);
//        }];
//        
//        [_label setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSString *tips = [NSString stringWithFormat:@"LongPress\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
//            SHOW_SIMPLE_TIPS(tips);
//        }];
        
        
        _divider = [[UIImageView alloc] init];
        _divider.alpha = 0.3f;
        _divider.backgroundColor = [UIColor grayColor];
        
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_divider];
        
        
        [_divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(_divider);
        }];
        
        
//        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
//        tapG.delegate = self;
//        [self.contentView addGestureRecognizer:tapG];
        
    }
    return self;
}

- (void)tap
{
    SHOW_SIMPLE_TIPS(@"tapped");
}

- (void)setLikeItemsArray:(NSMutableArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage sc_imageNamed:KSCImageMomentsCellLiekHeaderFooterAttach];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < likeItemsArray.count; i++) {
        SCMomentsCellLikeItemModel *model = likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        [attributedText appendAttributedString:[self generateAttributedStringWithLikeItemModel:model]];
        ;
    }
    
    _label.attributedText = [attributedText copy];
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(SCMomentsCellLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [SCColor getColor:SC_COLOR_NAV_BG];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
}
@end
