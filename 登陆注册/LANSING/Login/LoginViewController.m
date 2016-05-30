//
//  LoginViewController.m
//  LANSING
//
//  Created by nsstring on 15/5/27.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteredViewController.h"
#import "ShouRegisterdViewController.h"
#import "AmendPassViewController.h"
#import "InstructionsViewController.h"
#import "LoginPublicObject.h"
#import "PromptView.h"

@interface LoginViewController ()<UITextFieldDelegate,PromptViewDelegate>{
    PromptView *promptView;
}
/*用户名*/
@property (strong, nonatomic) IBOutlet UIView *userView;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;

/*密码*/
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextield;

/*登陆*/
@property (strong, nonatomic) IBOutlet UIButton *landingButton;

/*注册*/
@property (strong, nonatomic) IBOutlet UIButton *registeredButton;
@property (strong, nonatomic) IBOutlet UIButton *onRegisteredButton;

/*了解通行证*/
@property (strong, nonatomic) IBOutlet UILabel *passLabel;

/*忘记密码*/
@property (strong, nonatomic) IBOutlet UILabel *forgetLabel;

/*无密码快递登陆*/
@property (strong, nonatomic) IBOutlet UILabel *fastLabel;

//判断密文
@property (strong, nonatomic) NSString    *SignString;


@property (strong, nonatomic) LoginPublicObject *LPobject;

@end

@implementation LoginViewController

@synthesize userView;
@synthesize passwordView;
@synthesize landingButton;
@synthesize registeredButton;
@synthesize userTextField;
@synthesize passwordTextield;
@synthesize onRegisteredButton;
@synthesize forgetLabel;
@synthesize fastLabel;
@synthesize passLabel;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [titleButton setTitle:@"登录" forState:UIControlStateNormal];
    [backView addSubview:onRegisteredButton];
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    [keyBoardController addToolbarToKeyboard];
    userTextField.delegate = self;
    passwordTextield.delegate = self;
    
    promptView = [PromptView Instance];
    promptView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    promptView.delegate = self;
    promptView.logInToRegisterLabel.text = @"登录成功";
    promptView.InTheFormOfInt = 1;
    [promptView draw];
    promptView.hidden = YES;
    promptView.frame = self.view.bounds;
    [self.view addSubview:promptView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [keyBoardController removeKeyBoardNotification];
    keyBoardController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    forgetLabel.userInteractionEnabled = YES;
    [forgetLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassword)]];
    
    fastLabel.userInteractionEnabled = YES;
    [fastLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fastPassword)]];
    
    passLabel.userInteractionEnabled = YES;
    [passLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(understandTheCignaPass)]];

    /*阴影和倒角*/
    userView.layer.shadowRadius = 1;
    userView.layer.shadowOpacity = 0.4f;
    userView.layer.shadowOffset = CGSizeMake(0, 0);
    userView.layer.cornerRadius = 5;
    
    passwordView.layer.shadowRadius = 1;
    passwordView.layer.shadowOpacity = 0.4f;
    passwordView.layer.shadowOffset = CGSizeMake(0, 0);
    passwordView.layer.cornerRadius = 5;
    
    landingButton.layer.shadowRadius = 1;
    landingButton.layer.shadowOpacity = 0.2f;
    landingButton.layer.shadowOffset = CGSizeMake(0, 0);
    landingButton.layer.cornerRadius = 5;
    
    registeredButton.layer.shadowRadius = 1;
    registeredButton.layer.shadowOpacity = 0.4f;
    registeredButton.layer.shadowOffset = CGSizeMake(0, 0);
    registeredButton.layer.cornerRadius = 5;
    
    /*回收键盘*/
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolbarButtonTap)];
    [self.view addGestureRecognizer:tap1];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark - TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([GCUtil isMobileNumber:userTextField.text] != 0&&passwordTextield.text.length >= 6&&passwordTextield.text.length <= 20) {
        [landingButton setBackgroundColor:RGBACOLOR(37, 182, 177, 1)];
    }else{
        [landingButton setBackgroundColor:RGBACOLOR(195, 195, 195, 1)];
    }
    
    _SignString = @"";
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{


    _SignString = @"";
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    NSString *passwordText = textField == passwordTextield?toBeString:passwordTextield.text;
    
    if (userTextField == textField) {
        if (toBeString.length > 11) {
            //            [self showMsg:@"手机号码不能超过11位!"];
            return NO;
        }
    }
    
    if ([textField isEqual:passwordTextield]) {
        
        
        _SignString = [_SignString stringByAppendingString:string];;
        
        NSLog(@"_SignString ==  %@",_SignString);
    }
    
    if ([GCUtil isMobileNumber:textField == userTextField?toBeString:userTextField.text] != 0&&passwordText.length >= 6&&passwordText.length <= 20 && _SignString.length >= 6 ) {
        [landingButton setBackgroundColor:RGBACOLOR(37, 182, 177, 1)];
        landingButton.userInteractionEnabled = YES;
    }else{
        [landingButton setBackgroundColor:RGBACOLOR(195, 195, 195, 1)];
        landingButton.userInteractionEnabled = NO;
    }
    //    NSLog(@"-------:%@",toBeString);
    return YES;
}

