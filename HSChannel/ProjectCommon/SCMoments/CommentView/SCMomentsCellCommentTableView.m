
#import "SCMomentsCellCommentTableView.h"
#import "SCMomentsViewModel.h"
#import "SCMomentsCellCommentViewCell.h"
#import "SCMomentsCellLikeViewCell.h"
#import "MLLinkLabel.h"
#import "SCMomentCategory.h"

@interface SCMomentsCellCommentTableView()<UITableViewDelegate,UITableViewDataSource,SCMomentsCellCommentViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *likeItemsArray;
@property (nonatomic, strong) NSMutableArray *commentItemsArray;

@property (nonatomic, strong) NSMutableArray *commentArray;
@end

@implementation SCMomentsCellCommentTableView

static NSString * const CellIdentifier = @"SCMomentsCellCommentViewCell";
static NSString * const HeaderFooterViewIdentifier = @"SCMomentsSectionHeaderView";

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray new];
    }
    return _commentArray;
}

- (void)setViewModel:(SCMomentsViewModel *)viewModel
{
    _viewModel = viewModel;
    
    self.likeItemsArray = (NSMutableArray *)viewModel.likeItemsArray;
    self.commentItemsArray = (NSMutableArray *)viewModel.commentItemsArray;
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.userInteractionEnabled = YES;
    
    [self registerClass:[SCMomentsCellCommentViewCell class] forCellReuseIdentifier:CellIdentifier];

    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = NO;
    self.estimatedRowHeight = 60;
    self.rowHeight = UITableViewAutomaticDimension;

//    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [SCColor getColor:@"f3f3f3"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMomentsCellCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.status = self.commentItemsArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.likeItemsArray.count == 0){
        return nil;
    }
    
    SCMomentsCellLikeHeaderFooterView *header = [SCMomentsCellLikeHeaderFooterView cellWithTable:tableView];
    header.likeItemsArray = self.likeItemsArray;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.likeItemsArray.count == 0)return 0;
    
    return [UILabel scm_heightForExpressionText:self.viewModel.likesStr width:[UIScreen mainScreen].bounds.size.width - 70];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.commentDelegate && [self.commentDelegate respondsToSelector:@selector(didTapedComment:)]) {
        [self.commentDelegate didTapedComment:self.commentItemsArray[indexPath.row]];
    }
}

#pragma mark - SCMomentsCellCommentViewCellDelegate
- (void)didTapedCell:(SCMomentsCellCommentItemModel *)cellModel{
    if (self.commentDelegate && [self.commentDelegate respondsToSelector:@selector(didTapedComment:)]) {
        [self.commentDelegate didTapedComment:cellModel];
    }
}

- (void)didClickLink:(NSString *)linkText cellModel:(SCMomentsCellCommentItemModel *)cellModel{
    
    if (self.commentDelegate && [self.commentDelegate respondsToSelector:@selector(didClickCommentText:commentModel:)]) {
        [self.commentDelegate didClickCommentText:linkText commentModel:cellModel];
    }
    
}

- (void)didLongPressLink:(NSString *)linkText cellModel:(SCMomentsCellCommentItemModel *)cellModel{
    
    if (self.commentDelegate && [self.commentDelegate respondsToSelector:@selector(didLongPressCommentText:commentModel:)]) {
        [self.commentDelegate didLongPressCommentText:linkText commentModel:cellModel];
    }
    
}

@end
