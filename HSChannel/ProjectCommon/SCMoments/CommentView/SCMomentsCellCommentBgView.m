
#import "SCMomentsCellCommentBgView.h"
#import "SCMomentsCellCommentTableView.h"
#import "SCMomentsViewModel.h"
#import "MLLinkLabel.h"

@implementation SCMomentsCellCommentBgView
{
    SCMomentsCellCommentTableView *_tableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.image = [UIImage sc_imageNamed:KSCImageMomentsCellCommentBg];
        
        _tableView = [[SCMomentsCellCommentTableView alloc] init];
        
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.mas_top).offset(5);
        }];
    }
    return self;
}

- (void)setViewModel:(SCMomentsViewModel *)viewModel
{
    _viewModel = viewModel;
    
    _tableView.commentDelegate = self.commentDelegate;
    
    _tableView.viewModel = viewModel;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self calcViewSize]);
    }];
}

- (CGSize)calcViewSize {
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 70;
    CGFloat h = [self getCommentViewHeight:self.viewModel];
    
    return CGSizeMake(w, h + 5);
}

- (CGFloat)getCommentViewHeight:(SCMomentsViewModel *)viewModel
{
    CGFloat tableViewHeight = 0;
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    
    if (viewModel.likeItemsArray.count) {
        
        CGFloat h = [UILabel scm_heightForExpressionText:viewModel.likesStr width:contentW];
        
        tableViewHeight = h + 2;
    }
    
    
    if (viewModel.commentItemsArray.count) {
        for (int i = 0; i < viewModel.commentItemsArray.count; i++) {
            SCMomentsCellCommentItemModel *model = viewModel.commentItemsArray[i];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:[self generateAttributedStringWithCommentItemModel:model]];
            
            
            MLLinkLabel *label = [MLLinkLabel new];
            label.attributedText = text;
            label.numberOfLines = 0;
            label.lineHeightMultiple = 1.1f;
            label.font = [UIFont systemFontOfSize:14];
            UIColor *highLightColor = [UIColor blueColor];
            label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
            label.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
            CGFloat h = [label preferredSizeWithMaxWidth:contentW].height;
            label = nil;
            
//            CGFloat h = [UILabel scm_heightForExpressionText:text width:contentW];
            
            tableViewHeight += h;
        }
    }
    
    return tableViewHeight;
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(SCMomentsCellCommentItemModel *)model
{
    NSString *text = model.firstUserName;
    if (model.secondUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondUserName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.commentString]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.firstUserId} range:[text rangeOfString:model.firstUserName]];
    if (model.secondUserName) {
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
    }
    return attString;
}

@end
