//
//  B_TableViewCell.h
//  iOS-rotate-demo
//
//  Created by 郑亚伟 on 16/10/20.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B_Model.h"

typedef void(^PlayBtnCallBackBlock)(UIButton *);

@interface B_TableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *playBtn;
@property(nonatomic) B_Model *model;
@property (strong, nonatomic)UIImageView *picView;
//@property (nonatomic, copy  ) PlayBtnCallBackBlock playBlock;


@end
