
#import <UIKit/UIKit.h>

@interface SCMomentsCellLikeHeaderFooterView : UITableViewHeaderFooterView

+ (instancetype)cellWithTable:(UITableView *)tableView;

@property (nonatomic, strong) NSMutableArray *likeItemsArray;

@end
