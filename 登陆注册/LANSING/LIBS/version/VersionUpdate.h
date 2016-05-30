//
//  VersionUpdate.h
//  B_shezhi
//
//  Created by xn on 14-9-24.
//  Copyright (c) 2014年 pipixia. All rights reserved.
//

//  使用说明：在使用的类里面 添加UIAlertViewDelegate 代理，并实现方法直接粘贴复制即可
/*
 用法一：
    VersionUpdate *update = [[VersionUpdate alloc]init];
    [update versionUpdateAndAlertViewDelegate:self];
 
 用法二：
    //在离开界面的时候停止请求，防止在请求过程中离开界面而请求持续
    if (_versionUpdate) {
        [_versionUpdate cancelUpdateRequest];
    }
    MRC：
        [_versionUpdate release];
    初始化：
    if (!_versionUpdate) {
        _versionUpdate = [[VersionUpdate alloc]init];
    }
    [_versionUpdate versionUpdateAndAlertViewDelegate:self];
 
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
    if (alertView.tag == 369) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_DOWN_ADDRESS]];
        }
    }
 }
 */

//添加一个测试使用的服务器地址
//#define TEMP_REQUEST_URL @"http://192.168.10.56:91/app/"

////AppStore 下载地址       
#define APP_DOWN_ADDRESS @"https://itunes.apple.com/us/app/le-wan-hu-dong/id909195375?l=zh&ls=1&mt=8"
#define VERSION_REQUEST_TYPE @"1" // @"ios"

//SINO 下载地址
//#define APP_DOWN_ADDRESS @"itms-services:///?action=download-manifest&url=https://lewanqiyesino.sinaapp.com/lw_ios.plist"
//#define VERSION_REQUEST_TYPE @"3"//@"ios_sino"

#import <Foundation/Foundation.h>

@interface VersionUpdate : NSObject <GCRequestDelegate>
{
    id<UIAlertViewDelegate> alertDelegate;
    GCRequest *request;
    NSString *fromWhere;//来自于哪里 0代表appdelegate   1代表settings
}

@property (nonatomic, copy) NSString *versionUpdateStr;

/*
 * 发起版本更新请求
 * 传递UIAlertViewDelegate代理
 */
- (void)versionUpdateAndAlertViewDelegate:(id<UIAlertViewDelegate>)delegate andFromWhere:(NSString *)from_where;

/*
 * 取消版本更新请求
 */
- (void)cancelUpdateRequest;

@end
