//
//  GCViewController.m
//  dreamWorks
//
//  Created by dreamRen on 13-6-23.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import "GCViewController.h"
#import "JPCommonMacros.h"
#import "SVProgressHUD.h"
#import "UIImageScale.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UIImageView+WebCache.h"

@interface GCViewController ()<GCRequestDelegate>
 
@end

@implementation GCViewController

#pragma mark -
#pragma mark - 初始化

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaymentFinish" object:nil];
}

//绘制navigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
// 初始化共有类
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBarHidden = YES;
//  标题栏颜色
//    NSDate *stringDate = [ZHColorConversionObject dateString:@"16:00:00"];
//  标题栏ImageView
    backView = [[UIView alloc]init];
    backView.backgroundColor = RGBACOLOR(255.f, 255.f, 255.f, 1);
    backView.frame = CGRectMake(0, 0, 320, 65);
    [self.view addSubview:backView];
    
//  返回按钮
    returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame=CGRectMake(5, 20, 44, 44);
//    [returnButton setImage:[UIImage imageNamed:@"ico_back_s@2x.png"] forState:UIControlStateHighlighted];
    [returnButton setImage:[UIImage imageNamed:@"nav_btn_back_left"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    returnButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:returnButton];
    
//  界面背景View
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    mainView.backgroundColor = RGBACOLOR(241, 241, 241, 1);
    [self.view addSubview:mainView];
    [self.view sendSubviewToBack:mainView];
    
//  标题
    titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundColor:[UIColor clearColor]];
    [titleButton setFrame:(CGRect){(self.view.bounds.size.width/2)-100,30,200,25}];
    [titleButton setTitleColor:RGBACOLOR(0, 0, 0, 1) forState:UIControlStateNormal];
    titleButton.hidden = NO;
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:titleButton];
    mainRequest = [[GCRequest alloc] init];
    mainRequest.delegate = self;
    
//    // 无数据的遮盖层
//    nothingView = [[AppNoDataView alloc] init];
//    nothingView.hidden = YES;
//    [self.view addSubview:nothingView];
    
    
    connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    connectLabel.backgroundColor = RGBACOLOR(226, 225, 232, 1);
    connectLabel.textAlignment = NSTextAlignmentCenter;
    connectLabel.text = @"网络不好哦~";
    connectLabel.font = [UIFont systemFontOfSize:20];
    connectLabel.textColor = [UIColor lightGrayColor];
    connectLabel.hidden = YES;
    [self.view addSubview:connectLabel];
    [self.view bringSubviewToFront:connectLabel];
  
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

#pragma mark -
#pragma mark - 菊花

//返回按钮
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//开启

-(void)chrysanthemumOpen{
    [SVProgressHUD show];
}

//关闭
-(void)chrysanthemumClosed{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//提示框
-(void)showMsg:(NSString *)msg
{
    [SVProgressHUD showErrorWithStatus:msg];
}

//跳转登陆
- (void)showLoginLabel:(NSString *)msg withViewController:(UIViewController *)viewController
{
    viewController.view.userInteractionEnabled = NO;
    if (!_loginShowLabel) {
        _loginShowLabel = [[UILabel alloc]init];
        _loginShowLabel.frame = CGRectMake(120, 220, 80, 40);
        _loginShowLabel.font = [UIFont systemFontOfSize:17];
        _loginShowLabel.backgroundColor = [UIColor blackColor];
        _loginShowLabel.textColor = [UIColor whiteColor];
        _loginShowLabel.textAlignment = NSTextAlignmentCenter;
        _loginShowLabel.numberOfLines = 0;
        _loginShowLabel.layer.masksToBounds = YES;
        _loginShowLabel.layer.cornerRadius = 6;
    }
    CGSize size = [msg sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    _loginShowLabel.frame = CGRectMake((320-size.width-20)/2, 200, size.width+20, size.height+20);
    _loginShowLabel.text = msg;
    
    _tempController = viewController;
    [_tempController.view addSubview:_loginShowLabel];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loginViewAction) userInfo:nil repeats:NO];
}

