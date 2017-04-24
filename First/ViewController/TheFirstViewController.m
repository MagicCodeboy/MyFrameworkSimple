//
//  TheFirstViewController.m
//  MyFramework
//
//  Created by lalala on 2017/4/6.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "TheFirstViewController.h"
#import "SHNetworking.h"
@interface TheFirstViewController ()

@end

@implementation TheFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationTitle:@"第一个"];
    [self requestData];
}
-(void)requestData{
    [SHNetworkingManager getNetworkRequestWithUrlString:@"/v1/cook/category/query" parameters:@{@"key":@"520520test",@"city":@"南京",@"province":@"江苏"} isCache:NO succeed:^(id data) {
        NSLog(@"首页标题数据%@",data);
    } fialed:^(NSString *error) {
        
    }];
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
