//
//  SCProjects.m
//  HSChannel
//
//  Created by SC on 16/9/20.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCProjects.h"

@interface SCProjects ()

@property (nonatomic, strong)NSArray *projects;

@end

@implementation SCProjects

IMPLEMENT_SINGLETON();

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setupProjects];
        
    }
    
    return self;
    
}

- (void)setupProjects{
    
    //默认应用
    SCProjectInfo *project1 = [SCProjectInfo new];
    
    project1.type = SCProjectShuXiangYuan;
    
    project1.tabbarTitles = @[@"消息",@"学校",@"班级圈",@"课堂",@"我的"];
    
    project1.tabbarNormalimages = @[@"icon_message_normal",@"icon_school_normal",@"icon_moments_normal",@"icon_class_normal",@"icon_me_normal"];
    
    project1.tabbarSelectedimages = @[@"icon_message_selected",@"icon_school_selected",@"icon_moments_selected",@"icon_class_selected",@"icon_me_selected"];

    project1.images = @{
                            KSCImageMomentsCellCommentBg: @"",
                        };
    
    
    SCProjectInfo *project2 = [SCProjectInfo new];
    
    project2.type = SCProjectHaMi;
    
    project2.tabbarTitles = @[@"消息",@"发布",@"应用",@"我的"];
    
    project2.tabbarNormalimages = @[@"icon_xiaoxi_normal",@"icon_homework_comment@2x",@"icon_yingyong_normal",@"icon_mine_normal"];
    
    project2.tabbarSelectedimages = @[@"icon_xiaoxi_selected",@"icon_message_selected",@"icon_yingyong_selected",@"icon_mine_selected"];
    
    //此项目不同image在此配置
    project2.images = @{
                        KSCImageMineControllerShare:@"icon_mine_share",
                        };
    
    project2.colors = @{
                        
                        };
    
    project2.urls = @{
                      
                      };
    
    _projects = @[project1, project2];
    
    _currentProject = _projects[0];
    
}


- (void)setCurrentProjectByIndex:(NSInteger)index{
    
    _currentProject = _projects[index];
    
}

- (void)resetCurrentProjectByIndex:(NSInteger)index{
    
    _currentProject = _projects[index];
    
    [SCRootViewController resetRootController];
    
}


@end

@implementation UIImage (SC)

+(UIImage *)sc_imageNamed:(NSString *)name{
    
    NSString *realName = [SCProjects sharedInstance].currentProject.images[name];
    
    return [self imageNamed: realName ? realName : name];
    
}

@end
