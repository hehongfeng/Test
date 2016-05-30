//
//  JYViewController.h
//  dreamWorks
//
//  Created by dreamRen on 13-6-27.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCRequest.h"
@class FXLabel;

typedef enum{
	Cai = 0,
	Zhan,
	Love,
    Other1,
    isCaiZhan,
} RequestType;

@interface JYViewController : UIViewController<GCRequestDelegate>{
    FXLabel *topTitleLabel;
    GCRequest *mainRequest;
    UIView *mainView;
    UIActivityIndicatorView *tActView;
}
-(void)showActivity;
-(void)hideActivity;
@end
