//
//  B_Model.h
//  iOS-rotate-demo
//
//  Created by 郑亚伟 on 16/10/20.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B_Model : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *title;
/** 描述 */
@property (nonatomic, copy  ) NSString *video_description;
/** 视频地址 */
@property (nonatomic, copy  ) NSString *playUrl;
/** 封面图 */
@property (nonatomic, copy  ) NSString *coverForFeed;
/** 视频分辨率的数组 */
@property (nonatomic, strong) NSMutableArray *playInfo;

@property(nonatomic,assign)BOOL isPlaying;

@end
