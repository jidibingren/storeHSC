
#import <UIKit/UIKit.h>

@interface SCOperationMenu : UIView

@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, strong)UIView   *centerLine;
@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UIButton *commentButton;
@property (nonatomic, strong)SCMomentsViewModel *viewModel;

@property (nonatomic, copy) void (^likeButtonClickedOperation)();
@property (nonatomic, copy) void (^commentButtonClickedOperation)();

- (void)setupUI;

-(void)likeButtonClicked;

-(void)commentButtonClicked;

@end
