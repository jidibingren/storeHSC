
#import "SCSpinner.h"


@interface SCSpinnerBorderView : UIView
@property (nonatomic)CGFloat triangleWidth;
@property (nonatomic)CGFloat triangleHeight;
@property (nonatomic)CGFloat triangleOriginX;
@end

@implementation SCSpinnerBorderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.triangleOriginX = 0.5;
        self.triangleWidth  = 0;
        self.triangleHeight = 0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [self pathWithFrame:self.frame];
    [path setLineWidth:self.layer.borderWidth];
    [[UIColor colorWithCGColor:self.layer.backgroundColor] setFill];
    [path fill];
    [[UIColor colorWithCGColor:self.layer.borderColor] setStroke];
    [path stroke];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    [super drawRect:rect];
}

- (UIBezierPath *)pathWithFrame:(CGRect)frame{
    
    CGFloat width  = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGFloat borderWidth = self.layer.borderWidth;
    CGFloat cornerRadius = self.layer.cornerRadius;
    CGFloat borderLineOffset = borderWidth/2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius];
    
    CGPoint points[] = {
        CGPointMake(borderLineOffset, _triangleWidth+borderLineOffset+cornerRadius),
        CGPointMake(borderLineOffset, height-borderLineOffset-cornerRadius),
        CGPointMake(borderLineOffset+cornerRadius, height-borderLineOffset),
        CGPointMake(width-borderLineOffset-cornerRadius, height-borderLineOffset),
        CGPointMake(width-borderLineOffset, height-borderLineOffset-cornerRadius),
        CGPointMake(width-borderLineOffset, _triangleHeight+borderLineOffset+cornerRadius),
        CGPointMake(width-borderLineOffset-cornerRadius, _triangleHeight+borderLineOffset),
        CGPointMake(width*_triangleOriginX+borderLineOffset, _triangleHeight+borderLineOffset),
        CGPointMake(width*_triangleOriginX-_triangleWidth/2, 0),
        CGPointMake(width*_triangleOriginX-_triangleWidth-borderLineOffset, _triangleHeight+borderLineOffset),
        CGPointMake(borderLineOffset+cornerRadius, _triangleHeight+borderLineOffset)
    };
    
    CGPoint points2[] = {
        CGPointMake(borderLineOffset+cornerRadius, _triangleHeight+borderLineOffset+cornerRadius),
        CGPointMake(borderLineOffset+cornerRadius, height-borderLineOffset-cornerRadius),
        CGPointMake(width-borderLineOffset-cornerRadius, height-borderLineOffset-cornerRadius),
        CGPointMake(width-borderLineOffset-cornerRadius, _triangleHeight+borderLineOffset+cornerRadius),
    };
    
    [path moveToPoint:points[0]];
    [path addLineToPoint:points[1]];
    [path moveToPoint:points[2]];
    [path addLineToPoint:points[3]];
    [path moveToPoint:points[4]];
    [path addLineToPoint:points[5]];
    [path moveToPoint:points[6]];
    [path addLineToPoint:points[7]];
    [path addLineToPoint:points[8]];
    [path addLineToPoint:points[9]];
    [path addLineToPoint:points[10]];
    
    
    [path addArcWithCenter:points2[0] radius:cornerRadius startAngle:radians(270) endAngle:radians(180) clockwise:NO];
    [path addArcWithCenter:points2[1] radius:cornerRadius startAngle:radians(180) endAngle:radians(90) clockwise:NO];
    [path addArcWithCenter:points2[2] radius:cornerRadius startAngle:radians(90) endAngle:radians(0) clockwise:NO];
    [path addArcWithCenter:points2[3] radius:cornerRadius startAngle:radians(0) endAngle:radians(270) clockwise:NO];
    
    return path;
}

static inline CGFloat radians (CGFloat degrees) {return degrees * M_PI / 180.0;}

@end

#define DEFAULT_TRIANGLE_WIDTH  10
#define DEFAULT_TRIANGLE_HEIGHT 10
#define DEFAULT_TRIANGLE_OFFSET_COEFFICIENT    0.8
#define SPINNER_FIXED_MARGIN    10
#define BACKGROUND_TOUCH_VIEW_COLOR            [UIColor clearColor]

