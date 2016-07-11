//
//  ActivityTableViewController.m
//  LessonDouBan
//
//  Created by lanou3g on 16/7/2.
//  Copyright © 2016年 yu. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "FileDataHandle.h"
#import "DataBaseHandle.h"
#import "ActivityCollectTableViewCell.h"
#import "ActivityModel.h"
#import "ActivityDetailViewController.h"



@interface ActivityTableViewController ()

@property (strong,nonatomic) NSMutableArray *arr;

@property (strong,nonatomic) DataBaseHandle *db;

@end

static NSString *ActivityCell = @"ActivityCell";

@implementation ActivityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.arr = [NSMutableArray array];
//    self.db = [DataBaseHandle shareInstance];
//    self.arr = [self.db selectAllActivity];
//    NSLog(@"+++++++++++%ld",self.arr.count);
    [self.tableView registerClass:[ActivityCollectTableViewCell class] forCellReuseIdentifier:ActivityCell];
    
        
    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.arr = [NSMutableArray array];
    self.db = [DataBaseHandle shareInstance];
    self.arr = [self.db selectAllActivity];
    [self.tableView reloadData];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"========%ld",self.arr.count);
    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityCell forIndexPath:indexPath];
    
    cell.textLabel.text = ((ActivityModel *)self.arr[indexPath.row]).title;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ActivityDetailViewController *RVC = [mainSB instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
    RVC.model = self.arr[indexPath.row];
    [self.navigationController pushViewController:RVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
