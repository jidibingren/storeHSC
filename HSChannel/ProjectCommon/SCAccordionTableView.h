//
//  SCAccordionTableView.h
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//


@interface SCAccordionTableViewHeaderView : FZAccordionTableViewHeaderView

- (void)setupSubviewsWithFrame:(CGRect)frame;

- (void)setData:(id)data;

@end

@interface SCAccordionTableView : FZAccordionTableView

@end

@protocol SCAccordionTableViewDelegate <FZAccordionTableViewDelegate>

@optional

/**
 @desc  Implement to respond to which sections can be interacted with.
 
 If NO is returned for a section, the section can neither be opened or closed.
 It stays in it's initial state no matter what.
 
 Use 'initialOpenSections' to mark a section open from the start.
 
 The default return value is YES.
 */
- (BOOL)tableView:(SCAccordionTableView * _Nonnull)tableView canInteractWithHeaderAtSection:(NSInteger)section;

- (void)tableView:(SCAccordionTableView * _Nonnull)tableView willOpenSection:(NSInteger)section withHeader:(SCAccordionTableViewHeaderView * _Nonnull)header;
- (void)tableView:(SCAccordionTableView * _Nonnull)tableView didOpenSection:(NSInteger)section withHeader:(SCAccordionTableViewHeaderView * _Nonnull)header;

- (void)tableView:(SCAccordionTableView * _Nonnull)tableView willCloseSection:(NSInteger)section withHeader:(SCAccordionTableViewHeaderView * _Nonnull)header;
- (void)tableView:(SCAccordionTableView * _Nonnull)tableView didCloseSection:(NSInteger)section withHeader:(SCAccordionTableViewHeaderView * _Nonnull)header;

@end