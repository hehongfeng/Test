//
//  SNFaceView.h
//  DrawTextProject
//
//  Created by nsstring on 14-5-27.
//  Copyright (c) 2014年 Sinoglobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol SNFaceViewDelegate;

@interface SNFaceView : UIView

//代理方法
@property (nonatomic,assign)id<SNFaceViewDelegate>faceDelegate;
@end

@protocol SNFaceViewDelegate <NSObject>

//获取对于表情的设置的标记的字符串
-(void)faceViewFromfaceImage:(NSString*)faceStr;

//表情键盘的右下角的删除按钮的点击事件方法
-(void)faceViewFromCancel:(UIButton*)sender;


@end