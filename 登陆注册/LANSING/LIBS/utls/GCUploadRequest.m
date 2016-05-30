//
//  GCUploadRequest.m
//  dreamWorks
//
//  Created by dreamRen on 13-7-6.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import "GCUploadRequest.h"
#import <QuartzCore/QuartzCore.h>

@implementation GCUploadRequest

@synthesize delegate;
@synthesize tag,isRequest;

-(void)finishFHL{
    if (mFHLView) {
        [mFHLView removeFromSuperview];
        mFHLView=nil;
    }
}

-(void)loadFHL:(UIView*)aView{
    [self finishFHL];
    
    mFHLView=[[UIView alloc] initWithFrame:aView.bounds];
    mFHLView.backgroundColor = [UIColor clearColor];
    [aView addSubview:mFHLView];
    [mFHLView release];
    
    UIView *tView=[[UIView alloc] initWithFrame:CGRectMake((mFHLView.frame.size.width-50)/2, (mFHLView.frame.size.height-50)/2, 50, 50)];
    //    tView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    tView.backgroundColor=[UIColor clearColor];
    tView.layer.cornerRadius = 6;
    tView.layer.masksToBounds = YES;
    [mFHLView addSubview:tView];
    [tView release];
    
    UIActivityIndicatorView *tActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    tActView.frame = CGRectMake((mFHLView.frame.size.width-37)/2, (mFHLView.frame.size.height-37)/2, 37, 37);
    [mFHLView addSubview:tActView];
    [tActView release];
    [tActView startAnimating];
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"GC code == %d ,message == %@",request.responseStatusCode,request.responseStatusMessage);
    if (request.responseStatusCode == 404) {
        [request clearDelegatesAndCancel];
        
        [self finishFHL];
        isRequest=NO;
        
        if (delegate && [delegate respondsToSelector:@selector(GCUpload:Error:)]) {
            [delegate performSelector:@selector(GCUpload:Error:) withObject:self withObject:@""];
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *tEndString=[[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"GC requestFinished --- %@",tEndString);
    [self finishFHL];
    isRequest=NO;
    if (delegate && [delegate respondsToSelector:@selector(GCUpload:Finished:)]) {
        [delegate performSelector:@selector(GCUpload:Finished:) withObject:self withObject:tEndString];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"GC requestFailed xxxxxx ---- %@",request.error);
    [self finishFHL];
    isRequest=NO;
    if (delegate && [delegate respondsToSelector:@selector(GCUpload:Error:)]) {
        [delegate performSelector:@selector(GCUpload:Error:) withObject:self withObject:@""];
    }
}

-(void)uploadWithHttp:(NSString*)aHttpString infoDict:(NSDictionary*)aDict filePath:(NSString*)aPath withFHLView:(UIView*)aView{
    if (isRequest) {
        [mRequest clearDelegatesAndCancel];
        isRequest=NO;
    }
    
    if (aView) {
        [self loadFHL:aView];
    }
    
    isRequest=YES;
    
    mRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[aHttpString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    mRequest.timeOutSeconds=60;
    mRequest.delegate=self;
    mRequest.requestMethod=@"POST";
    [mRequest setFile:aPath forKey:@"picture"];
    if (aDict != nil) {
        for(NSString *key in aDict){
            id value = [aDict objectForKey:key];
            [mRequest setPostValue:value forKey:key];
        }
    }
    
//    [mRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [mRequest startAsynchronous];
    
    NSLog(@"%@",aHttpString);
    NSLog(@"%@",aDict);
}

-(void)uploadWithHttp:(NSString*)aHttpString infoDict:(NSDictionary*)aDict filePath:(NSString*)aPath{
    [self uploadWithHttp:aHttpString infoDict:aDict filePath:aPath withFHLView:nil];
}

-(void)uploadWithHttp:(NSString*)aHttpString filePath:(NSString*)aPath{
    [self uploadWithHttp:aHttpString infoDict:nil filePath:aPath withFHLView:nil];
}
-(void)uploadWithHttp:(NSString*)aHttpString filePath:(NSString*)aPath withFHLView:(UIView*)aView{
    [self uploadWithHttp:aHttpString infoDict:nil filePath:aPath withFHLView:aView];
}

-(void)cancelRequest{
    if (isRequest) {
        [mRequest clearDelegatesAndCancel];
        isRequest=NO;
        [self finishFHL];
    }
}

-(id)init{
    self=[super init];
    if (self) {
        isRequest=NO;
    }
    return self;
}

-(void)dealloc{
    if (isRequest) {
        [mRequest clearDelegatesAndCancel];
    }
    [delegate release];
    [super dealloc];
}

@end
