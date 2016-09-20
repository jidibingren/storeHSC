//
//  HSCMinePhotoAlbumController.m
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCMinePhotoAlbumController.h"

@implementation HSCMinePhotoAlbumController

- (void)viewDidLoad{
    
    self.title = @"";
    
    self.url = HSC_URL_ALBUM_LIST;
    
    self.listPath = @"data";
    
    self.cellClass = [HSCMineAlbumCell class];
    
    self.cellDataClass = [HSCMineAlbumModel class];
    
    self.cellHeight = 165;
    
    [super viewDidLoad];
}

- (void)customizeParams:(NSMutableDictionary *)params newer:(BOOL)newer{
    
    HSCMineAlbumModel *model = self.dataArray.lastObject;
    
    if (newer) {
        model = nil;
    }

    params[@"createTim"] = model ? @(model.createTim) : @(0);
    
}

@end
