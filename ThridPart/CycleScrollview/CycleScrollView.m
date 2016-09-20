//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    _currentPageIndex = 0;
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
        _isCanCycle = YES;
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = contentView.associatedObject;
        if (!tapGesture) {
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            [contentView addGestureRecognizer:tapGesture];
            contentView.associatedObject = tapGesture;
        }
        
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    if (self.isCanCycle == YES) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }else {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        if (self.isCanCycle == YES) {
            [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex, NO)];
            [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex, YES)];
            [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex, NO)];
        }else {
            for (int index = 0; index < self.totalPageCount; index++) {
                [self.contentViews addObject:self.fetchContentViewAtIndex(index, YES)];
            }
        }
    }
}

- (NSInteger)getValidPageIndex:(NSInteger)pageIndex;
{
    int n = self.totalPageCount;
    return n > 0 ? (pageIndex + n) % n : 0;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isCanCycle == YES) {
        [self.animationTimer pauseTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isCanCycle == YES) {
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isCanCycle == YES) {
        int contentOffsetX = scrollView.contentOffset.x;
        if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
            self.currentPageIndex = [self getValidPageIndex:self.currentPageIndex + 1];
            //NSLog(@"next，当前页:%d",self.currentPageIndex);
            [self configContentViews];
        }
        if(contentOffsetX <= 0) {
            self.currentPageIndex = [self getValidPageIndex:self.currentPageIndex - 1];
            //NSLog(@"previous，当前页:%d",self.currentPageIndex);
            [self configContentViews];
        }
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.isCanCycle == YES) {
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
    }else {
        CGFloat relativeOffsetX = scrollView.contentOffset.x - CGRectGetWidth(scrollView.frame)*self.currentPageIndex;
        NSInteger nextPageIndex = self.currentPageIndex;
        nextPageIndex += relativeOffsetX > 50 ? 1 : 0;
        nextPageIndex += relativeOffsetX < -50 ? -1 : 0;
        if (nextPageIndex != self.currentPageIndex) {
            [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame)*nextPageIndex, 0) animated:YES];
            self.currentPageIndex = nextPageIndex;
        }
    }
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

#pragma mark - Getters And Setters

- (void)setIsCanCycle:(BOOL)isCanCycle{
    _isCanCycle = isCanCycle;
    if (isCanCycle == NO) {
        [self.animationTimer pauseTimer];
    }else {
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (void) didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}

- (void) dealloc {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
