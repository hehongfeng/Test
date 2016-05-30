//
//  ZHShouYeViewController.m
//  LANSING
//
//  Created by nsstring on 15/6/9.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "ZHShouYeViewController.h"
#import "AmendPassViewController.h"
#import "LoginPublicObject.h"
#import "LoginViewController.h"
#import "NavViewController.h"

@interface ZHShouYeViewController ()

@end

@implementation ZHShouYeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    returnButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//登陆
- (IBAction)denglu:(id)sender {
    LoginViewController *loginPublic = [[LoginViewController alloc]init];
    NavViewController *logNav = [[NavViewController alloc]initWithRootViewController:loginPublic];
    [self presentViewController:logNav animated:YES completion:nil];
}

//修改密码
- (IBAction)xiuGaiMiMa:(id)sender {
    NSDictionary *dic = APPLICATION == 1?kkNickDicJava:kkNickDicPHP;
    if ([[dic objectForKey:@"id"] intValue] < 2) {
        LoginViewController *loginPublic = [[LoginViewController alloc]init];
        NavViewController *logNav = [[NavViewController alloc]initWithRootViewController:loginPublic];
        [self presentViewController:logNav animated:YES completion:nil];
    }else{
    //    修改密码页
    AmendPassViewController *amendPass = [[AmendPassViewController alloc]init];
    [self.navigationController pushViewController:amendPass animated:YES];
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
