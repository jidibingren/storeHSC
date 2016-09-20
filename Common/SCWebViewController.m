
#import "SCWebViewController.h"
#import "NSURL+NSURLEx.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SCWebViewController () {
    NSString* _realUrl;
    JSContext* _jsContext;
    UIWebView* _webView;
}
@end

@implementation SCWebViewController

- (id) init {
    self = [super init];
    [self customize];
    return self;
}

- (void) setUrl:(NSString*)url {
    _url = url;
    _realUrl = [[BDEnvironment env] replaceUrl: url];
    [self setModuleIdByUrl:url];
}

- (void) customize {
    // don't write any code here, we add this to let each project to customize this webView by Category.
}

- (void)setupSubviews
{
    [super setupSubviews];
    [self updateBackButtonVisibility];
    self.navigationItem.title = _navTitle;
    //设置barStyle可以去掉下面的细线
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    UIWebView * webView = [[UIWebView alloc] initWithFrame:[self contentFrame]];
    _webView = webView;
    _webView.delegate = self;
    // http://stackoverflow.com/questions/21420137/black-line-appearing-at-bottom-of-uiwebview-how-to-remove
    webView.opaque = NO;
    webView.backgroundColor = [UIColor whiteColor];
    
    [webView.scrollView setBounces:!self.isDisableBounces];
    
    if (_html) {
        [webView loadHTMLString:_html baseURL:_baseUrl];
    }
    else if (_realUrl) {
        NSURL * url = _baseUrl ? [NSURL URLWithString:_realUrl relativeToURL:_baseUrl] : [NSURL URLWithString:_realUrl];
        [self updateByUrl:url];
        if ([Utils isValidStr:[Utils getLoginToken]]) {
            url = [url URLByAppendingQueryString:[NSString stringWithFormat:@"access_token=%@",[[Utils getLoginToken] encodeURLParameterString]]];
        }
        
        NSURLRequest * request = [NSURLRequest  requestWithURL:url];
        [webView loadRequest:request];
    }
    [self.view addSubview:webView];
    
    [self updateJSContext];
}

- (void) updateJSContext {
    _jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    if (TARGET_IPHONE_SIMULATOR) {
        _jsContext[@"console"][@"log"] = ^(JSValue * msg) {
            NSLog(@"JavaScript log: %@", msg);
        };
    }
    
}

- (void) updateByUrl:(NSURL*)url {
    NSArray* queries = [[url query] componentsSeparatedByString:@"&"];
    if (queries) {
        if ([queries containsObject:@"noBackButton=1"]) {
            self.noBackButton = YES;
            [self updateBackButtonVisibility];
        }
        if ([queries containsObject:@"closeWhenBack=1"]) {
            self.backAlwaysPopViewController = YES;
        }
        if ([queries containsObject:@"gotoHomepage=1"]) {
            self.isGotoHomepage = YES;
        }
    }
}

- (void) updateBackButtonVisibility {
    if (self.noBackButton) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _webView.frame = self.view.bounds;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.closeMeWhenAppearIfNotLoggedIn) {
        if (![Utils isLogined]) {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.reloadOnceWhenAppearIfLoggedIn) {
        self.reloadOnceWhenAppearIfLoggedIn = NO;
        if ([Utils isLogined]) {
            if ([Utils isValidStr:[Utils getLoginToken]]) {
                NSURL *currentUrl = _webView.request.URL;
                currentUrl =  [currentUrl URLByAppendingQueryString:[NSString stringWithFormat:@"token=%@", [[Utils getLoginToken] encodeURLParameterString]]];
                [_webView loadRequest:[NSURLRequest requestWithURL:currentUrl]];
            } else {
                [_webView reload];
            }
        }
    }
}

- (void)viewDidDismiss {
    [super viewDidDismiss];
    if (_jsContext) {
        _jsContext[@"scApp"] = nil;
        _jsContext = nil;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    __block BOOL isSuccessed = NO;
    dispatch_semaphore_t disp = dispatch_semaphore_create(0);
    NSURLSessionDataTask *dataTask =  [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ([(NSHTTPURLResponse*)response statusCode] >= 200 && [(NSHTTPURLResponse*)response statusCode] < 300)
        {
            // code for 404
            isSuccessed = YES;
        }
        
        dispatch_semaphore_signal(disp);
    }];
    
    [dataTask resume];
    
    dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
    
    [self updateByUrl:request.URL];
    
    return isSuccessed;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([Utils isNilOrNSNull:self.navigationItem.rightBarButtonItem] || [self.navigationItem.rightBarButtonItem.customView isMemberOfClass:[UIActivityIndicatorView class]]) {
        [self.navigationItem setSpinnerVisible: YES];
    }else{
        [webView makeToastActivity];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (webView != _webView) { return; }

    [self updateJSContext];
    
    if ([self.navigationItem.rightBarButtonItem.customView isMemberOfClass:[UIActivityIndicatorView class]]) {
        [self.navigationItem setSpinnerVisible: NO];
    }else{
        [webView hideToastActivity];
    }

    // 产生ScAppReady事件, scApp不是一开始就在页面中可用,页面需要这个事件来确定scApp可用.
    // 用异步的形式来避免js调用某些设计界面的阻塞的方法(比如alert()) 使app卡住.
    [webView stringByEvaluatingJavaScriptFromString:@" \
     if (!window.sentScAppReadyEvent) { \
         setTimeout(function() { \
             var readyEvent = document.createEvent('Events'); \
             readyEvent.initEvent('ScAppReady'); \
             document.dispatchEvent(readyEvent); \
         }, 0); \
         window.sentScAppReadyEvent = true; \
     };"];

    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (theTitle && ![theTitle isEmpty]) {
        self.navigationItem.title = theTitle;
    }

}

- (void)setModuleIdByUrl:(NSString*)url{
    
}

//override
-(void)onBack {
    [_webView stopLoading];
    if (!self.backAlwaysPopViewController && [_webView canGoBack]) {
        [_webView goBack];
    } else if(self.isGotoHomepage){
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [super onBack];
    }
}

- (void) dealloc {
    
}

+ (SCWebViewController*) pushFromController:(UIViewController *)controller url:(NSString *)url title:(NSString *)title {
    SCWebViewController* wv = [[SCWebViewController alloc]init];
    wv.url = url;
    wv.navTitle = title;
    [controller.navigationController pushViewController:wv animated:YES];
    return wv;
}

+ (SCWebViewController*) pushFromController:(UIViewController *)controller url:(NSString *)url disableBounces:(BOOL)isDisableBounces {
    SCWebViewController* wv = [[SCWebViewController alloc]init];
    wv.url = url;
    wv.isDisableBounces = isDisableBounces;
    [controller.navigationController pushViewController:wv animated:YES];
    return wv;
}
@end