#define DEFAULT_SPINNER_BACKGROUND_COLOR       [UIColor whiteColor]
#define DEFAULT_SPINNER_OPACITY                0
#define DEFAULT_SPINNER_CORNER_RADIUS          0
#define DEFAULT_SPINNER_BORDER_WIDTH           0
#define DEFAULT_SPINNER_BORDER_COLOR           [UIColor clearColor]
#define DEFAULT_SPINNER_SHADOW_COLOR           [UIColor clearColor]
#define DEFAULT_SPINNER_SHADOW_OFFSET          CGSizeZero
#define DEFAULT_SPINNER_SHADOW_OPACITY         0
#define DEFAULT_SPINNER_SHADOW_RADIUS          0
#define DEFAULT_SPINNER_SPINNER_CELL_SHADOW_COLOR      nil

#define DEFAULT_BORDER_SPINNER_OPACITY         1
#define DEFAULT_BORDER_SPINNER_CORNER_RADIUS   2.5
#define DEFAULT_BORDER_SPINNER_BORDER_WIDTH    1
#define DEFAULT_BORDER_SPINNER_BORDER_COLOR    [SCColor getColor:@"C8C7CC"]

#define DEFAULT_SHADOW_SPINNER_CORNER_RADIUS   2.5
#define DEFAULT_SHADOW_SPINNER_SHADOW_COLOR    [UIColor blackColor]
#define DEFAULT_SHADOW_SPINNER_SHADOW_OFFSET   CGSizeZero
#define DEFAULT_SHADOW_SPINNER_SHADOW_OPACITY  1
#define DEFAULT_SHADOW_SPINNER_SHADOW_RADIUS   10

#define DEFAULT_SPINNER_CELL_BACKGROUND_COLOR          nil
#define DEFAULT_SPINNER_CELL_SELECTED_COLOR            [SCColor getColor:@"e5e5e5"]
#define DEFAULT_SPINNER_CELL_SHADOW_COLOR              [SCColor getColor:@"C8C7CC"]
#define DEFAULT_SPINNER_CELL_SHADOW_OFFSET             CGSizeZero
#define DEFAULT_SPINNER_CELL_SHADOW_OPACITY            1
#define DEFAULT_SPINNER_CELL_SHADOW_RADIUS             0.5
#define DEFAULT_SPINNER_CELL_HEIGHT                    44

#define SPINNER_TYPE_BORDER                    SCSpinnerBorderAutoWidth
#define SPINNER_TYPE_SHADOW                    SCSpinnerShadowAutoWidth
#define SPINNER_TYPE_BORDER_AND_SHADOW         SCSpinnerBorderAndShadowAutoWidth
#define SPINNER_BORDER_SHADOW_TYPE_MASK        0xF
#define SPINNER_FIXED_WIDTH_TYPE_MASK          0x10
#define SPINNER_TRIANGLE_TYPE_MASK             0x100

@interface SCSpinner ()
@property (nonatomic)BOOL isNeedRemoveOrigin;
@property (nonatomic, strong)id           origin;
@property (nonatomic, strong)NSArray*     strings;
@property (nonatomic, strong)UIView*      backgroundTouchView;
@property (nonatomic, strong)NSIndexPath* currentIndexPath;
@property (nonatomic, strong)SCSpinnerDoneBlock   doneCallback;
@property (nonatomic, strong)SCSpinnerCancelBlock cancelCallback;
@property (nonatomic, assign)CGFloat animationDuration;
@end

@implementation SCSpinner

+ (void)showSpinnerWithType:(SCSpinnerType)type rows:(NSArray *)strings initialSelection:(NSInteger)index origin:(id)origin doneBlock:(SCSpinnerDoneBlock)doneBlock cancel:(SCSpinnerCancelBlock)cancelBlock
{
    SCSpinner *tableView = [self spinnerWithType:type];
    [tableView showWithRows:strings initialSelection:index origin:origin done:doneBlock cancel:cancelBlock];
}

+ (void)showSpinnerWithType:(SCSpinnerType)type rows:(NSArray *)strings initialSelection:(NSInteger)index absoluteFrame:(CGRect)absoluteFrame doneBlock:(SCSpinnerDoneBlock)doneBlock cancel:(SCSpinnerCancelBlock)cancelBlock{
    
    UIView *origin = [[UIView alloc]initWithFrame:absoluteFrame];
    origin.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:origin];
    SCSpinner *tableView = [self spinnerWithType:type];
    tableView.isNeedRemoveOrigin = YES;
    
    [tableView showWithRows:strings initialSelection:index origin:origin done:doneBlock cancel:cancelBlock];
}

