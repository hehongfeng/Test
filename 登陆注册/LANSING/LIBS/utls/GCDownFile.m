//
//  GCDownFile.m
//  dreamWorks
//
//  Created by dreamRen on 13-8-7.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import "GCDownFile.h"

@implementation GCDownFile

@synthesize delegate;
@synthesize isDownloading;

-(NSString*)getDownloadFolderPath{
    return [NSString stringWithFormat:@"%@/download/%@%@",[GCPath getSysDocPath],[mDownDict objectForKey:@"id"],[[mDownDict objectForKey:@"aFileHttp"] lastPathComponent]];
}

-(NSString*)getTempFolderPath{
    return [NSString stringWithFormat:@"%@/downloadtemp/%@%@",[GCPath getSysDocPath],[mDownDict objectForKey:@"id"],[[mDownDict objectForKey:@"aFileHttp"] lastPathComponent]];
}

-(void)cancelDownload{
    if (isDownloading) {
        [mRequest clearDelegatesAndCancel];
        isDownloading=NO;
    }
}

- (void)setProgress:(CGFloat)newProgress{
//    NSLog(@"....... %f",newProgress);
    if (delegate && [delegate respondsToSelector:@selector(GCDownFile:curProgress:)]) {
        [delegate performSelector:@selector(GCDownFile:curProgress:) withObject:mDownDict withObject:[NSNumber numberWithFloat:newProgress]];
    }
}

-(void)beginDownFile:(NSString*)aFileHttp withDownDict:(NSDictionary*)aDict{
    [mDownDict removeAllObjects];
    [mDownDict setValuesForKeysWithDictionary:aDict];
    [mDownDict setObject:aFileHttp forKey:@"aFileHttp"];
    
    NSLog(@"下载 %@",aFileHttp);
    [self cancelDownload];
    
//    if (![self connectedToNetwork]) {
//        //网络不通
//        
//        return ;
//    }
    
    isDownloading=YES;
    
    mRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[aFileHttp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    mRequest.timeOutSeconds=120;
    [mRequest setAllowResumeForFileDownloads:YES];
    [mRequest setDownloadProgressDelegate:self];
    [mRequest setTemporaryFileDownloadPath:[self getTempFolderPath]];
    [mRequest setDownloadDestinationPath:[self getDownloadFolderPath]];
    mRequest.delegate=self;
    
    //    [mRequest addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:18.0) Gecko/20100101 Firefox/18.0"];
    //    [mRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [mRequest startAsynchronous];
}

/*
 responseHeaders
 /////////////
{
    "Accept-Ranges" = bytes;
    Connection = "keep-alive";
    "Content-Length" = 35394281;
    "Content-Type" = "application/octet-stream";
    Date = "Thu, 22 Aug 2013 06:48:32 GMT";
    "Last-Modified" = "Fri, 12 Jul 2013 09:52:48 GMT";
    Server = "nginx/0.8.54";
}
*/
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"GC code == %d ,message == %@",request.responseStatusCode,request.responseStatusMessage);
    NSLog(@"responseHeader %@",responseHeaders);
    if (request.responseStatusCode == 404) {
        [request clearDelegatesAndCancel];
        
        isDownloading=NO;
        
        if (delegate && [delegate respondsToSelector:@selector(GCDownFile:error:)]) {
            [delegate performSelector:@selector(GCDownFile:error:) withObject:mDownDict withObject:@""];
        }
    }else{
        NSString *tSize=[mDownDict objectForKey:@"total_size"];
        if (!tSize || [tSize intValue]<=0) {
            [mDownDict setObject:[responseHeaders objectForKey:@"Content-Length"] forKey:@"total_size"];
            [mDownDict setObject:@"0" forKey:@"download_size"];
            if (delegate && [delegate respondsToSelector:@selector(GCDownFileRefreshInfo:)]) {
                [delegate performSelector:@selector(GCDownFileRefreshInfo:) withObject:mDownDict];
            }
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    //    NSLog(@"string --- (%@",request.responseString);
//    NSString *tEndString=[[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"GC requestFinished --- (%@",tEndString);
    
    isDownloading=NO;
    if (delegate && [delegate respondsToSelector:@selector(GCDownFile:finished:)]) {
        [delegate performSelector:@selector(GCDownFile:finished:) withObject:mDownDict withObject:@""];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    //    NSLog(@"GC requestFailed xxxxxx ---- %@",request.error);
    
    isDownloading=NO;
    if (delegate && [delegate respondsToSelector:@selector(GCDownFile:error:)]) {
        [delegate performSelector:@selector(GCDownFile:error:) withObject:mDownDict withObject:@""];
    }
}

-(id)init{
    self=[super init];
    if (self) {
        isDownloading=NO;
        mDownDict=[[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc{
    if (isDownloading) {
        [mRequest clearDelegatesAndCancel];
    }
    [delegate release];
    [mDownDict release];
    [super dealloc];
}

@end
