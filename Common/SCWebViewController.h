
#import <UIKit/UIKit.h>

// 一个ViewController，包装了一个UIWebView
@interface SCWebViewController : SCBaseViewController<UIWebViewDelegate>
@property (nonatomic, strong)NSURL *baseUrl;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *html;
@property (nonatomic, strong)NSString * navTitle;
@property BOOL backAlwaysPopViewController;
@property BOOL noBackButton;
@property BOOL reloadOnceWhenAppearIfLoggedIn;
@property BOOL closeMeWhenAppearIfNotLoggedIn;
@property BOOL isDisableBounces;
@property BOOL isGotoHomepage;

+ (SCWebViewController*) pushFromController: (UIViewController*)controller url:(NSString*)url title:(NSString*)title;

+ (SCWebViewController*) pushFromController:(UIViewController *)controller url:(NSString *)url disableBounces:(BOOL)isDisableBounces;

@end