+ (SCSpinner *)spinnerWithType:(SCSpinnerType)type{
    
    SCSpinner *tableView = nil;
    switch (type & SPINNER_BORDER_SHADOW_TYPE_MASK) {
        case SPINNER_TYPE_BORDER:
            tableView = [self spinnerWithBorderWidth:DEFAULT_BORDER_SPINNER_BORDER_WIDTH];
            break;
        case SPINNER_TYPE_SHADOW:
            tableView = [self spinnerWithShadowRadius:DEFAULT_SHADOW_SPINNER_SHADOW_RADIUS];
            break;
        case SPINNER_TYPE_BORDER_AND_SHADOW:
            tableView = [self spinnerWithBorderAndShadow];
            break;
        default:
            break;
    }
    
    if (type & SPINNER_FIXED_WIDTH_TYPE_MASK) {
        tableView.spinnerWidthType = SCSpinnerWidthFixed;
    }
    
    if (type & SPINNER_TRIANGLE_TYPE_MASK) {
        tableView.hasTriangle = YES;
        tableView.triangleWidth  = DEFAULT_TRIANGLE_WIDTH;
        tableView.triangleHeight = DEFAULT_TRIANGLE_HEIGHT;
    }
    return tableView;
}

+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width{
    return [self spinnerWithBorderWidth:width borderColor:DEFAULT_BORDER_SPINNER_BORDER_COLOR];
}

+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color{
    return [self spinnerWithBorderWidth:width borderColor:color conerRadius:DEFAULT_BORDER_SPINNER_CORNER_RADIUS];
}

+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color conerRadius:(CGFloat)radius{
    return [self spinnerWithBorderWidth:width borderColor:color conerRadius:radius opacity:DEFAULT_BORDER_SPINNER_OPACITY];
}

+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color conerRadius:(CGFloat)radius  opacity:(CGFloat)opacity{
    return [self spinnerWithBorderWidth:width borderColor:color conerRadius:radius opacity:opacity backgroundTouchViewColor:BACKGROUND_TOUCH_VIEW_COLOR];
}

+ (SCSpinner *)spinnerWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color conerRadius:(CGFloat)radius  opacity:(CGFloat)opacity backgroundTouchViewColor:(UIColor *)backgroundTouchViewColor{
    SCSpinner *tableView = [self spinner];
    [tableView.layer setBorderColor:color.CGColor];
    [tableView.layer setBorderWidth:width];
    [tableView.layer setCornerRadius:radius];
    [tableView.layer setOpacity:opacity];
    tableView.backgroundTouchViewColor = backgroundTouchViewColor;
    
    return tableView;
}

+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius{
    return [self spinnerWithShadowRadius:radius shadowColor:DEFAULT_SHADOW_SPINNER_SHADOW_COLOR];
}

+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius shadowColor:(UIColor *)color{
    return [self spinnerWithShadowRadius:radius shadowColor:color shadowOpacity:DEFAULT_SHADOW_SPINNER_SHADOW_OPACITY];
}

+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius shadowColor:(UIColor *)color shadowOpacity:(CGFloat)opacity{
    return [self spinnerWithShadowRadius:radius shadowColor:color shadowOpacity:opacity shadowOffset:DEFAULT_SHADOW_SPINNER_SHADOW_OFFSET];
}

+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius shadowColor:(UIColor *)color shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset{
    return [self spinnerWithShadowRadius:radius shadowColor:color shadowOpacity:opacity shadowOffset:offset backgroundTouchViewColor:BACKGROUND_TOUCH_VIEW_COLOR];
}

+ (SCSpinner *)spinnerWithShadowRadius:(CGFloat)radius shadowColor:(UIColor *)color shadowOpacity:(CGFloat)opacity shadowOffset:(CGSize)offset backgroundTouchViewColor:(UIColor *)backgroundTouchViewColor{
    SCSpinner *tableView = [self spinner];
    [tableView.layer setShadowColor:color.CGColor];
    [tableView.layer setShadowOffset:offset];
    [tableView.layer setShadowRadius:radius];
    [tableView.layer setShadowOpacity:opacity];
    tableView.backgroundTouchViewColor = backgroundTouchViewColor;
    [tableView.layer setCornerRadius:DEFAULT_SHADOW_SPINNER_CORNER_RADIUS];
    
    return tableView;
}

+ (SCSpinner *)spinnerWithBorderAndShadow{
    SCSpinner *tableView = [self spinnerWithBorderWidth:DEFAULT_BORDER_SPINNER_BORDER_WIDTH];
    [tableView.layer setShadowColor:DEFAULT_SHADOW_SPINNER_SHADOW_COLOR.CGColor];
    [tableView.layer setShadowOffset:DEFAULT_SHADOW_SPINNER_SHADOW_OFFSET];
    [tableView.layer setShadowRadius:DEFAULT_SHADOW_SPINNER_SHADOW_RADIUS];
    [tableView.layer setShadowOpacity:DEFAULT_SHADOW_SPINNER_SHADOW_OPACITY];
    return tableView;
}

