//
//  GCLabelWithYellow.m
//  dreamWorks
//
//  Created by dreamRen on 13-7-5.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import "GCLabelWithYellow.h"

@implementation GCLabelWithYellow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.textColor=[UIColor colorWithRed:246/255.0 green:222/255.0 blue:15/255.0 alpha:1.0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
