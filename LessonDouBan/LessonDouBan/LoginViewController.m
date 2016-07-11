//
//  LoginViewController.m
//  LessonDouBan
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 yu. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginRequest.h"
#import "RegisterViewController.h"
#import "User.h"
#import "FileDataHandle.h"

@interface LoginViewController()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (strong,nonatomic) User *user;
@end


@implementation LoginViewController






- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





- (IBAction)loginAction:(id)sender {
    
    // 登录
    [self login];

}

- (IBAction)registerAction:(id)sender {
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisterViewController *RVC = [mainSB instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:RVC animated:YES completion:nil];
    
}


- (void)login{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"提示" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([alertController.message isEqualToString:@"登陆成功"]) {
            
            if (_completion) {
                _completion(self.user);
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }];
    [alertController addAction:OKAction];
    // 验证 判断用户名密码
    if(self.userNameTextField.text.length == 0){
    
        alertController.message = @"用户名为空";
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (self.passWordTextField.text.length == 0){
    
        alertController.message = @"密码为空";
        
        [self presentViewController:alertController animated:YES completion:nil];

        
    }else{
    
        LoginRequest *loginRequest = [[LoginRequest alloc] init];
        [loginRequest loginRequestWithUserName:_userNameTextField.text passWord:_passWordTextField.text success:^(NSDictionary *dic) {
            NSLog(@"1,%@",dic);
            long code = [[dic objectForKey:@"code"] longValue];
            if (code == 1103) {
                NSString *avatar = [[dic objectForKey:@"data"] objectForKey:@"avatar"];
                NSString *userId = [[dic objectForKey:@"data"] objectForKey:@"userId"];
                // 保存头像和id到本地
                User *user = [[User alloc] init];
                user.userId = userId;
                user.userName = self.userNameTextField.text;
                user.avatar = avatar;
                user.password = self.passWordTextField.text;
                user.login = YES;
                self.user = user;
                [[FileDataHandle shareInstance] setUserId:user.userId];
                [[FileDataHandle shareInstance] setUsername:user.userName];
                [[FileDataHandle shareInstance] setAvatar:user.avatar];
                [[FileDataHandle shareInstance] setPassword:user.password];
                [[FileDataHandle shareInstance] setLoginState:user.login];
                
                
                
                alertController.message = @"登陆成功";
                [self presentViewController:alertController animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            NSLog(@"0,%@",error);
        }];
        
        
        
    }
        
    
    
}


@end
