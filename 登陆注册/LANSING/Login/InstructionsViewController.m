//
//  InstructionsViewController.m
//  LANSING
//
//  Created by nsstring on 15/6/1.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()
//标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

//内容
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation InstructionsViewController
@synthesize typeInt;
@synthesize titleLabel;
@synthesize contentTextView;
@synthesize entranceInt;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [titleButton setTitle:@"账号说明" forState:UIControlStateNormal];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [mainRequest requestHttpWithPost:[NSString stringWithFormat:@"%@getAgreement/",ADDRESS] withDict:[LogInAPP userAgreementType:[NSString stringWithFormat:@"%d",typeInt]]];
    // Do any additional setup after loading the view from its nib.
}

//返回按钮
-(void)backButtonClick{
    if (entranceInt == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (entranceInt == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else if (entranceInt == 3){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)GCRequest:(GCRequest*)aRequest Finished:(NSString*)aString
{
    NSMutableDictionary *dict=[aString JSONValue];
    NSLog(@"22==%@",dict);
    if (dict) {
        if ([[dict objectForKey:@"code"] intValue] == 1) {
            titleLabel.text = [dict objectForKey:@"title"];
            
            // 行间距
            contentTextView.text = [dict objectForKey:@"content"];
            [GCUtil lineSpacingTextView:contentTextView fontInt:11];
            contentTextView.textColor = RGBACOLOR(104, 104, 104, 1);
        }else{
            switch ([[dict objectForKey:@"code"] intValue]) {
                case 0:{
                    [self showMsg:@"获取失败!"];
                    break;
                }
                case 203:{
                    [self showMsg:@"系统异常!"];
                    break;
                }
                default:{
                    [self showMsg:[dict objectForKey:@"message"]];
                    break;
                }
            }
        }
    }
    else
    {
        [self showMsg:@"服务器去月球了!"];
    }
    
}

-(void)GCRequest:(GCRequest*)aRequest Error:(NSString*)aError
{
    [self showMsg:@"服务器去月球了!"];
    
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
