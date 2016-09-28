//
//  MessageViewController.h
//  ShiHua
//
//  Created by 赵坪生 on 9/9/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 对TableView的简单包装，支持上拉下拉刷新
#ifdef SC_TP_UITABLEVIEW_NXEMPTYVIEW
@interface SCTableViewController : SCBaseViewController<UITableViewDataSource, UITableViewDelegate, UITableViewNXEmptyViewDataSource>
#else

@interface SCTableViewController : SCBaseViewController<UITableViewDataSource, UITableViewDelegate>
#endif
@property (nonatomic) BOOL dataRequestedOnce;
// 初始化时必需设置的属性
// 加载数据时请求的url
@property(nonatomic, strong) NSString* url;
// 网络返回的json数据中，list所在的path, 比如 @"data", @"data/name1/name2"
@property(nonatomic, strong) NSString* listPath;
// 当前页码
@property(atomic,          ) NSInteger pageNo;
// tableView每一行对应的Model class， 必须是SCTableViewCellData的子类
@property(nonatomic, strong) Class cellDataClass;

@property(nonatomic, strong) NSString* lastIdKey;

// 每一个cell的高度，也可以不设置，那样你需要override
// - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
@property(nonatomic) int cellHeight;

@property(nonatomic) CGRect   customFrame;

// 你必须设置以下两个中的一个：
// 如果你用xib定义每一个cell，请提供xib名字（不包含.xib后缀）
@property(nonatomic, strong) NSString* cellNibName;
// 否则，提供一个SCTableViewCell的子类
@property(nonatomic, strong) Class cellClass;

@property BOOL dontAutoLoad;

@property(atomic, assign) CGFloat separatorLineMarginLeft;

@property(atomic, assign) CGFloat separatorLineMarginRight;

// 可选的属性
// 请求数据时需要额外添加的参数(lastId不需要，这个类会自动加上）
@property(nonatomic, strong) NSMutableDictionary* requestParams;

@property BOOL disableHeaderRefresh;

@property BOOL disableFooterRefresh;

@property(nonatomic, strong) NSMutableArray* dataArray;

@property(nonatomic, strong) UITableView* tableView;

- (void) headerRereshing;

- (void) endRefreshing: (BOOL) newer;

- (void) customizeTableView;

- (void) customizeParams: (NSMutableDictionary*)params newer:(BOOL)newer;

- (void)dataReceidSuccessful:(NSDictionary *)dic newer:(BOOL)newer;
@end

// 对TableView的简单包装，支持上拉下拉刷新
#ifdef SC_TP_UITABLEVIEW_NXEMPTYVIEW
@interface SCGroupTableViewController : SCBaseViewController<UITableViewDataSource, UITableViewDelegate, UITableViewNXEmptyViewDataSource>
#else
@interface SCGroupTableViewController : SCBaseViewController<UITableViewDataSource, UITableViewDelegate>
#endif
// 初始化时必需设置的属性
// 加载数据时请求的url
@property(nonatomic, strong) NSString* url;
// 网络返回的json数据中，list所在的path, 比如 @"data", @"data/name1/name2"
@property(nonatomic, strong) NSString* listPath;
// 当前页码
@property(atomic,          ) NSInteger pageNo;
// tableView每一行对应的Model class， 必须是SCTableViewCellData的子类
@property(nonatomic, strong) NSMutableArray<Class>* cellDataClassArray;

@property(nonatomic, strong) NSString* lastIdKey;

// 每一个cell的高度，也可以不设置，那样你需要override
// - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
@property(nonatomic,strong) NSMutableArray* cellHeightArray;
@property(nonatomic,strong) NSMutableArray* headerHeightArray;
@property(nonatomic,strong) NSMutableArray* footerHeightArray;
@property(nonatomic,      ) CGRect   customFrame;

// 你必须设置以下两个中的一个：
// 如果你用xib定义每一个cell，请提供xib名字（不包含.xib后缀）
@property(nonatomic, strong) NSMutableArray<NSString*>* cellNibNameArray;
// 否则，提供一个SCTableViewCell的子类
@property(nonatomic, strong) NSMutableArray<Class>* cellClassArray;
@property(nonatomic, strong) NSMutableArray<Class>* headerClassArray;
@property(nonatomic, strong) NSMutableArray<Class>* footerClassArray;
@property(nonatomic, strong) NSMutableArray<NSString*>* headerTitleArray;
@property(nonatomic, strong) NSMutableArray<NSString*>* footerTitleArray;

@property BOOL dontAutoLoad;

@property(atomic, assign) CGFloat separatorLineMarginLeft;

@property(atomic, assign) CGFloat separatorLineMarginRight;

// 可选的属性
// 请求数据时需要额外添加的参数(lastId不需要，这个类会自动加上）
@property(nonatomic, strong) NSMutableDictionary* requestParams;

@property BOOL disableHeaderRefresh;

@property BOOL disableFooterRefresh;

@property(nonatomic, strong) NSMutableArray<NSMutableArray*>* dataArray;

@property(nonatomic, strong) UITableView* tableView;

- (void) headerRereshing;

- (void) endRefreshing: (BOOL) newer;

- (void) customizeTableView;

- (void) customizeParams: (NSMutableDictionary*)params newer:(BOOL)newer;

- (void)dataReceidSuccessful:(NSDictionary *)dic newer:(BOOL)newer;
@end

@interface SCTableViewCellData: NSObject{
#ifdef SC_TP_KEYVALUE_MAPPING
    DCKeyValueObjectMapping* _dicParser;
#endif
}
// 每个子类必须的字段，如果没有，请override如下方法
// - (NSString*) id;
//@property(nonatomic, strong, readonly) NSString* id;
// 根据一个Dictionary跟新数据， 默认实现是调用 DCKeyValueObjectMapping 解析数据， 子类可以覆盖
- (void) updateWithDictionary: (NSDictionary*)dic;
// 依赖于updateWithDictionary，子类实现自定义DCKeyValueObjectMapping 解析
- (void)additionParserConfig:(DCParserConfiguration*)config;
// 根据一个Dictionary创建数据对象
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface SCTableViewCell : UITableViewCell
// 一般来说，子类应该覆盖如下类来更新UI
// - (void)setData:(SCTableViewCellData *)data
@property(nonatomic, strong) SCTableViewCellData* data;

@end

@interface SCTableViewHeaderFooterView : UITableViewHeaderFooterView

@end
