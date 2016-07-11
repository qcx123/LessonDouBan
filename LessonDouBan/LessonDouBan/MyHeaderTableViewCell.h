//
//  MyHeaderTableViewCell.h
//  LessonDouBan
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

// 重用标识符
#define MyHeaderTableViewCell_Identify @"MyHeaderTableViewCell_Identify"
@interface MyHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong,nonatomic) User *user;


@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
