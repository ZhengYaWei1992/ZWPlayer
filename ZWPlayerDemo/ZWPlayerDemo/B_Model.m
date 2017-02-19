//
//  B_Model.m
//  iOS-rotate-demo
//
//  Created by 郑亚伟 on 16/10/20.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "B_Model.h"


@implementation B_Model
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //转换系统关键字
    if ([key isEqualToString:@"description"]) {
        self.video_description = [NSString stringWithFormat:@"%@",value];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"playInfo"]) {
        self.playInfo = @[].mutableCopy;
        NSMutableArray *array = @[].mutableCopy;
        
        [self.playInfo removeAllObjects];
        [self.playInfo addObjectsFromArray:array];
    } else if ([key isEqualToString:@"title"]) {
        self.title = value;
    } else if ([key isEqualToString:@"playUrl"]) {
        self.playUrl = value;
    } else if ([key isEqualToString:@"coverForFeed"]) {
        self.coverForFeed = value;
    }else if ([key isEqualToString:@"isPlaying"])
        self.isPlaying = NO;
}
@end
