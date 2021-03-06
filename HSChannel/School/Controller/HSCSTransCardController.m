//
//  HSCSTransCardController.m
//  HSChannel
//
//  Created by SC on 16/8/30.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSTransCardController.h"

#define HSCSTransCardControllerTextFieldTag 1000001

@interface HSCSTransCardController ()<HSCSTransCardCellDelegate>

@property (nonatomic, strong) UITextField *cardNoTextField;
@property (nonatomic, strong) UITextField *childNameTextField;
@property (nonatomic, assign) NSInteger    selectedIndex;
@property (nonatomic, strong) NSMutableArray *unbindStudents;

@end

@implementation HSCSTransCardController

- (void)viewDidLoad{
    
    self.url = HSC_URL_SCHOOL_TRANSCARD_LIST;
    
    self.listPath = @"data";
    
    self.cellClass = [HSCSTransCardCell class];
    
    self.cellDataClass = [HSCSTransCardModel class];
    
    self.cellHeight = 45;
    
    self.separatorLineMarginLeft = SC_MARGIN_LEFT;
    
    self.unbindStudents = [NSMutableArray new];
    
    [super viewDidLoad];
    
    self.tableView.mj_header = nil;
    
    self.title = @"绑定接送卡";
    
    [self headerRereshing];
    
}

- (void)setupSubviews{
    
    [super setupSubviews];
    
    [self setupTableHeaderView];
    
}

- (void)setupTableHeaderView{
    
    DEFINE_WEAK(self);
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 136)];
    headView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    __weak UIView *tempView = headView;
    
    UIView *sectionHeaderView = [self createSectionHeaderView:@"请输入卡号"];
    [tempView addSubview:sectionHeaderView];
    [sectionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
    UIView *cardView = [self createInputView:@"卡号" placeholder:@"请输入要绑定的卡号"];
    [tempView addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectionHeaderView.mas_bottom);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
    _cardNoTextField = [cardView viewWithTag:HSCSTransCardControllerTextFieldTag];
    
    UIView *seperatorLine = [UIView new];
    seperatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [tempView addSubview:seperatorLine];
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cardView.mas_bottom);
        make.left.mas_equalTo(tempView).offset(SC_MARGIN_LEFT);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *childNameView = [self createInputView:@"姓名" placeholder:@"选择学生姓名"];
    [tempView addSubview:childNameView];
    [childNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(seperatorLine.mas_bottom);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
    _childNameTextField = [childNameView viewWithTag:HSCSTransCardControllerTextFieldTag];
    
    _childNameTextField.userInteractionEnabled = NO;
    
    _childNameTextField.enabled = NO;
    
    childNameView.userInteractionEnabled = YES;
    
    [childNameView bk_whenTapped:^{
        
        NSMutableArray *names = [NSMutableArray new];
        
        for (HSCSTransCardModel *model in self.unbindStudents) {
            [names addObject:model.stuName];
        }
        
        [SCSpinner showSpinnerWithType:SCSpinnerBorderFixedWidthWithTriangle rows:names initialSelection:-1 origin:childNameView doneBlock:^(int selectedIndex, id selectedValue) {
            self.childNameTextField.text = selectedValue;
            self.selectedIndex = selectedIndex;
        } cancel:nil];
    }];
    
//    UIImageView *rightImageView = [UIImageView new];
//    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
//    rightImageView.image = [UIImage sc_imageNamed:KSCImageSTransCardControllerSelectDown];
//    rightImageView.userInteractionEnabled = YES;
//    [childNameView addSubview:rightImageView];
//    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(childNameView);
//        make.right.mas_equalTo(childNameView).offset(SC_MARGIN_RIGHT);
//        make.height.mas_equalTo(15);
//        make.width.mas_equalTo(15);
//        
//    }];
    
    void( ^ itemCallback )(NSUInteger index, id info)  = ^(NSUInteger index, id info){
        
        switch (index) {
            case 0:{
                NSMutableDictionary *params = [NSMutableDictionary new];
                HSCSTransCardModel *model = wself.unbindStudents[wself.selectedIndex];
                        params[@"stuId"] = @(model.stuId);
                params[@"stuCode"] = wself.cardNoTextField.text;
                
                [SCHttpTool postWithURL:HSC_URL_SCHOOL_TRANSCARD_ADD params:params success:^(NSDictionary *json) {
                    
                    [wself.navigationController popViewControllerAnimated:YES];
                    
                } failure:nil];

            }
                break;
            default:
                
                break;
        }
    };
    
    DTKDropdownItem *right1Item1 = [DTKDropdownItem itemWithTitle:@"绑定" callBack:itemCallback];
    
    NSArray *right1Items = @[right1Item1];
    
    DTKDropdownMenuView *dropdown = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeSelfRight frame:CGRectMake(0, 0, 60, 45) dropdownItems:right1Items icon:KSCImageSTransCardControllerSelectDown];
    dropdown.textFont = [Utils fontWithSize:15];
    dropdown.textColor = [SCColor getColor:SC_COLOR_BUTTON_TITLE];
    dropdown.cellColor = [SCColor getColor:SC_COLOR_BUTTON_NORMAL];
    dropdown.cellSeparatorColor = [SCColor getColor:SC_COLOR_BUTTON_NORMAL];
    dropdown.cellHeight = 32;
    dropdown.dropWidth = 80;
    dropdown.topArrowOffset = 10;
    dropdown.textAlignment = NSTextAlignmentCenter;
    dropdown.cellSeparatorEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [tempView addSubview:dropdown];
    [dropdown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(childNameView);
        make.right.mas_equalTo(tempView).offset(SC_MARGIN_RIGHT-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(45);
    }];
    dropdown.userInteractionEnabled = YES;
    
    
    [childNameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(dropdown.mas_left);
    }];
    
    self.tableView.tableHeaderView = headView;
    
}

