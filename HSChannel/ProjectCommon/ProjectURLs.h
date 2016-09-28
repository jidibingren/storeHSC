//
//  ProjectURLs.h
//  Template
//
//  Created by SC on 15/12/28.
//  Copyright (c) 2015年 SC. All rights reserved.
//

#ifndef Template_ProjectURLs_h
#define Template_ProjectURLs_h

//1.1
#define HSC_URL_NOTICE_LIST             BASEURL_HTTPS@"/action/notice/list"
#define HSC_URL_NOTICE_DETAIL           BASEURL_HTTPS@"/action/notice/get"
#define HSC_URL_NOTICE_REPLY            BASEURL_HTTPS@"/action/notice/reply/get"
#define HSC_URL_NOTICE_LIKE             BASEURL_HTTPS@"/action/notice/like"
#define HSC_URL_NOTICE_REPLY_ADD        BASEURL_HTTPS@"/action/notice/reply/add"
#define HSC_URL_NOTICE_REPLY_DEL        BASEURL_HTTPS@"/action/notice/reply/del"
#define HSC_URL_NOTICE_READ             BASEURL_HTTPS@"/action/notice/read"
#define HSC_URL_CONTRACTS_LIST          BASEURL_HTTPS@"/action/contracts/list"

//2.1
#define HSC_URL_SCHOOL_INFO_GET         BASEURL_HTTPS@"/action/school/info/get"
#define HSC_URL_SCHOOL_PROFILE          [Utils fileURLAbsoluteString:@"assets/apps/famSchool/pages/schoolIntroduce.html"]
#define HSC_URL_SCHOOL_NOTICE_LIST      BASEURL_HTTPS@"/action/notice/school/list"
#define HSC_URL_SCHOOL_NEWS             [Utils fileURLAbsoluteString:@"assets/apps/famSchool/pages/schoolNews.html"]
#define HSC_URL_SCHOOL_TEACHERS_LIST    [Utils fileURLAbsoluteString:@"assets/apps/famSchool/pages/teacher.html"]
#define HSC_URL_SCHOOL_RECIPES_LIST     BASEURL_HTTPS@"/action/school/food/list"
#define HSC_URL_SCHOOL_TRANSCARD_LIST   BASEURL_HTTPS@"/action/school/transCard/list"
#define HSC_URL_SCHOOL_TRANSCARD_ADD    BASEURL_HTTPS@"/action/school/transCard/add"
#define HSC_URL_SCHOOL_TRANSCARD_DEL    BASEURL_HTTPS@"/action/school/transCard/del"

//3.1
#define HSC_URL_CLASS_NOTICE_LIST       BASEURL_HTTPS@"/action/notice/class/list"
#define HSC_URL_CLASS_HOMEWORK_LIST     BASEURL_HTTPS@"/action/notice/homework/list"
#define HSC_URL_CLASS_DYNAMICS_LIST     BASEURL_HTTPS@"/action/notice/classDynamics/list"
#define HSC_URL_CLASS_DYNAMICS_ADD      BASEURL_HTTPS@"/action/notice/classDynamics/add"
#define HSC_URL_CLASS_DYNAMICS_DEL      BASEURL_HTTPS@"/action/notice/classDynamics/del"
#define HSC_URL_WORK_CHECK_LIST         BASEURL_HTTPS@"/action/child/checkOn/list"
#define HSC_URL_WORK_CHECK_TEACHER_LIST BASEURL_HTTPS@"/action/child/checkOn/teacher/list"
#define HSC_URL_PARENT_LEAVE            BASEURL_HTTPS@"/action/parent/leave"
#define HSC_URL_CLASS_NOTICE_ADD        BASEURL_HTTPS@"/action/notice/class/add"
#define HSC_URL_CLASS_NOTICE_DEL        BASEURL_HTTPS@"/action/notice/class/del"
#define HSC_URL_HOMEWORK_ADD            BASEURL_HTTPS@"/action/notice/homework/add"
#define HSC_URL_HOMEWORK_DEL            BASEURL_HTTPS@"/action/notice/homework/del"

//4.1
#define HSC_URL_USER_LOGIN              BASEURL_HTTPS@"/action/user/login/byPassword"
#define HSC_URL_USER_INFO               BASEURL_HTTPS@"/action/user/info"
#define HSC_URL_USER_AVATOR_UPLOAD      BASEURL_HTTPS@"/action/user/avator/upload"
#define HSC_URL_CHILD_INFO_MODIFY       BASEURL_HTTPS@"/action/child/info/modify"
#define HSC_URL_ALBUM_LIST              BASEURL_HTTPS@"/action/album/list"
#define HSC_URL_PARENT_LEAVE_LIST       BASEURL_HTTPS@"/action/parent/leave/list"
#define HSC_URL_SUGGEST_ADD             BASEURL_HTTPS@"/action/suggest/add"

//5.1
#define HSC_URL_CLASSROOM               @"http://jinyouapp.com/app/jiaxiaotong/m/index.php"



//18	应用的版本
#define HSC_URL_ADMIN_VERSION           BASEURL_HTTPS@"/action/admin/version"

#endif