+ (SCSpinner *)spinner{
    SCSpinner *tableView = [[SCSpinner alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.spinnerCellHeight = DEFAULT_SPINNER_CELL_HEIGHT;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = tableView;
    tableView.delegate = tableView;
    [tableView setBackgroundColor:DEFAULT_SPINNER_BACKGROUND_COLOR];
    [tableView.layer setShadowColor:DEFAULT_SPINNER_SHADOW_COLOR.CGColor];
    [tableView.layer setShadowOffset:DEFAULT_SPINNER_SHADOW_OFFSET];
    [tableView.layer setShadowRadius:DEFAULT_SPINNER_SHADOW_RADIUS];
    [tableView.layer setShadowOpacity:DEFAULT_SPINNER_SHADOW_OPACITY];
    [tableView.layer setCornerRadius:DEFAULT_SPINNER_CORNER_RADIUS];
    [tableView.layer setBorderWidth:DEFAULT_SPINNER_BORDER_WIDTH];
    [tableView.layer setBorderColor:DEFAULT_SPINNER_BORDER_COLOR.CGColor];
    tableView.backgroundTouchViewType = SCSpinnerBackgroundFullScreen;
    tableView.spinnerWidthType = SCSpinnerWidthAuto;
    tableView.backgroundTouchViewColor = BACKGROUND_TOUCH_VIEW_COLOR;
    tableView.spinnerCellBackgroundColor = DEFAULT_SPINNER_CELL_BACKGROUND_COLOR;
    tableView.spinnerCellShadowColor   = DEFAULT_SPINNER_SPINNER_CELL_SHADOW_COLOR;
    tableView.spinnerCellShadowOffset  = DEFAULT_SPINNER_CELL_SHADOW_OFFSET;
    tableView.spinnerCellShadowOpacity = DEFAULT_SPINNER_CELL_SHADOW_OPACITY;
    tableView.spinnerCellShadowRadius  = DEFAULT_SPINNER_CELL_SHADOW_RADIUS;
    tableView.spinnerCellSelectedColor = DEFAULT_SPINNER_CELL_SELECTED_COLOR;
    tableView.hasTriangle = NO;
    tableView.triangleWidth  = 0;
    tableView.triangleHeight = 0;
    tableView.triangleOffsetCoefficient = DEFAULT_TRIANGLE_OFFSET_COEFFICIENT;
    
    
    UIView *backgroundTouchView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundTouchView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:tableView action:@selector(tapGestureRecognizerAction:)];
    [backgroundTouchView addGestureRecognizer:tapGestureRecognizer];
    tableView.backgroundTouchView = backgroundTouchView;
    
    return tableView;
}

- (void)showWithRows:(NSArray *)strings initialSelection:(NSInteger)index origin:(id)origin done:(SCSpinnerDoneBlock)doneBlock cancel:(SCSpinnerCancelBlock)cancelBlock{
    self.strings  = strings;
    self.origin = origin;
    self.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    self.doneCallback = doneBlock;
    self.cancelCallback = cancelBlock;
    
    [self show];
}

- (void)show{
    CGRect realFrame = [self recountFrames];
    self.rowHeight = self.spinnerCellHeight;
    SCSpinnerBorderView *borderView = [[SCSpinnerBorderView alloc]initWithFrame:realFrame];
    [borderView.layer setShadowColor:self.layer.shadowColor];
    [borderView.layer setShadowOffset:self.layer.shadowOffset];
    [borderView.layer setShadowRadius:self.layer.shadowRadius];
    [borderView.layer setShadowOpacity:self.layer.shadowOpacity];
    [borderView.layer setBackgroundColor:self.backgroundColor.CGColor];
    [borderView.layer setBorderColor:self.layer.borderColor];
    [borderView.layer setBorderWidth:self.layer.borderWidth];
    [borderView.layer setCornerRadius:self.layer.cornerRadius];
    if (self.hasTriangle) {
        self.layer.borderWidth = 0;
        borderView.triangleWidth = self.triangleWidth;
        borderView.triangleHeight = self.triangleHeight;
        CGRect frame = realFrame;
        frame.origin.x    -= borderView.layer.borderWidth;
        frame.size.width  += borderView.layer.borderWidth*2;
        frame.origin.y    -= borderView.layer.borderWidth;
        frame.size.height += borderView.layer.borderWidth*2;
        frame.origin.y    -= borderView.triangleHeight;
        frame.size.height += borderView.triangleHeight;
        borderView.frame = frame;
        CGRect originFrame = [self relativeFrameForScreenWithView:(UIView *)self.origin];
        borderView.triangleOriginX = (originFrame.origin.x + (originFrame.size.width - self.triangleWidth)*self.triangleOffsetCoefficient - frame.origin.x)/(frame.size.width - self.triangleWidth);
    }
    [self.backgroundTouchView addSubview:borderView];
    [self.backgroundTouchView setBackgroundColor:self.backgroundTouchViewColor];
//    if (self.backgroundTouchViewType == SCSpinnerBackgroundFullScreen){
//        [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundTouchView];
//        [[UIApplication sharedApplication].keyWindow addSubview:self];
//    } else{
//        UIView *superView = [self lastNoFullScreenSuperViewWithView:self.origin];
//        [superView addSubview:self.backgroundTouchView];
//        [superView addSubview:self];
//    }
//    if (self.currentIndexPath.row >=0 && self.currentIndexPath.row < self.strings.count){
//        [self selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
//    }
    
    
    __weak SCSpinner *wSelf = self;
    self.frame = CGRectMake(realFrame.origin.x, realFrame.origin.y,realFrame.size.width, 0);
    CGRect borderViewFrame = borderView.frame;
    borderView.frame = CGRectMake(borderViewFrame.origin.x, borderViewFrame.origin.y,borderViewFrame.size.width, 0);
;
    [UIView animateWithDuration:self.animationDuration * 1.5f
                          delay:0
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         if (wSelf.backgroundTouchViewType == SCSpinnerBackgroundFullScreen){
                             [[UIApplication sharedApplication].keyWindow addSubview:wSelf.backgroundTouchView];
                             [[UIApplication sharedApplication].keyWindow addSubview:wSelf];
                         } else{
                             UIView *superView = [wSelf lastNoFullScreenSuperViewWithView:wSelf.origin];
                             [superView addSubview:wSelf.backgroundTouchView];
                             [superView addSubview:wSelf];
                         }
                         
                         wSelf.frame = realFrame;
                         borderView.frame = borderViewFrame;
                         [wSelf layoutIfNeeded];
                         [wSelf reloadData];
                         
                     } completion:^(BOOL finished) {
                         
                         if (wSelf.currentIndexPath.row >=0 && wSelf.currentIndexPath.row < wSelf.strings.count){
                             [wSelf selectRowAtIndexPath:wSelf.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                         }
                     }];
}

//默认动画时间0.4s
- (CGFloat)animationDuration
{
    if (!_animationDuration * 100) {
        return 0.4f;
    }
    return _animationDuration;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.strings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:self.spinnerCellBackgroundColor ? self.spinnerCellBackgroundColor : self.backgroundColor];
        CGColorRef tempShadowColor = CGColorEqualToColor(self.layer.borderColor,[UIColor clearColor].CGColor) ? self.layer.shadowColor : self.layer.borderColor;
        tempShadowColor = CGColorEqualToColor(tempShadowColor, [UIColor clearColor].CGColor) ? DEFAULT_SPINNER_CELL_SHADOW_COLOR.CGColor : tempShadowColor;
        [cell.layer setShadowColor: self.spinnerCellShadowColor ? self.spinnerCellShadowColor.CGColor : tempShadowColor];
        [cell.layer setShadowOffset:self.spinnerCellShadowOffset];
        CGRect frame = cell.layer.frame;
        frame.size.width = self.width;
        cell.layer.frame = frame;
        [cell.layer setShadowRadius:self.spinnerCellShadowRadius];
        [cell.layer setShadowOpacity:self.spinnerCellShadowOpacity];
        [cell.layer setShadowPath:[UIBezierPath bezierPathWithRect:cell.layer.bounds].CGPath];
        if (self.spinnerCellSelectedColor) {
            cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = self.spinnerCellSelectedColor;
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = @"";
    if (indexPath.row < self.strings.count) {
        cell.textLabel.text = self.strings[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return self.spinnerCellHeight;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.strings.count) {
        !self.doneCallback ? : self.doneCallback(indexPath.row, self.strings[indexPath.row]);
        [self disappear];
    }
}

#pragma mark - Getters And Setters

char associatedHasTriangleKey;
- (BOOL)hasTriangle{
    return [[self associatedObjectForKey:&associatedHasTriangleKey] boolValue];
}

- (void)setHasTriangle:(BOOL)hasTriangle{
    [self setAssociatedObject:[NSNumber numberWithBool:hasTriangle] forKey:&associatedHasTriangleKey];
}

char associatedTriangleWidthKey;
- (CGFloat)triangleWidth {
    return [[self associatedObjectForKey:&associatedTriangleWidthKey] floatValue];
}

- (void)setTriangleWidth:(CGFloat)triangleWidth{
    [self setAssociatedObject:[NSNumber numberWithFloat:triangleWidth] forKey:&associatedTriangleWidthKey];
}

char associatedTriangleHeightKey;
- (CGFloat)triangleHeight {
    return [[self associatedObjectForKey:&associatedTriangleHeightKey] floatValue];
}

- (void)setTriangleHeight:(CGFloat)triangleHeight{
    [self setAssociatedObject:[NSNumber numberWithFloat:triangleHeight] forKey:&associatedTriangleHeightKey];
}

char associatedTriangleOffsetCoefficientKey;
- (CGFloat)triangleOffsetCoefficient{
    return [[self associatedObjectForKey:&associatedTriangleOffsetCoefficientKey] floatValue];
}

- (void)setTriangleOffsetCoefficient:(CGFloat)triangleOffsetCoefficient{
    [self setAssociatedObject:[NSNumber numberWithFloat:triangleOffsetCoefficient] forKey:&associatedTriangleOffsetCoefficientKey];
}

char associatedBackgroundTouchViewTypeKey;
- (SCSpinnerBackgroundType)backgroundTouchViewType{
    return [[self associatedObjectForKey:&associatedBackgroundTouchViewTypeKey] integerValue];
}

- (void)setBackgroundTouchViewType:(SCSpinnerBackgroundType)backgroundTouchViewType{
    [self setAssociatedObject:[NSNumber numberWithInteger:backgroundTouchViewType] forKey:&associatedBackgroundTouchViewTypeKey];
}

char associatedSpinnerWidthTypeKey;
- (SCSpinnerWidthType)spinnerWidthType{
    return [[self associatedObjectForKey:&associatedSpinnerWidthTypeKey] integerValue];
}

- (void)setSpinnerWidthType:(SCSpinnerWidthType)spinnerWidthType{
    [self setAssociatedObject:[NSNumber numberWithInteger:spinnerWidthType] forKey:&associatedSpinnerWidthTypeKey];
}

char associatedBackgroundTouchViewKey;
- (UIView *)backgroundTouchView{
    return [self associatedObjectForKey:&associatedBackgroundTouchViewKey];
}

- (void)setBackgroundTouchView:(UIView *)backgroundTouchView{
    [self setAssociatedObject:backgroundTouchView forKey:&associatedBackgroundTouchViewKey];
}

char associatedBackgroundTouchViewColorKey;
- (UIColor *)backgroundTouchViewColor{
    return [self associatedObjectForKey:&associatedBackgroundTouchViewColorKey];
}

- (void)setBackgroundTouchViewColor:(UIColor *)backgroundTouchViewColor{
    [self setAssociatedObject:backgroundTouchViewColor forKey:&associatedBackgroundTouchViewColorKey];
}

char associatedSpinnerCellHeightKey;
- (CGFloat)spinnerCellHeight{
    return [[self associatedObjectForKey:&associatedSpinnerCellHeightKey] floatValue];
}

- (void)setSpinnerCellHeight:(CGFloat)spinnerCellHeight{
    [self setAssociatedObject:[NSNumber numberWithFloat:spinnerCellHeight] forKey:&associatedSpinnerCellHeightKey];
}

char associatedSpinnerCellBackgroundColorKey;
- (UIColor *)spinnerCellBackgroundColor{
    return [self associatedObjectForKey:&associatedSpinnerCellBackgroundColorKey];
}

- (void)setSpinnerCellBackgroundColor:(UIColor *)SpinnerCellBackgroundColor{
    [self setAssociatedObject:SpinnerCellBackgroundColor forKey:&associatedSpinnerCellBackgroundColorKey];
}

char associatedSpinnerCellSelectedColorKey;
- (UIColor *)spinnerCellSelectedColor{
    return [self associatedObjectForKey:&associatedSpinnerCellSelectedColorKey];
}

- (void)setSpinnerCellSelectedColor:(UIColor *)SpinnerCellSelectedColor{
    [self setAssociatedObject:SpinnerCellSelectedColor forKey:&associatedSpinnerCellSelectedColorKey];
}

char associatedSpinnerCellShadowColorKey;
- (UIColor *)spinnerCellShadowColor{
    return [self associatedObjectForKey:&associatedSpinnerCellShadowColorKey];
}

- (void)setSpinnerCellShadowColor:(UIColor *)SpinnerCellShadowColor{
    [self setAssociatedObject:SpinnerCellShadowColor forKey:&associatedSpinnerCellShadowColorKey];
}

char associatedSpinnerCellShadowOffsetKey;
- (CGSize)spinnerCellShadowOffset{
    CGSize size = CGSizeZero;
    CGSizeMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)[self associatedObjectForKey:&associatedSpinnerCellShadowOffsetKey], &size);
    return size;
}

