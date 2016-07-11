//
//  ActivityDetailViewController.m
//  LessonDouBan
//
//  Created by lanou3g on 16/6/30.
//  Copyright © 2016年 yu. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityModel.h"
#import "UMSocial.h"
#import "AppDelegate.h"
#import "FileDataHandle.h"
#import "DataBaseHandle.h"
#import "LoginViewController.h"

#define kLabelWidth ([UIScreen mainScreen].bounds.size.width - 32)


@interface ActivityDetailViewController ()<UMSocialDataDelegate,UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;

@property (weak, nonatomic) IBOutlet UILabel *activityIntroduce;





@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    
    self.titleLabel.text = self.model.title;
    self.dateLabel.text = [NSString stringWithFormat:@"%@--%@",self.model.begin_time,self.model.end_time];
    self.userLabel.text = self.model.category_name;
    self.categoryLabel.text = self.model.category_name;
    self.addressLabel.text = self.model.address;
    [self.activityImageView setImageWithURL:[NSURL URLWithString:self.model.image]];
    self.activityIntroduce.text = self.model.content;
    
    CGRect rect = _activityIntroduce.frame;
    rect.size.height = [self.class textHeight:self.model];
    _activityIntroduce.frame = rect;
    //NSLog(@"++++%lf",self.activityIntroduce.frame.size.height);
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:(UIBarButtonItemStylePlain) target:self action:@selector(shareAction)];
    UIBarButtonItem *collectBtn = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:(UIBarButtonItemStylePlain) target:self action:@selector(collectAction)];
    self.navigationItem.rightBarButtonItems = @[shareBtn,collectBtn];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (CGFloat)textHeight:(ActivityModel *)model{

    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(kLabelWidth, 2000) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil];
    //NSLog(@"%lf",rect.size.height);
    return rect.size.height;
}

// 分享
- (void)shareAction{

    //分享gif图片
    NSString *shareText = self.model.title;
    UIImage *img = self.activityImageView.image;
    
    //分享png、jpg图片
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"577620d767e58e9f20002d59" shareText:shareText shareImage:img shareToSnsNames:@[UMShareToSina] delegate:self];
    
    
}

// 收藏
- (void)collectAction{

    if ([[FileDataHandle shareInstance] loginState]) {
        [self collect];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未登陆，请先登陆再做收藏" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            // 获取登录界面
            LoginViewController *loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
        }];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    }

    
}


- (void)collect{

    if ([[DataBaseHandle shareInstance] selectActivityWithID:self.model.ID]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经收藏，不要重复收藏" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
    
        [[DataBaseHandle shareInstance] insertNewActivity:self.model];
        
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
