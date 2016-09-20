
typedef NS_ENUM(NSInteger, SCSpinnerBackgroundType) {
    SCSpinnerBackgroundFullScreen = 0,
    SCSpinnerBackgroundAuto
};

typedef NS_ENUM(NSInteger, SCSpinnerWidthType) {
    SCSpinnerWidthAuto = 0,
    SCSpinnerWidthFixed
};

typedef NS_ENUM(NSInteger, SCSpinnerType) {
    SCSpinnerBorderAutoWidth = 0,
    SCSpinnerShadowAutoWidth,
    SCSpinnerBorderAndShadowAutoWidth,
    SCSpinnerBorderFixedWidth = (1 << 4 | SCSpinnerBorderAutoWidth),
    SCSpinnerShadowFixedWidth,
    SCSpinnerBorderAndShadowFixedWidth,
    
    SCSpinnerBorderAutoWidthWithTriangle = (1 << 8 | SCSpinnerBorderAutoWidth),
    SCSpinnerShadowAutoWidthWithTriangle,
    SCSpinnerBorderAndShadowAutoWidthWithTriangle,
    SCSpinnerBorderFixedWidthWithTriangle = (1 << 8 | 1 << 4 | SCSpinnerBorderAutoWidth),
    SCSpinnerShadowFixedWidthWithTriangle,
    SCSpinnerBorderAndShadowFixedWidthWithTriangle
};

typedef void(^SCSpinnerDoneBlock)(int selectedIndex, id selectedValue);
typedef void(^SCSpinnerCancelBlock)(void);

//@interface UITableView(SCSpinner)<UITableViewDataSource,UITableViewDelegate>
@interface SCSpinner:UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)BOOL    hasTriangle;
@property (nonatomic)CGFloat triangleWidth;
@property (nonatomic)CGFloat triangleHeight;
// 该值为三角形角标在水平方向上的偏移系数 >0 && < 1
@property (nonatomic)CGFloat triangleOffsetCoefficient;
@property (nonatomic)CGFloat spinnerCellHeight;
@property (nonatomic)CGFloat spinnerCellShadowOpacity;
@property (nonatomic)CGFloat spinnerCellShadowRadius;
@property (nonatomic)CGSize  spinnerCellShadowOffset;
@property (nonatomic, strong)UIColor *spinnerCellShadowColor;
@property (nonatomic, strong)UIColor *spinnerCellSelectedColor;
@property (nonatomic, strong)UIColor *spinnerCellBackgroundColor;
@property (nonatomic, strong)UIColor *backgroundTouchViewColor;
@property (nonatomic)SCSpinnerWidthType      spinnerWidthType;
@property (nonatomic)SCSpinnerBackgroundType backgroundTouchViewType;

/**
 *	@description	展示下拉列表类方法
 *
 *	@param  type         下拉列表的类型
 *	@param 	strings 	 数组的每项为NSString类型, 表示cell的内容
 *	@param 	index 	     初始化时选中项的索引, <0的值表示无初始化选中项
 *	@param 	origin 	     任意类型的界面元素
 *	@param 	doneBlock 	 选中某项后的回调
 *	@param 	cancelBlock  关闭spinner后的回调
 *
 *	@return	none
 */
+ (void)showSpinnerWithType:(SCSpinnerType)type rows:(NSArray *)strings initialSelection:(NSInteger)index origin:(id)origin doneBlock:(SCSpinnerDoneBlock)doneBlock cancel:(SCSpinnerCancelBlock)cancelBlock
;

+ (void)showSpinnerWithType:(SCSpinnerType)type rows:(NSArray *)strings initialSelection:(NSInteger)index absoluteFrame:(CGRect)absoluteFrame doneBlock:(SCSpinnerDoneBlock)doneBlock cancel:(SCSpinnerCancelBlock)cancelBlock;

/* 下列函数为创建自定义的下拉列表的便捷方法,创建完成后还可对边框、阴影、cell（高度、分割线的颜色、选中时的颜色、阴影）等等进行自定义, 最后必须调用一下方法进行展示:
    - (void)showWithRows:(NSArray *)strings initialSelection:(NSInteger)index origin:(id)origin done:(UITableViewDoneBlock)doneBlock cancel:(UITableViewCancelBlock)cancelBlock
 */
// 自定义下拉列表
+ (SCSpinner *)spinner;

// 带边框的便捷方法
+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width;
+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color;
+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color conerRadius:(CGFloat)radius;
+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color conerRadius:(CGFloat)radius  opacity:(CGFloat)opacity;
+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color conerRadius:(CGFloat)radius  opacity:(CGFloat)opacity backgroundTouchViewColor:(UIColor *)backgroundTouchViewColor;

// 带阴影的便捷方法
+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius;
+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius shadowColor:(UIColor *)color;
+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius shadowColor:(UIColor *)color shadowOpacity:(CGFloat)opacity;
+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius shadowColor:(UIColor *)color shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset;
+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius shadowColor:(UIColor *)color shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset backgroundTouchViewColor:(UIColor *)backgroundTouchViewColor;
/**
 *	@description       spinner的展示方法
 *
 *	@param 	strings 	 数组的每项为NSString类型, 表示cell的内容
 *	@param 	index 	     初始化时选中项的索引, <0的值表示无初始化选中项
 *	@param 	origin 	     任意类型的界面元素
 *	@param 	doneBlock 	 选中某项后的回调
 *	@param 	cancelBlock  关闭spinner后的回调
 *
 *	@return	none
 */
- (void)showWithRows:(NSArray *)strings initialSelection:(NSInteger)index origin:(id)origin done:(SCSpinnerDoneBlock)doneBlock cancel:(SCSpinnerCancelBlock)cancelBlock;
@end
