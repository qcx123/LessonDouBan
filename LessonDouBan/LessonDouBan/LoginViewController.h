//
//  LoginViewController.h
//  LessonDouBan
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface LoginViewController : UIViewController

// 完成登录要实现的回调
@property (copy,nonatomic) void(^completion)(User *user);

@end
