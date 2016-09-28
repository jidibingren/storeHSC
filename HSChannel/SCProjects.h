//
//  SCProjects.h
//  HSChannel
//
//  Created by SC on 16/9/20.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCProjectInfo.h"

@interface SCProjects : NSObject

DECLARE_SINGLETON();

@property (nonatomic, strong)SCProjectInfo *currentProject;

- (void)setCurrentProjectByIndex:(NSInteger)index;

- (void)resetCurrentProjectByIndex:(NSInteger)index;

@end


@interface UIImage (SC)

+(UIImage *)sc_imageNamed:(NSString *)name;

@end