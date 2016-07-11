//
//  MyHeaderTableViewCell.m
//  LessonDouBan
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 yu. All rights reserved.
//

#import "MyHeaderTableViewCell.h"

@implementation MyHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // 头像切圆角
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width / 2;
}

- (void)setUser:(User *)user{

    _user = user;
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://162.211.125.85",user.avatar]]];
    _userNameLabel.text = user.userName;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