- (void)setSpinnerCellShadowOffset:(CGSize)SpinnerCellShadowOffset{
    [self setAssociatedObject:(__bridge_transfer NSDictionary*)CGSizeCreateDictionaryRepresentation(SpinnerCellShadowOffset) forKey:&associatedSpinnerCellShadowOffsetKey];
}

char associatedSpinnerCellRadiusKey;
- (CGFloat)spinnerCellShadowRadius{
    return [[self associatedObjectForKey:&associatedSpinnerCellRadiusKey] floatValue];
}

- (void)setSpinnerCellShadowRadius:(CGFloat)SpinnerCellShadowRadius{
    [self setAssociatedObject:[NSNumber numberWithFloat:SpinnerCellShadowRadius] forKey:&associatedSpinnerCellRadiusKey];
}

char associatedSpinnerCellOpecityKey;
- (CGFloat)spinnerCellShadowOpacity{
    return [[self associatedObjectForKey:&associatedSpinnerCellOpecityKey] floatValue];
}

- (void)setSpinnerCellShadowOpacity:(CGFloat)SpinnerCellShadowOpacity{
    [self setAssociatedObject:[NSNumber numberWithFloat:SpinnerCellShadowOpacity] forKey:&associatedSpinnerCellOpecityKey];
}

char associatedIsNeedRemoveOriginKey;
- (BOOL)isNeedRemoveOrigin{
    return [[self associatedObjectForKey:&associatedIsNeedRemoveOriginKey] boolValue];
}

