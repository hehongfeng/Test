//
//  GCUploadRequest.h
//  dreamWorks
//
//  Created by dreamRen on 13-7-6.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol GCUploadDelegate;

@interface GCUploadRequest : NSObject<ASIHTTPRequestDelegate>{
    id <GCUploadDelegate> delegate;
    ASIFormDataRequest *mRequest;
    
    BOOL isRequest;
    NSUInteger tag;
    
    UIView *mFHLView;
}

@property(nonatomic,retain) id <GCUploadDelegate> delegate;
@property(assign)NSUInteger tag;
@property(assign)BOOL isRequest;

//发起post请求
-(void)uploadWithHttp:(NSString*)aHttpString filePath:(NSString*)aPath;
-(void)uploadWithHttp:(NSString*)aHttpString filePath:(NSString*)aPath withFHLView:(UIView*)aView;
//发起post请求
-(void)uploadWithHttp:(NSString*)aHttpString infoDict:(NSDictionary*)aDict filePath:(NSString*)aPath;
-(void)uploadWithHttp:(NSString*)aHttpString infoDict:(NSDictionary*)aDict filePath:(NSString*)aPath withFHLView:(UIView*)aView;

-(void)cancelRequest;

@end

@protocol GCUploadDelegate <NSObject>

@optional

-(void)GCUpload:(GCUploadRequest*)aRequest Finished:(NSString*)aString;
-(void)GCUpload:(GCUploadRequest*)aRequest Error:(NSString*)aError;

@end
