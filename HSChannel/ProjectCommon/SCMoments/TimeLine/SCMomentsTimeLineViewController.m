
#import "SCMomentsTimeLineViewController.h"

@interface SCMomentsTimeLineViewController ()

@end

@implementation SCMomentsTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

static NSString * const CellIdentifier = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"帶頭二哥 QQ:648959 - %zd", indexPath.row];
    return cell;
    
}
@end