- (void)setIsNeedRemoveOrigin:(BOOL)isNeedRemoveOrigin{
    [self setAssociatedObject:[NSNumber numberWithBool:isNeedRemoveOrigin] forKey:&associatedIsNeedRemoveOriginKey];
}
char associatedOriginKey;
- (id)origin{
    return [self associatedObjectForKey:&associatedOriginKey];
}

- (void)setOrigin:(id)origin{
    [self setAssociatedObject:origin forKey:&associatedOriginKey];
}

char associatedDoneCallbackKey;
- (SCSpinnerDoneBlock) doneCallback{
    return [self associatedObjectForKey:&associatedDoneCallbackKey];
}

- (void) setDoneCallback:(SCSpinnerDoneBlock)doneCallback {
    [self setAssociatedObject:doneCallback forKey:&associatedDoneCallbackKey];
}

char associatedCancelCallbackKey;
- (SCSpinnerCancelBlock) cancelCallback{
    return [self associatedObjectForKey:&associatedCancelCallbackKey];
}

- (void) setCancelCallback:(SCSpinnerCancelBlock)cancelCallback{
    [self setAssociatedObject:cancelCallback forKey:&associatedCancelCallbackKey];
}

char associatedStringsKey;
- (NSArray *)strings{
    return [self associatedObjectForKey:&associatedStringsKey];
}

