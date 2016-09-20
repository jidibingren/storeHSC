//
//  SCDBTableViewController.h
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface SCDBTableViewController : SCTableViewController

// overwrite
- (NSString *)findSQL:(BOOL)newer;

@end
