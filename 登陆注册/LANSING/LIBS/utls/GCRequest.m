//
//  GCRequest.m
//  aiGuoShi
//
//  Created by dreamRen on 13-3-19.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import "GCRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "BuGeiLiView.h"
#import "GCUtil.h"

@implementation GCRequest

@synthesize delegate;
@synthesize tag,isRequest;

//是否连网, yes是, no否
-(BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

-(void)showBuGiLiInfo{
    NSUserDefaults *tInfo=[NSUserDefaults standardUserDefaults];
    if ([tInfo objectForKey:@"bugeili"]) {
        return ;
    }
//    UIWindow *tWindow=[UIApplication sharedApplication].keyWindow;
//    BuGeiLiView *tView=[[BuGeiLiView alloc] initWithFrame:tWindow.bounds];
//    [tWindow addSubview:tView];
//    [tView release];
}

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

-(void)beginHttpRequest:(NSString*)aHttpString withMethod:(NSUInteger)aMethod withFHLView:(UIView*)aView{
    NSLog(@"%@",aHttpString);
    if (isRequest) {
        [mRequest clearDelegatesAndCancel];
        isRequest=NO;
    }
    
    if (![self connectedToNetwork]) {
        //网络不通
        [self showBuGiLiInfo];
        return ;
    }
    
    if (aView) {
        [self loadFHL:aView];
    }
    isRequest=YES;
    mRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[aHttpString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    mRequest.timeOutSeconds = 30;
    mRequest.delegate=self;
    if (aMethod == 0) {
        //GET请求
        mRequest.requestMethod=@"GET";
    }else if (aMethod == 1) {
        //POST请求
        mRequest.requestMethod=@"POST";
    }
    
    [mRequest startAsynchronous];
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"GC code == %d ,message == %@",request.responseStatusCode,request.responseStatusMessage);
    if (request.responseStatusCode == 404) {
        [request clearDelegatesAndCancel];
        
        [self finishFHL];
        isRequest=NO;
        
        if (delegate && [delegate respondsToSelector:@selector(GCRequest:Error:)]) {
            [delegate performSelector:@selector(GCRequest:Error:) withObject:self withObject:@""];
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
//    NSLog(@"string --- (%@",request.responseString);
    NSString *tEndString=[[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding] autorelease];
    tEndString = [tEndString stringByReplacingOccurrencesOfString:@"\n" withString:@"\n"];
//    NSLog(@"GC requestFinished --- (%@",tEndString);
    [self finishFHL];
    isRequest=NO;
    if (delegate && [delegate respondsToSelector:@selector(GCRequest:Finished:)]) {
        [delegate performSelector:@selector(GCRequest:Finished:) withObject:self withObject:tEndString];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
//    NSLog(@"GC requestFailed xxxxxx ---- %@",request.error);
    [self finishFHL];
    isRequest=NO;
    if (delegate && [delegate respondsToSelector:@selector(GCRequest:Error:)]) {
        [delegate performSelector:@selector(GCRequest:Error:) withObject:self withObject:@""];
    }
}

//发起get请求
-(void)requestHttpWithGet:(NSString*)aHttpString{
    [self beginHttpRequest:aHttpString withMethod:0 withFHLView:nil];
}

-(void)requestHttpWithGet:(NSString*)aHttpString withFHLView:(UIView*)aView{
    [self beginHttpRequest:aHttpString withMethod:0 withFHLView:aView];
}

//发起post请求
-(void)requestHttpWithPost:(NSString*)aHttpString{
    if (![GCUtil connectedToNetwork]) {
        if (delegate && [delegate respondsToSelector:@selector(GCRequest:Error:)]) {
            [delegate performSelector:@selector(GCRequest:Error:) withObject:self withObject:@""];
        }
    }else{
        [self beginHttpRequest:aHttpString withMethod:1 withFHLView:nil];}
}

-(void)requestHttpWithPost:(NSString*)aHttpString withFHLView:(UIView*)aView{
    [self beginHttpRequest:aHttpString withMethod:1 withFHLView:aView];
}

-(void)requestHttpWithPost:(NSString*)aHttpString withDict:(NSMutableDictionary*)aDict withFHLView:(UIView*)aView{

    if (isRequest) {
        [mRequest clearDelegatesAndCancel];
        isRequest=NO;
    }
    
    if (![self connectedToNetwork]) {
        //网络不通
        
        return ;
    }
    
    if (aView) {
        [self loadFHL:aView];
    }
    
    isRequest=YES;
    mRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[aHttpString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    mRequest.timeOutSeconds=30;
    mRequest.delegate=self;
    mRequest.requestMethod=@"POST";
    if (aDict!=nil) {
        for(NSString *key in aDict){
            id value = [aDict objectForKey:key];
            [mRequest setPostValue:value forKey:key];
        }
    }
//    [mRequest addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:18.0) Gecko/20100101 Firefox/18.0"];
    [mRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [mRequest startAsynchronous];
}

-(void)requestHttpWithPost:(NSString*)aHttpString withDict:(NSMutableDictionary*)aDict{
    if (![GCUtil connectedToNetwork]) {
        if (delegate && [delegate respondsToSelector:@selector(GCRequest:Error:)]) {
            [delegate performSelector:@selector(GCRequest:Error:) withObject:self withObject:@""];
        }
    }else{
        [self requestHttpWithPost:aHttpString withDict:aDict withFHLView:nil];}
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

+(void)requestHttpWithGet:(NSString*)aHttpString{
    NSLog(@"++++++ %@",aHttpString);
    if (![GCUtil connectedToNetwork]) {
        //网络不通
        return ;
    }
    
    ASIFormDataRequest *tRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[aHttpString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    //GET请求
    tRequest.requestMethod=@"GET";
    [tRequest startAsynchronous];
}

@end