- (void)setStrings:(NSArray *)strings{
    [self setAssociatedObject:strings forKey:&associatedStringsKey];
}

char associatedCurrentIndexPathKey;
- (NSIndexPath *)currentIndexPath{
    return [self associatedObjectForKey:&associatedCurrentIndexPathKey];
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath{
    [self setAssociatedObject:currentIndexPath forKey:&associatedCurrentIndexPathKey];
}

#pragma mark - Private Methods
- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)tap{
    !self.cancelCallback ?  : self.cancelCallback();
    [self disappear];
}

- (CGRect)recountFrames{
    UIView *origin = (UIView *)self.origin;
    CGRect frame = [self relativeFrameForScreenWithView:origin];
    
    if (self.backgroundTouchViewType == SCSpinnerBackgroundFullScreen) {
        frame.origin.y = frame.origin.y + frame.size.height + self.triangleHeight;
        frame.size.height = MIN(ScreenHeight - frame.origin.y, self.strings.count*self.spinnerCellHeight);
        self.backgroundTouchView.frame = [UIScreen mainScreen].bounds;
    }else{
        UIView *superView = [self lastNoFullScreenSuperViewWithView:self.origin];
        frame = [self convertFrameForLastNoFullScreenWithView:(UIView *)self.origin];
        frame.origin.y = frame.origin.y + frame.size.height + self.triangleHeight;
        frame.size.height = MIN(superView.frame.size.height - frame.origin.y, self.strings.count*self.spinnerCellHeight);
        self.backgroundTouchView.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
    }
    
    if (self.spinnerWidthType == SCSpinnerWidthFixed) {
        frame.origin.x = SPINNER_FIXED_MARGIN;
        frame.size.width = ScreenWidth - SPINNER_FIXED_MARGIN*2;
    }
    if (self.hasTriangle) {
        frame.origin.x    += self.layer.borderWidth;
        frame.size.width  -= self.layer.borderWidth*2;
        frame.origin.y    += self.layer.borderWidth;
        frame.size.height -= self.layer.borderWidth*2;
    }
    
//    self.frame = frame;
    
    if (self.layer.shadowPath == nil) {
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:frame].CGPath;
    }
    
    return frame;
}

