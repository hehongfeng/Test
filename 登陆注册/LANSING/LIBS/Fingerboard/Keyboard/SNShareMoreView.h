//
//  SNShareMoreView.h
//  DrawTextProject
//
//  Created by nsstring on 14-5-30.
//  Copyright (c) 2014年 Sinoglobal. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加更多功能的代理
@protocol sahredMoreDelegate;



@interface SNShareMoreView : UIView

@property (nonatomic,strong)NSMutableDictionary * moreDict; //

@property (nonatomic,assign)id<sahredMoreDelegate>moreDelegate;
@end

@protocol sahredMoreDelegate <NSObject>

//点击对用的按钮 调用的方法
-(void)moreView:(SNShareMoreView*)moreView selectedmoreBtn:(UIButton*)moreBtn;


@end