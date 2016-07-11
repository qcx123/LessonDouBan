//
//  MyViewController.m
//  LessonDouBan
//
//  Created by lanou3g on 16/6/28.
//  Copyright © 2016年 yu. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "MyHeaderTableViewCell.h"
#import "MyTableViewCell.h"
#import "FileDataHandle.h"
#import "UIImageView+WebCache.h"
#import "ActivityTableViewController.h"
#import "MovieCollectTableViewController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic,strong)NSArray *titles;

@property (strong,nonatomic) UIBarButtonItem *btn;

@property (strong,nonatomic) NSString *userName;

@property (strong,nonatomic) NSString *img;

@property (strong,nonatomic) User *user;

@property (strong,nonatomic) LoginViewController *loginVC;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self addRightNavigateionItem];
    
    // 跳转到登录界面
    // 获取当前storyboard
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    // 获取登录界面
    self.loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    self.btn = [[UIBarButtonItem alloc] initWithTitle:[[FileDataHandle shareInstance] loginState] ? @"注销" : @"登录" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = self.btn;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MyHeaderTableViewCell_Identify];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MyTableViewCell_1];
    
    self.titles = @[@"我的活动",@"我的电影",@"清除缓存"];
    
    if ([[FileDataHandle shareInstance] loginState]) {
        self.user = [[User alloc] init];
        self.user.userId = [[FileDataHandle shareInstance] userId];
        self.user.userName = [[FileDataHandle shareInstance] userName];
        self.user.avatar = [[FileDataHandle shareInstance] avatar];
        self.user.password = [[FileDataHandle shareInstance] password];
        self.user.login = YES;
    }
    
    
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    self.img = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    
    
    
    
    
}






- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
    
}

- (void)addRightNavigateionItem{

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:[[FileDataHandle shareInstance] loginState] ? @"注销":@"登录" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
}


- (void)loginFinishedBlock{

    __weak MyViewController *myVC = self;
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    // 获取登录界面
    myVC.loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myVC.loginVC.completion = ^(User *user){
    
        NSLog(@"%@",user.avatar);
        myVC.img = user.avatar;
        _userName = user.userName;
        self.user = user;
        _btn.title = @"注销";
        [self dismissViewControllerAnimated:YES completion:nil];
    
        
    };
    [self presentViewController:self.loginVC animated:YES completion:nil];
}


- (void)rightBarButtonItemClicked:(UIBarButtonItem *)btn{

    if([btn.title isEqualToString:@"登录"]){
        
        [self loginFinishedBlock];
    }else{
    
        //注销
        [[FileDataHandle shareInstance] setUsername:nil];
        [[FileDataHandle shareInstance] setPassword:nil];
        [[FileDataHandle shareInstance] setUserId:nil];
        [[FileDataHandle shareInstance] setAvatar:nil];
        [[FileDataHandle shareInstance] setLoginState:NO];
        self.img = @"picholder.png";
        self.userName = @"未登录";
        btn.title = @"登录";
        [self.myTableView reloadData];
        
    }
}


// 显示缓存
-(float)getFilePath{
    
    //文件管理
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //缓存路径
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    
    NSString *cacheDir = [cachePaths objectAtIndex:0];
    
    NSArray *cacheFileList;
    
    NSEnumerator *cacheEnumerator;
    
    NSString *cacheFilePath;
    
    unsigned long long cacheFolderSize = 0;
    
    cacheFileList = [fileManager subpathsOfDirectoryAtPath:cacheDir error:nil];
    
    cacheEnumerator = [cacheFileList objectEnumerator];
    
    while (cacheFilePath = [cacheEnumerator nextObject]) {
        
        NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:cacheFilePath] error:nil];
        
        cacheFolderSize += [cacheFileAttributes fileSize];
        
    }
    
    //单位MB
    
    return cacheFolderSize/1024/1024;
    
}

// 清除缓存 自己写
- (void)removeCache{

    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    
    NSString *cacheDir = [cachePaths objectAtIndex:0];
    // 清除活动列表和电影列表对应的图片
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:cacheDir error:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row == 3){
    
        [self removeCache];
        [self.myTableView reloadData];
        
    }else if(indexPath.row == 1){
    
        ActivityTableViewController *act = [[ActivityTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
        [self.navigationController pushViewController:act animated:YES];
    }else if(indexPath.row == 2){
    
        MovieCollectTableViewController *MCTVC = [[MovieCollectTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
        [self.navigationController pushViewController:MCTVC animated:YES];
        
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        MyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyHeaderTableViewCell_Identify];
        if ([[FileDataHandle shareInstance] loginState] == YES) {
            cell.user = self.user;
        }else{
            cell.userNameLabel.text = self.userName;
            cell.avatarImageView.image = [UIImage imageNamed:self.img];
        }
        
        return cell;
    }else{
    
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTableViewCell_1];
        cell.contentLabel.text = self.titles[indexPath.row - 1];
        if (indexPath.row == 3) {
            cell.subLabel.text = [NSString stringWithFormat:@"%.1fM",[self getFilePath]];
        }
        return cell;

        
    }
    
    
}


//#pragma mark 清除缓存
//- (void)cleanDownloadImages{
//    // 清除头像图片
//    [[SDImageCache sharedImageCache] cleanDisk];
//    
//    NSString *imageManagerPath = [self downloadImageManagerFilePath];
//    // 清除活动列表和电影列表对应的图片
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:imageManagerPath error:nil];
//    
//    
//}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 184;
    }
    return 40;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
