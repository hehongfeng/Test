//
//  SNParentView.h
//  DrawTextProject
//
//  Created by nsstring on 14-6-4.
//  Copyright (c) 2014年 Sinoglobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNFaceView.h"
#import "SNShareMoreView.h"
//#import "SNSubViewController.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"

@class SNSubViewController;

@protocol ParentViewDelegate ;

@interface SNParentView : UIView
<SNFaceViewDelegate,sahredMoreDelegate,UITextViewDelegate,
IFlyRecognizerViewDelegate,UIGestureRecognizerDelegate>

{
     UIImageView *_inputBar;
     UITextView *_messageView;
    

     UIButton* _btnFace;        //此按钮为切换头像键盘和中英文键盘的切换
     UIButton* _recordBtnVideo; //此按钮为切换录音和键盘
     UIButton * _moreButton;
     SNFaceView * _faceView;
     SNShareMoreView * _moreMoreView;
    
    IFlyRecognizerView *_iflyRecognizerView;
    CGFloat keyboardHeight;

}

-(void)createFaceViewAndMoreView;

//@property ( nonatomic,assign)SNSubViewController * subViewContrl;

@property (nonatomic,assign) id<ParentViewDelegate>parentDelegate;

@end


@protocol ParentViewDelegate <NSObject>

//点击键盘的发送按钮时回条方法
-(void)keyboardClickSendWithText:(NSString*)text;

//点击更多按钮下的按钮的时候回条方法
-(void)clikeMoreButtonSubButtonWithButtonTag:(NSInteger)tag;

//增加parent的frame往上移动
-(void)adjustKeyboardBigFrameHeight:(CGFloat)height;

//parent的frame往下移动
-(void)adjustKeyboardSmallFrameHeight:(CGFloat)height;


@end