- (UIView *)createInputView:(NSString *)title placeholder:(NSString *)placeholder{
    
    UIView *headView = [UIView new];
    
    headView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [Utils fontWithSize:SC_FONT_3];
    titleLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = title;
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView);
        make.left.mas_equalTo(headView).offset(SC_MARGIN_LEFT);
        make.width.mas_lessThanOrEqualTo(30);
        make.bottom.mas_equalTo(headView);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.tag = HSCSTransCardControllerTextFieldTag;
    textField.font = [Utils fontWithSize:SC_FONT_3];
    textField.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    textField.placeholder = placeholder;
    [headView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView);
        make.left.mas_equalTo(titleLabel.mas_right).offset(5);
        make.right.mas_equalTo(headView.mas_right).offset(SC_MARGIN_RIGHT);
        make.bottom.mas_equalTo(headView);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        [textField resignFirstResponder];
    }];
    textField.inputAccessoryView = inputAccessoryView;
    
    return headView;
}

- (UIView *)createSectionHeaderView:(NSString *)title{
    
    UIView *headView = [UIView new];
    
    headView.backgroundColor = [SCColor getColor:@"f4f4f4"];
    
    UIImageView *readImageView = [UIImageView new];
    readImageView.contentMode = UIViewContentModeScaleAspectFit;
    readImageView.image = [UIImage sc_imageNamed:KSCImageSTransCardControllerIconTitle];
    [headView addSubview:readImageView];
    [readImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.left.mas_equalTo(headView).offset(6);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [Utils fontWithSize:SC_FONT_3];
    titleLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    titleLabel.text = title;
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.left.mas_equalTo(readImageView.mas_right).offset(5);
        make.right.mas_equalTo(headView.mas_right).offset(SC_MARGIN_RIGHT);
        make.height.mas_equalTo(20);
    }];
    
    return headView;
}

- (void)customizeParams:(NSMutableDictionary *)params newer:(BOOL)newer{
    
    params[@"page"] = @(self.pageNo);
    
}

- (void)dataReceidSuccessful:(NSDictionary *)dic newer:(BOOL)newer{
    if (newer) {
        [self.dataArray removeAllObjects];
        [self.unbindStudents removeAllObjects];
        self.pageNo = 1;
    }
    
    NSArray * array = [dic valueForKeyPath: @"codeData"];
    NSArray * unbindArray = [dic valueForKeyPath: @"noCodeData"];
    if ([Utils isNilOrNSNull:array] || array.count == 0) {
        [[Utils getDefaultWindow] makeShortToastAtCenter:@"没有更多了"];
        [self endRefreshing: newer];
        return;
    }
    
    self.pageNo += 1;
    for (NSDictionary * item in array) {
        HSCSTransCardModel* data = [[self.cellDataClass alloc] init];
        if ([item isKindOfClass:[NSDictionary class]]){
            [data updateWithDictionary:item];
            [self.dataArray addObject:data];
        }
    }
    
    for (NSDictionary * item in unbindArray) {
        HSCSTransCardModel* data = [[self.cellDataClass alloc] init];
        if ([item isKindOfClass:[NSDictionary class]]){
            [data updateWithDictionary:item];
            [self.unbindStudents addObject:data];
        }
    }
    [self.tableView reloadData];
    [self endRefreshing: newer];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count > 0 ? 1 : 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [self createSectionHeaderView:@"已绑定卡"];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSCSTransCardCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.delegate = self;
    
    return cell;
    
}

#pragma mark - HSCSTransCardCellDelegate

-(void)deleteCellByIndexPath:(NSIndexPath *)indexPath{
    
    HSCSTransCardModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"stuId"] = @(model.stuId);
    
    [SCHttpTool postWithURL:HSC_URL_SCHOOL_TRANSCARD_DEL params:params success:nil failure:nil];
    
}

@end
