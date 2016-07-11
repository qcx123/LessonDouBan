//
//  MovieDetialViewController.m
//  LessonDouBan
//
//  Created by lanou3g on 16/6/30.
//  Copyright © 2016年 yu. All rights reserved.
//

#import "MovieDetialViewController.h"
#import "MovieDetailRequest.h"
#import "MovieDetialModel.h"
#import "UIImageView+WebCache.h"
#import "DataBaseHandle.h"

@interface MovieDetialViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;

@property (weak, nonatomic) IBOutlet UILabel *scoreAndWishLabel;

@property (weak, nonatomic) IBOutlet UILabel *pubdateLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationsLabel;

@property (weak, nonatomic) IBOutlet UILabel *genresLabel;

@property (weak, nonatomic) IBOutlet UILabel *countriesLabel;

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (strong, nonatomic)MovieDetialModel *model;

@end

@implementation MovieDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[MovieDetialModel alloc] init];
    [self requestMovieDetailDataWith:self.movie.ID];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    
}

// 电影详情
- (void)requestMovieDetailDataWith:(NSString *)ID {
    
    MovieDetailRequest *request =  [[MovieDetailRequest alloc] init];
    [request movieDetailRequestWithParameter:@{@"id":ID} success:^(NSDictionary *dic) {
        //NSLog(@"movie detail success = %@",dic);
        
        [self.model setValuesForKeysWithDictionary:dic];
        NSLog(@"%@",self.model);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUp];
        });
        
        
    } failure:^(NSError *error) {
        NSLog(@"movie detail error = %@",error);
    }];
    
}

- (void)setUp{
    self.title = self.model.title;
    self.scoreAndWishLabel.text = [NSString stringWithFormat:@"评分：%@(%@)",[self.model.rating objectForKey:@"average"],self.model.comments_count];
    self.pubdateLabel.text = self.model.pubdate;
    self.durationsLabel.text = [self getStrFromArray:self.model.durations];
    self.genresLabel.text = [self getStrFromArray:self.model.genres];
    self.countriesLabel.text = [self getStrFromArray:self.model.countries];
    self.summaryLabel.text = self.model.summary;
    [self.movieImageView setImageWithURL:[NSURL URLWithString:[self.model.images objectForKey:@"large"] ]];
    
}

- (NSString *)getStrFromArray:(NSArray *)arr{

    NSMutableString *mStr = [NSMutableString string];
    for (NSString *str in arr) {
        [mStr appendString:str];
    }
    return mStr;
}

- (void)rightAction{

    if ([[DataBaseHandle shareInstance] selectMovieWithId:self.movie.ID]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经收藏，不要重复收藏" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        [[DataBaseHandle shareInstance] insertNewMovie:self.model];
        
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
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
