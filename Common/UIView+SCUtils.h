
typedef NS_ENUM(NSUInteger, SCAlignment) {
    SCAlignmentLeft = 1,
    SCAlignmentHCenter = 1 << 1,
    SCAlignmentRight = 1 << 2,
    
    SCAlignmentTop = 1 << 4,
    SCAlignmentVCenter = 1 << 5,
    SCAlignmentBottom = 1 << 6,
};

@interface UIView (SCUtils)

// Toast
- (void) makeShortToastAtCenter: (NSString*)toast;
- (void) makeLongToastAtCenter: (NSString*)toast;
- (void) makeToastActivityAndLockSelf;

// 菊花
- (void) setSpinnerVisible: (BOOL)visible;
- (BOOL) isSpinnerVisible;
@property(nonatomic, readonly) UIActivityIndicatorView* spinner;

// 对齐到父view，alignment可以是SCAlignment的组合，比如 SCAlignmentRight | SCAlignmentBottom
- (void) sc_alignToSuperView:(int)alignment;
@end

@interface UIView(Image)
// 把UIView的UI以Image形式返回
- (UIImage*)image;

@end
