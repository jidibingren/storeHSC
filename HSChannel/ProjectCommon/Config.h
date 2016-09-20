//
//  Config.h
//  Template
//
//  Created by SC on 15/12/31.
//  Copyright (c) 2015年 SC. All rights reserved.
//

#ifndef Template_Config_h
#define Template_Config_h


#define SC_TP_MBPROGRESSHUD
#define SC_TP_TPKEYBOARD_AVOIDING
#define SC_TP_SDWEBIMAGE
#define SC_TP_CSLINEAR
#define SC_TP_KEYVALUE_MAPPING
#define SC_TP_BLOCKSKIT
#define SC_TP_UIVIEWADDTIONS
#define SC_TP_AFNETWORKING
#define SC_TP_TOAST
#define SC_TP_MJREFRESH
#undef SC_TP_BAIDUMAP
#define SC_TP_KVO_CONTROLLER

// 定义一些每个应用不同的参数
#if TARGET_IPHONE_SIMULATOR
#define DEBUG_FILL_FORM
#endif

#define UMENG_APP_KEY_ONLINE @""

#define BAIDU_MAP_KEY @"VYKOXaUQ0tdeHZxQUSRYsdE03XKyj2G4"
//
//b80e75a62b708b8efde712a6ee040b79
//#define ALI_MAP_KEY @"b80e75a62b708b8efde712a6ee040b79"
#define ALI_MAP_KEY @"58035ee6af00f22eb5f169b30879f19c"

#define BUGLY_APP_ID @"900016880"

#define WX_APPID @""
#define WX_SECRET @""

#define EASE_APP_KEY          @"jinyouwangluo#jxtsxy"
#define EASE_CLIENTID         @"YXA62mxtMHNHEeaSaYXGNxhYnw"
#define EASE_CLIENT_SECRET    @"YXA6D20u_M-igSvYkXKL66G5sBXtWGY"
#define EASE_CER_NAME_DEVELOP @""
#define EASE_CER_NAME_PRODUCT @""

// 正式服务器
#define ONLINE_SERVER @"115.28.162.22:1881/jxt"
//#define ONLINE_SERVER @"192.168.1.65:5050"
//#define ONLINE_SERVER @"192.168.1.104:5050"
#define ONLINE_SERVER2 @"api.mall.yiliangche.cn"

#define BASEURL_NO_HTTPS   @"http://" ONLINE_SERVER
#define BASEURL2_NO_HTTPS   @"http://" ONLINE_SERVER2
#define BASEURL_TEST    @"http://test.o2obest.cn"
#define BASEURL2_TEST   @"http://test.o2obest.cn"

#define BASEURL   @"http://" ONLINE_SERVER
#define BASEURL2   @"http://" ONLINE_SERVER2

#define BASEURL_HTTPS   @"http://" ONLINE_SERVER
#define BASEURL2_HTTPS   @"https://" ONLINE_SERVER2

#define APPID       @"1071961967"

#define DEFAULT_COMPANY_KEY @"bdba25425f0b8810db98b45981086ea7"

#define kLimitedWords @"请输入6-20位新密码"


#define SC_COLOR_NAV_BG         @"2aaa4d"
#define SC_COLOR_NAV_TEXT       @"ffffff" // white
#define SC_COLOR_VIEW_BG        @"ffffff"
#define SC_COLOR_TEXTFIELD_BG   @"f1f1f1"
#define SC_COLOR_THEME_TEXT     SC_COLOR_NAV_BG
#define SC_COLOR_THEME_BG       SC_COLOR_NAV_BG
#define SC_COLOR_TABBAR_BG_NORMAL      @"ffffff"
#define SC_COLOR_TABBAR_BG_SELECTED    SC_COLOR_NAV_BG
#define SC_COLOR_TABBAR_TITLE_NORMAL   @"666666"
#define SC_COLOR_TABBAR_TITLE_SELECTED SC_COLOR_NAV_BG
#define SC_COLOR_SEPARATOR_LINE @"e5e5e5"
#define SC_COLOR_BUTTON_TITLE   @"ffffff"
#define SC_COLOR_BUTTON_NORMAL  SC_COLOR_NAV_BG
#define SC_COLOR_BUTTON_HIGHLIGHT @"999999"
#define SC_FONT_NAV_TEXT        20.0
#define SC_FONT_1        20.0
#define SC_FONT_2        18.0
#define SC_FONT_3        15.0
#define SC_FONT_4        12.0
#define SC_FONT_5        9.0
#define SC_FONT_15        15.0
#define SC_FONT_14        14.0
#define SC_FONT_12        12.0
#define SC_COLOR_TEXT_1       @"000000"
#define SC_COLOR_TEXT_2       @"333333"
#define SC_COLOR_TEXT_3       @"666666"
#define SC_COLOR_TEXT_4       @"999999"
#define SC_COLOR_TEXT_5       @"cccccc"
#define SC_COLOR_TEXT_6       @"ffffff"

#define SC_COLOR_1       @"000000"
#define SC_COLOR_2       @"7f7f7f"
#define SC_COLOR_3       @"dadada"
#define SC_COLOR_4       @"ffffff"

#define SC_OFFSET            10
#define SC_MARGIN_TOP        10
#define SC_MARGIN_BOTTOM     -10
#define SC_MARGIN_LEFT       10
#define SC_MARGIN_RIGHT      -10

#define JY_COLOR_VIEW_BG @"ffffff"
#define JY_FONT_NAV_TEXT 20.0

//返回上一级图片
#define JY_IMAGE_LEFT_BACK          @"search_icon_back@2x"
//用户名左边标志
#define JY_IMAGE_LEFT_USERNAME      @"icon_me_selected@2x"
//密码左边标志
#define JY_IMAGE_LEFT_PASSWORD      @"explor_icon_park@2x"
//view背景色-淡灰色
#define JY_COLOR_VIEW_BG            @"f3f3f3"
//按钮-淡金色
#define JY_COLOR_BUTTON_BORDER            @"f4b840"
#define JY_MESSAGE_ERROR            @"网络有问题，请稍后重试!"
#define JY_MESSAGE_SUCESS            @"操作成功!"
#define JY_MESSAGE_FAILS            @"操作失败!"
//app主窗口
#define JYKeyWindow [UIApplication sharedApplication].keyWindow
// 默认使用福州市中心
#define DEFAULT_LOCATION CLLocationCoordinate2DMake(26.106131, 119.302548)

#define SC_APP_UPDATE_INFO_URL BASEURL_HTTPS@"/api/appManage/appUpdate?app=2&type=1"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


#endif