- (void)loginViewAction{
    _tempController.view.userInteractionEnabled = YES;
    [_loginShowLabel removeFromSuperview];
    
//    LoginViewController *loginViewController = [[LoginViewController alloc] init];
//    ZHNavViewController *loginViewNav = [[ZHNavViewController alloc]initWithRootViewController:loginViewController];
//    [_tempController presentViewController:loginViewNav animated:YES completion:nil];
}


#pragma mark -
#pragma mark -分享
- (void)shareTitle:(NSString *)title withUrl:(NSString *)idStr withContent:(NSString *)content withImageName:(NSString *)imagePath withShareType:(int)shareContentType ImgStr:(NSString *)AimgStr domainName:(NSString *)AdomainName
{
    // 分享标题
    [UMSocialData defaultData].extConfig.qzoneData.title = @"来自天天乐玩APP客户端";//qq空间
    [UMSocialData defaultData].extConfig.qqData.title = @"来自天天乐玩APP客户端";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"来自天天乐玩APP客户端";
//    if (shareContentType != 0) {
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title=@"来自天天乐玩APP客户端";
//
//    }
   
    _shareContentType = shareContentType;
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:nil];
    if(imagePath.length > 0) {
//        imagePath = [NSString stringWithFormat:@"%@%@",IMG_URL,imagePath];
        NSLog(@"shareSDK.image=%@",[NSString stringWithFormat:@"%@",imagePath]);
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imagePath];
    }else {
        
    }
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx08d78379377cc3e8" appSecret:@"f8052085ce493a6c6caf50199b3ef80a" url:idStr];
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1103967875" appKey:@"SOETiOBnRcnlY3Jd" url:idStr];

    NSString *contentTitle = @"";
    if ([content isEqualToString:@""]) {
        contentTitle = @"天天乐玩是最火爆的电视、观众互动神器，多种互动玩法，瞬间收礼收到爆！马上注册天天乐玩，和我一起赢取丰富奖品呦~~。加下载微门户地址（点击进入下载微门户页面，页面上有当前用户的唯一邀请码）。";
    }else{
        //设置分享内容
        contentTitle = [NSString stringWithFormat:@"%@ %@ %@",title,content,idStr];
    }
    UIImage *shareImage;
    if ([AimgStr isEqualToString:@""]) {
        shareImage = [UIImage imageNamed:@"Icon_120x120.png"];
    }else{
        NSURL * imageURL = [NSURL URLWithString:AimgStr];
        NSData * data = [NSData dataWithContentsOfURL:imageURL];
        shareImage = [UIImage imageWithData:data];
    }
    
   

    //设置分享
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54af7075fd98c56baf000770"
                                      shareText:contentTitle
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,nil]
                                       delegate:self];
    
//    GAHomeTabBarController *homeTabBar = [GAHomeTabBarController sharedHomeTabBarController];
//    [homeTabBar hideTabBarAnimated:YES];
    
}


-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{

}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    _isShareLoading = NO;
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [self showMsg:@"分享成功"];
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        NSLog(@"分享成功");
        
        // 需要展示分享数量的界面在这里发送通知~~~~~~~
        //shareContentType 投票首页1 投票详情2  报名详情3 节目首页4 节目详情5  爆料首页6 爆料详情7 活动详情8 资讯详情9 评论分享10  个人足迹分享11  获奖详情分享12 邀请分享13 关于界面的分享14  扫一扫分享15 魔幻拼图分享16
        if (_shareContentType == 6) {//爆料首页
            [self.turnDelegate discloseIndexTurnCount];
        }else if (_shareContentType == 7) {//爆料详情
            [self.turnDelegate discloseDetailTurnCount];
        }
    }else {
        if (response.responseCode == UMSResponseCodeShareRepeated) {
            [self showMsg:@"这条信息您已分享过了"];
        }else if (response.responseCode == UMSResponseCodeCancel) {
            [self showMsg:@"您已取消此次分享"];
        }else {
            [self showMsg:@"分享失败"];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareEndHideTabBar" object:nil];
//    GAHomeTabBarController *homeTabBar = [GAHomeTabBarController sharedHomeTabBarController];
//    [homeTabBar hideTabBarAnimated:YES];
}

@end