/*了解通行证*/
-(void)understandTheCignaPass{
    //    账号说明
    InstructionsViewController *instructions = [[InstructionsViewController alloc]init];
    instructions.entranceInt = 1;
    instructions.typeInt = 2;
    [self.navigationController pushViewController:instructions animated:YES];
}

/*键盘回收*/
-(void)toolbarButtonTap{
    [userTextField resignFirstResponder];
    [passwordTextield resignFirstResponder];
}

/*注册*/
- (IBAction)UserRegistration:(id)sender {
    ShouRegisterdViewController *registered = [[ShouRegisterdViewController alloc]init];
    registered.interfaceInt = 1;
    [self.navigationController pushViewController:registered animated:YES];
}

/*忘记密码*/
-(void)forgotPassword{
    ShouRegisterdViewController *registered = [[ShouRegisterdViewController alloc]init];
    registered.interfaceInt = 3;
    [self.navigationController pushViewController:registered animated:YES];
}

/*登陆*/
- (IBAction)landingBut:(id)sender {
    [userTextField resignFirstResponder];
    [passwordTextield resignFirstResponder];
    if ([GCUtil isMobileNumber:userTextField.text] == 0) {
        [self showMsg:@"请输入正确的电话号码"];
        return;
    }else if ([GCUtil convertToInt:passwordTextield.text] < 6||[GCUtil convertToInt:passwordTextield.text] > 20){
        [self showMsg:@"请输入6-20位数字，英文字母或符号组合"];
        return;
    }else{
        mainRequest.tag = 100;
        [mainRequest requestHttpWithPost:[NSString stringWithFormat:@"%@login/",ADDRESS] withDict:[LogInAPP loginUserName:userTextField.text andpwd:passwordTextield.text]];
    }
}

/*无密码快速登陆*/
-(void)fastPassword{
    ShouRegisterdViewController *registered = [[ShouRegisterdViewController alloc]init];
    registered.interfaceInt = 2;
    [self.navigationController pushViewController:registered animated:YES];
}

//返回按钮
-(void)backButtonClick{
    [self chooseSkip:1];
}

#pragma mark -
#pragma mark - 登陆成功提示返回

-(void)chooseSkip:(int)skipInt{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)chooseToUnderstand:(int)understandInt{
    //    账号说明
    InstructionsViewController *instructions = [[InstructionsViewController alloc]init];
    instructions.entranceInt = 2;
    instructions.typeInt = 2;
    [self.navigationController pushViewController:instructions animated:YES];
}

-(void)GCRequest:(GCRequest*)aRequest Finished:(NSString*)aString
{
    aString = [aString stringByReplacingOccurrencesOfString:@"null"withString:@"\"\""];
    NSMutableDictionary *dict=[aString JSONValue];
    NSLog(@"22==%@",dict);
    if (dict) {
        if ([[dict objectForKey:@"code"] intValue] == 1) {
            if (aRequest.tag == 100) {
                NSDictionary *resultDic = (NSDictionary *)[dict objectForKey:@"result"];
                [SaveMessage saveUserMessageJava:resultDic];
//                [SaveMessage saveUserMessage:resultDic];
//                lolinPublic.logInDic = resultDic;
                if (APPLICATION == 1) {
                    //                    [self showMsg:@"登陆成功"];
                    //                    lolinPublic.logInPHPDic = dict;
                    promptView.InTheFormOfInt = 1;
                    promptView.hidden = NO;
                }else{
                    mainRequest.tag = 101;
                    [mainRequest requestHttpWithPost:[NSString stringWithFormat:@"%@",ADDRESSPHP] withDict:[LogInAPP accessToLoginInformationUserId:[resultDic objectForKey:@"id"] userName:[resultDic objectForKey:@"userName"] sex:[resultDic objectForKey:@"sex"] nickName:[resultDic objectForKey:@"nickname"] src:[resultDic objectForKey:@"src"] jifen:@"0"status:[resultDic objectForKey:@"status"] lat:IfNullToString(_LPobject.stringLat) ing:IfNullToString(_LPobject.stringIng) token:IfNullToString(_LPobject.stringToken)]];
                }
            }else if (aRequest.tag == 101){
                [SaveMessage saveUserMessagePHP:dict];
                promptView.InTheFormOfInt = 1;
                promptView.hidden = NO;
//                [self showMsg:@"登陆成功"];
            }
        }else{
            switch ([[dict objectForKey:@"code"] intValue]) {
                case 100:{
                    [self showMsg:@"用户名不存在!"];
                    break;
                }
                case 102:{
                    [self showMsg:@"密码错误!"];
                    break;
                }
                case 103:{
                    [self showMsg:@"没有登录平台权限!"];
                    break;
                }
                case 203:{
                    [self showMsg:@"系统异常!"];
                    break;
                }
                case 2:{
                    [self showMsg:@"用户锁定!"];
                    break;
                }
                
                default:{
                    [self showMsg:[dict objectForKey:@"message"]];
                    break;
                }
            }
        }
    }else{
        [self showMsg:@"服务器去月球了!"];
    }
    
}

-(void)GCRequest:(GCRequest*)aRequest Error:(NSString*)aError
{
    [self showMsg:@"网络原因!"];
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
