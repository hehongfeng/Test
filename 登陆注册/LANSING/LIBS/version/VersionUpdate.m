 //
//  VersionUpdate.m
//  B_shezhi
//
//  Created by xn on 14-9-24.
//  Copyright (c) 2014年 pipixia. All rights reserved.
//

#import "VersionUpdate.h"
#import "JSON.h"

@implementation VersionUpdate

- (id)init
{
    self = [super init];
    if (self) {
        request = [[GCRequest alloc]init];
        request.delegate=self;
        self.versionUpdateStr = @"";
    }
    return self;
}

//请求版本
- (void)versionUpdateAndAlertViewDelegate:(id<UIAlertViewDelegate>)delegate andFromWhere:(NSString *)from_where
{
    //%@?por=%@&type=1&channel=1&token=%@
    //type=1 ios    2 andr    3 ios_sino
    alertDelegate = delegate;
    fromWhere = from_where;
    request.tag = 510;
//    [request requestHttpWithPost:LEWAN_URL withDict:[BXAPI updateVersion:VERSION_REQUEST_TYPE]];
}

- (void)GCRequest:(GCRequest *)aRequest Finished:(NSString *)aString
{
    if (aString.length > 0) {
        NSDictionary *dict = [aString JSONValue];
        NSLog(@"版本更新 ＝ %@",dict);
        if (dict) {
            if ([dict[@"code"] intValue] == 0) {
                self.versionUpdateStr = dict[@"url"];
                NSString *versionStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"version"]];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setValue:versionStr forKey:@"versionStr"];
                [userDefault synchronize];
                NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
                NSString* versionNum = [infoDict objectForKey:@"CFBundleShortVersionString"];
                NSArray *oldVersionAry = [versionNum componentsSeparatedByString:@"."];
                NSArray *newVersionAry = [[dict objectForKey:@"version"] componentsSeparatedByString:@"."];
                BOOL update = [self isValidateVersionWithOldAry:oldVersionAry withNewAry:newVersionAry];
                if (update) {
                    [self showUpdateAlertView:dict[@"force"]];
                }else {
                    [self showFailUpdateAlertView:@"1"];//没有更新
                }
            }else {
                [self showFailUpdateAlertView:@"0"];//显示失败
            }
        }else {
            [self showFailUpdateAlertView:@"0"];//显示失败
        }
    }
}

- (void)GCRequest:(GCRequest *)aRequest Error:(NSString *)aError
{
    [self showFailUpdateAlertView:@"0"];
}

//判断是否可以更新
- (BOOL)isValidateVersionWithOldAry:(NSArray *)oldVersionAry withNewAry:(NSArray *)newVersionAry
{
    if ([newVersionAry count] > 0) {
        if ([oldVersionAry count] >= [newVersionAry count]) {
            for (int i=0; i<[newVersionAry count]; i++) {
                if ([[newVersionAry objectAtIndex:i] intValue] > [[oldVersionAry objectAtIndex:i] intValue]) {
                    //update
                    return YES;
                }else if ([[newVersionAry objectAtIndex:i] intValue] == [[oldVersionAry objectAtIndex:i] intValue]) {
                    //jixu
                }else {
                    return NO;
                }
            }
        }else {
            //新版本个数多
            for (int i=0; i<[oldVersionAry count]; i++) {
                if ([[newVersionAry objectAtIndex:i] intValue] > [[oldVersionAry objectAtIndex:i] intValue]) {
                    //update
                    return YES;
                }else if ([[newVersionAry objectAtIndex:i] intValue] == [[oldVersionAry objectAtIndex:i] intValue]) {
                    //jixu
                    if (i == [oldVersionAry count]-1) {
                        //update
                        return YES;
                    }
                }else {
                    return NO;
                }
            }
        }
    }
    return NO;
}

//弹出框提示
- (void)showUpdateAlertView:(id)object
{
    if ([object intValue] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"升级提醒" message:@"有新版本需要更新吗?" delegate:alertDelegate cancelButtonTitle:@"更新" otherButtonTitles:@"暂不更新", nil];
        alertView.tag = 369;
        [alertView show];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"升级提醒" message:@"有新版本需要更新（重要）" delegate:alertDelegate cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
        alertView.tag = 369;
        [alertView show];
    }
}

//检查版本更新失败
- (void)showFailUpdateAlertView:(NSString *)show_type
{
    if ([fromWhere isEqualToString:@"1"]) {
        if ([show_type isEqualToString:@"0"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检查版本更新失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else {
           
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
           
        }
    }
}

//去掉请求
- (void)cancelUpdateRequest
{
    [request cancelRequest];
}
@end
