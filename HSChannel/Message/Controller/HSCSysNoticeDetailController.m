//
//  HSCSysNoticeDetailController.m
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSysNoticeDetailController.h"

@interface HSCSysNoticeDetailController ()

@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *rangeLabel;
@property (nonatomic, strong)UILabel     *titleLabel;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)UILabel     *readCountLabel;

@property (nonatomic, strong)HSCSysNoticeDetailModel     *detailModel;

@end

@implementation HSCSysNoticeDetailController

- (instancetype)initWithNoticeId:(HSCMessageModel *)messageModel{
    
    if (self = [super init]) {
        self.messageModel = messageModel;
    }
    
    return self;
    
}

- (void)viewDidLoad{
    
    self.dontAutoLoad = YES;
    
    self.cellClass = [HSCSNDRangeCell class];
    
    self.cellDataClass = [HSCSNDRange class];
    
    self.cellHeight = 45;
    
    self.separatorLineMarginLeft = 55;
    
    [super viewDidLoad];
    
    self.tableView.mj_header = nil;
    
    self.tableView.mj_footer = nil;
    
    self.title = @"系统通知详情";
    
}

- (void)setupSubviews{
    
    [super setupSubviews];
    
    [self setupTableHeaderView];
    
    [self requestDetailInfo];
    
}

- (void)setupTableHeaderView{
    
    CGSize size = [Utils sizeForString:_messageModel.content font:[Utils fontWithSize:SC_FONT_4] constrainedToSize:CGSizeMake(ScreenWidth-SC_MARGIN_LEFT*2, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180+size.height)];
    headView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    __weak UIView *tempView = headView;
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [Utils fontWithSize:SC_FONT_3];
    _nameLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(SC_MARGIN_LEFT);
        make.right.mas_equalTo(tempView).offset(SC_MARGIN_RIGHT);
        make.height.mas_equalTo(45);
    }];
    
    _rangeLabel = [UILabel new];
    _rangeLabel.textAlignment = NSTextAlignmentLeft;
    _rangeLabel.font = [Utils fontWithSize:SC_FONT_3];
    _rangeLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:_rangeLabel];
    [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom);
        make.right.mas_equalTo(_nameLabel);
        make.left.mas_equalTo(_nameLabel);
        make.height.mas_equalTo(45);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [Utils fontWithSize:SC_FONT_3];
    _titleLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rangeLabel.mas_bottom).offset(SC_MARGIN_TOP);
        make.right.mas_equalTo(_nameLabel);
        make.left.mas_equalTo(_nameLabel);
        make.height.mas_equalTo(35);
    }];

    
    _contentLabel = [UILabel new];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [Utils fontWithSize:SC_FONT_4];
    _contentLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
    _contentLabel.numberOfLines = 0;
    [tempView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(_titleLabel);
        make.height.mas_equalTo(size.height);
    }];

    UIView *readView = [UIView new];
    readView.backgroundColor = [SCColor getColor:@"f4f4f4"];
    [tempView addSubview:readView];
    [readView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView *readImageView = [UIImageView new];
    readImageView.contentMode = UIViewContentModeScaleAspectFit;
    readImageView.image = [UIImage imageNamed:@"icon_title"];
    [readView addSubview:readImageView];
    [readImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(readView);
        make.left.mas_equalTo(readView).offset(6);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *readLabel = [UILabel new];
    readLabel.textAlignment = NSTextAlignmentLeft;
    readLabel.font = [Utils fontWithSize:SC_FONT_3];
    readLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:readLabel];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(readView);
        make.left.mas_equalTo(readImageView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    _readCountLabel = [UILabel new];
    _readCountLabel.textAlignment = NSTextAlignmentLeft;
    _readCountLabel.font = [Utils fontWithSize:SC_FONT_4];
    _readCountLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
    [tempView addSubview:_readCountLabel];
    [_readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(readLabel);
        make.left.mas_equalTo(readLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UIView *separatorLine = [UIView new];
    separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [tempView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.bottom.mas_equalTo(_nameLabel);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *separatorLine2 = [UIView new];
    separatorLine2.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [tempView addSubview:separatorLine2];
    [separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.bottom.mas_equalTo(_rangeLabel);
        make.height.mas_equalTo(0.5);
    }];
    
    self.nameLabel.text = [NSString stringWithFormat:@"发布人: %@",_messageModel.fromUser];
    
    self.rangeLabel.text = [NSString stringWithFormat:@"通知范围: %@",_messageModel.range];
    
    self.titleLabel.text = [NSString stringWithFormat:@"标题: %@",_messageModel.title];
    
    self.contentLabel.text = _messageModel.content;
    
    readLabel.text = @"已读";
    
    self.tableView.tableHeaderView = headView;
    
}

- (void)requestDetailInfo{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"id"] = _messageModel.id;
    
    [SCHttpTool postWithURL:HSC_URL_NOTICE_DETAIL params:params success:^(NSDictionary *json) {
        
        if ([Utils isValidDictionary:json[@"info"]]) {
            
            self.detailModel = [[HSCSysNoticeDetailModel alloc]initWithDictionary:json[@"info"]];
            [self updateInfo];
        }
        
    } failure:nil withProgress:self.view];
    
}

- (void)updateInfo{
    
    self.dataArray = _detailModel.rangeAll;
    
    NSInteger readCount = 0;
    
    for (HSCSNDRange *range in _detailModel.rangeAll) {
        
        range.isRead == 0 ? : readCount++;
        
    }
    
    self.readCountLabel.text = [NSString stringWithFormat:@"(%ld/%ld)", readCount,self.dataArray.count];
    
    [self.tableView reloadData];
    
}

@end
