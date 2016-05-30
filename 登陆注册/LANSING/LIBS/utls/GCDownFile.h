//
//  GCDownFile.h
//  dreamWorks
//
//  Created by dreamRen on 13-8-7.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "GCPath.h"

@protocol GCDownFileDelegate;

@interface GCDownFile : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>{
    id<GCDownFileDelegate> delegate;
    ASIHTTPRequest *mRequest;
    BOOL isDownloading;
    NSMutableDictionary *mDownDict;
}

@property(nonatomic,retain) id <GCDownFileDelegate> delegate;
@property(nonatomic)BOOL isDownloading;

-(void)beginDownFile:(NSString*)aFileHttp withDownDict:(NSDictionary*)aDict;

-(void)cancelDownload;

@end

@protocol GCDownFileDelegate <NSObject>

@optional

//-(void)GCDownFile:(GCDownFile *)aDownFile curProgress:(float)aProgress;
//-(void)GCDownFile:(GCDownFile *)aDownFile finished:(NSMutableDictionary*)aDict;
//-(void)GCDownFile:(GCDownFile *)aDownFile error:(NSMutableDictionary*)aDict;

-(void)GCDownFile:(NSMutableDictionary*)aDict curProgress:(NSNumber*)aProgress;
-(void)GCDownFile:(NSMutableDictionary*)aDict finished:(NSString*)aString;
-(void)GCDownFile:(NSMutableDictionary*)aDict error:(NSString*)aError;
-(void)GCDownFileRefreshInfo:(NSMutableDictionary*)aDict;

@end

