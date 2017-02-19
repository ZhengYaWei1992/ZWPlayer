//
//  B_TableViewCell.m
//  iOS-rotate-demo
//
//  Created by 郑亚伟 on 16/10/20.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "B_TableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation B_TableViewCell

- (void)awakeFromNib {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _picView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10, 180)];
        [self.contentView addSubview:_picView];
        _picView.userInteractionEnabled = YES;
        
        
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
        //[self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [self.picView addSubview:self.playBtn];
        self.playBtn.frame = CGRectMake(0, 0, 60, 60);
        self.playBtn.center = self.picView.center;
    }
    return self;
}

- (void)setModel:(B_Model *)model{
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
}

//- (void)play:(UIButton *)sender {
//    if (self.playBlock) {
//        self.playBlock(sender);
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
