//
//  XMCircleTypeView.h
//  XMCircleType
//
//  Created by Michael Teeuw on 07-01-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMCircleTypeView : UIView

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDictionary *textAttributes;
@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat baseAngle;
@property (nonatomic) CGFloat characterSpacing;

@end