- (CGRect)relativeFrameForScreenWithView:(UIView *)view
{
    CGRect tempFrame = [view convertRect:view.frame toView:nil];
    return CGRectMake(tempFrame.origin.x - view.origin.x, tempFrame.origin.y - view.origin.y, view.frame.size.width, view.frame.size.height);
}

- (CGRect)convertFrameForLastNoFullScreenWithView:(UIView *)view
{
    UIView *tempView = view;
    CGFloat x = .0;
    CGFloat y = .0;
    do{
        x += tempView.frame.origin.x;
        y += tempView.frame.origin.y;
        tempView = tempView.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) tempView).contentOffset.x;
            y -= ((UIScrollView *) tempView).contentOffset.y;
        }
    }while (tempView.superview.frame.size.width != ScreenWidth ||
            tempView.superview.frame.size.height != ScreenHeight ||
            tempView.superview.frame.origin.y != 0 ||
            tempView.superview.frame.origin.x != 0);
    return CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
}

- (UIView *)lastNoFullScreenSuperViewWithView:(UIView *)view
{
    UIView *tempView = view;
    while (tempView.superview.frame.size.width != ScreenWidth || tempView.superview.frame.size.height != ScreenHeight || tempView.superview.frame.origin.y != 0 || tempView.superview.frame.origin.x != 0) {
        tempView = tempView.superview;
    }
    return tempView == view ? view.superview : tempView;
}

- (void)disappear{
    !self.isNeedRemoveOrigin ? : [self.origin removeFromSuperview];
    [self.backgroundTouchView removeFromSuperview];
    [self removeFromSuperview];
    [self setAssociatedObject:nil forKey:&associatedBackgroundTouchViewColorKey];
    [self setAssociatedObject:nil forKey:&associatedBackgroundTouchViewKey];
    [self setAssociatedObject:nil forKey:&associatedDoneCallbackKey];
    [self setAssociatedObject:nil forKey:&associatedCancelCallbackKey];
    [self setAssociatedObject:nil forKey:&associatedSpinnerCellBackgroundColorKey];
    [self setAssociatedObject:nil forKey:&associatedSpinnerCellHeightKey];
    [self setAssociatedObject:nil forKey:&associatedSpinnerCellOpecityKey];
    [self setAssociatedObject:nil forKey:&associatedSpinnerCellRadiusKey];
    [self setAssociatedObject:nil forKey:&associatedSpinnerCellShadowColorKey];
    [self setAssociatedObject:nil forKey:&associatedSpinnerCellShadowOffsetKey];
    [self setAssociatedObject:nil forKey:&associatedOriginKey];
    [self setAssociatedObject:nil forKey:&associatedCurrentIndexPathKey];
    [self setAssociatedObject:nil forKey:&associatedStringsKey];
    [self setAssociatedObject:nil forKey:&associatedSpinnerCellSelectedColorKey];
    [self setAssociatedObject:nil forKey:&associatedBackgroundTouchViewTypeKey];
    [self setAssociatedObject:nil forKey:&associatedSpinnerWidthTypeKey];
    [self setAssociatedObject:nil forKey:&associatedHasTriangleKey];
    [self setAssociatedObject:nil forKey:&associatedTriangleWidthKey];
    [self setAssociatedObject:nil forKey:&associatedTriangleHeightKey];
    [self setAssociatedObject:nil forKey:&associatedIsNeedRemoveOriginKey];
}

@end
