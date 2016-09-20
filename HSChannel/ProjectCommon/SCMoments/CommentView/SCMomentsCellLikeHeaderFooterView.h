
#import <UIKit/UIKit.h>

@interface SCMomentsCellLikeViewCell : UITableViewHeaderFooterView

+ (instancetype)cellWithTable:(UITableView *)tableView;

@property (nonatomic, strong) NSMutableArray *likeItemsArray;

@end
