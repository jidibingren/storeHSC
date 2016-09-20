
#import "SCMomentsCell.h"
#import "SCMomentsViewModel.h"
//#import "SCMomentsOriginalView.h"

#import "SCMomentsCellCommentBgView.h"
#import "SCOperationMenu.h"

@interface SCMomentsCell()<SCMomentsOriginalViewDelegate,SCMomentsCellCommentTableViewDelegate>

@end

@implementation SCMomentsCell
{
    // 时间
    UILabel *_timeLabel;
    
    // 回复
    UIButton *_operationButton;
    
    // 分割线
    UIImageView *_divider;
    
    // 回复的tableView的高度
    MASConstraint *_commentViewHeightConstraint;
    
    /// 底部视图顶部约束
    MASConstraint *_dividerTopConstraint;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.originalViewClass = [SCMomentsOriginalView class];
        self.commentBgViewClass = [SCMomentsCellCommentBgView class];
        self.operationMenuClass = [SCOperationMenu class];
        self.dividerHeight = 10;
        self.dividerColor = [UIColor lightGrayColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 原创微博
    _originalView = [[_originalViewClass alloc] init];
    _originalView.delegate = self;
    
//    _timeLabel =  [UILabel scm_labelWithTitle:@"" color:[UIColor lightGrayColor] fontSize:13 alignment:NSTextAlignmentRight];
    
//    _operationButton = [UIButton new];
//    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
//    [_operationButton addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _operationMenu = [[_operationMenuClass alloc] init];
    __weak typeof(self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
    [_operationMenu setCommentButtonClickedOperation:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf];
        }
    }];
    
    // 回复
    _commentBgView = [[_commentBgViewClass alloc] init];
    _commentBgView.commentDelegate = self;
    // 分割线
    _divider = [[UIImageView alloc] init];
    _divider.alpha = 0.3f;
    _divider.backgroundColor = _dividerColor;

    [self.contentView addSubview:_originalView];
//    [self.contentView addSubview:_timeLabel];
//    [self.contentView addSubview:_operationButton];
    [self.contentView addSubview:_divider];
    [self.contentView addSubview:_commentBgView];
    [self.contentView addSubview:_operationMenu];
    
    // 设置约束
    CGFloat margin = 10;
    // 原创微博
    [_originalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
//    // 点赞+回复按钮
//    [_operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_originalView.mas_bottom).with.offset(0);
//        make.right.equalTo(self.contentView.mas_right).offset(-margin);
//        make.size.mas_equalTo(CGSizeMake(25, 25));
//    }];
//    
//    // 时间
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(2 * margin + 40);
//        make.centerY.equalTo(_operationButton);
//    }];
    
    // 回复的tableView
    [_commentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operationMenu.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(60);
        make.right.equalTo(self.contentView.mas_right).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];

    // 分割线
    [_divider mas_makeConstraints:^(MASConstraintMaker *make) {
        _dividerTopConstraint = make.top.equalTo(_commentBgView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(weakSelf.dividerHeight);
    }];
    
    // 展开点赞+回复按钮
    [_operationMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(_originalView.mas_bottom).with.offset(0);
        make.height.equalTo(@36);
//        make.width.equalTo(@0);
        //        make.width.equalTo(@180);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_divider);
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
    }];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)setViewModel:(SCMomentsViewModel *)viewModel
{
    _viewModel = viewModel;
    _originalView.viewModel = viewModel;
    _originalView.indexPath = self.indexPath;
    _operationMenu.viewModel = viewModel;
//    _timeLabel.text = viewModel.time;

    CGFloat margin = 10;
    
    [_dividerTopConstraint uninstall];
    if (!viewModel.isCommentOpening || (!viewModel.commentItemsArray.count && !viewModel.likeItemsArray.count)) {
        _commentBgView.hidden = YES;
        [_divider mas_updateConstraints:^(MASConstraintMaker *make) {
            _dividerTopConstraint = make.top.equalTo(_operationMenu.mas_bottom);
        }];
    }else {
        _commentBgView.hidden = NO;
        _commentBgView.viewModel = viewModel;
        [_divider mas_updateConstraints:^(MASConstraintMaker *make) {
            _dividerTopConstraint = make.top.equalTo(_commentBgView.mas_bottom).offset(margin);
        }];
    }
}

- (void)operationButtonClicked:(UIButton *)btn
{
    _operationMenu.show = !_operationMenu.isShowing;

    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
//    UITouch *touch = [touches anyObject];
//    UIButton *btn = (UIButton *)[touch view];
//    [self operationButtonClicked:btn];
//    
//    if (_operationMenu.isShowing) {
//        _operationMenu.show = NO;
//    }
//}

#pragma mark - SCMomentsOriginalViewDelegate

- (void)didClickOpenAllButton:(SCMomentsOriginalView *)originView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOpenAllButtonInCell:)]) {
        [self.delegate didClickOpenAllButtonInCell:self];
    }
    
}

- (void)didClickDeleteButton:(SCMomentsOriginalView *)originView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDeleteButtonInCell:)]) {
        [self.delegate didClickDeleteButtonInCell:self];
    }
    
}

#pragma mark - SCMomentsCellCommentTableViewDelegate

- (void)didTapedComment:(SCMomentsCellCommentItemModel *)commentModel{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapedComment:inCell:)]) {
        [self.delegate didTapedComment:commentModel inCell:self];
    }
}

- (void)didClickCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCommentText:commentModel:inCell:)]) {
        [self.delegate didClickCommentText:commentText commentModel:commentModel inCell:self];
    }
}

- (void)didLongPressCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressCommentText:commentModel:inCell:)]) {
        [self.delegate didLongPressCommentText:commentText commentModel:commentModel inCell:self];
    }
}

@end
