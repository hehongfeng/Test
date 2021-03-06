//
//  GCUtil.h
//  iMagazine2
//
//  Created by dreamRen on 12-11-16.
//  Copyright (c) 2012年 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FXLabel.h"
#import "JPCommonMacros.h"

@interface GCUtil : NSObject{
@private
    float soundDuration;
}

+(BOOL)connectedToNetwork;

//显示提示框,只有一个确定按钮
+(void)showInfoAlert:(NSString*)aInfo;

//显示提示框 DXAlertView
+(void)showDxalertTitle:(NSString*)title andMessage:(NSString*)message cancel:(NSString*)cancel andOk:(NSString*)amend;
//显示请求错误
+(void)showDataErrorAlert;

//添加单击事件
+(UITapGestureRecognizer *)getTapGesture:(id)target action:(SEL)action;
+(UILongPressGestureRecognizer*)getLongPressClick:(id)target action:(SEL)action;

//是否空格
+(BOOL)isEmptyOrWhitespace:(NSString*)aStr;

//按比例更改图片大小
+(UIImage*)scaleAspectFitImage:(UIImage*)aImage ToSize:(CGSize)aSize;
//按比例更改图片大小,短的那个边等于toSize对应的边的长度,长的那个变>=toSize对应的边的长度
+(UIImage*)scaleImage:(UIImage*)aImage ToSize:(CGSize)aSize;

+(NSString *)getToday;
+(NSString *)formatToDay:(NSDate*)aDate;
//日期+随机数
+(NSString*)getTimeAndRandom;

//格式化日期, 时间
+(NSString*)formatToDayAndTime:(NSDate*)aDate;

+(NSString*)formatDayAndTimeFrom1970Seconds:(NSString*)aSecond;
+(BOOL)isMobileNumber:(NSString *)mobileNum;
+(BOOL)isValidateEmail:(NSString *)email;
//正则判断中文英文，及数字
+(BOOL)isTextFiledNumber:(NSString*)textField;
+(BOOL)ThePhoneNumber:(NSString *)string;

+(BOOL)isTextFiledChinaAndEnglish:(NSString*)textField;
//正则判断意见反馈
+(BOOL)isTextFiledfeedback:(NSString*)textField;

//渐变label
+(FXLabel*)getJianBianLabelWithTitle:(NSString*)aTitle;
+(FXLabel*)getJianBianLabelWithFrame:(CGRect)aRect WithFont:(UIFont*)aFont WithTitle:(NSString*)aTitle;

//任海丽添加方法
+ (UIImage *)imageWithImage:(UIImage*)inImage withColorMatrix:(const CGFloat*)f;
+(NSString*) digest:(NSString*)input;

//label
+(UILabel *)draughtLabel:(CGRect )frame fontOfSize:(CGFloat)fontSize textAlignment:(int)textAlignment textString:(NSString *)textString textColor:(UIColor *)textColor;
//String宽度
+(CGSize)widthOfString:(NSString *)string withFont:(int)font;

//String字个数
+  (int)convertToInt:(NSString*)strtemp;

//TextView行间距
+(void)lineSpacingTextView:(UITextView *)textView fontInt:(int )fontInt;

/******************************************************************************
 函数名称  : scaleToSize
 函数描述  : image缩放
 输入参数  :	目的尺寸
 输出参数  : N/A
 返回值	  : 缩放后的image
 备注	  :
******************************************************************************/
+(UIImage *)scaleToSize:(CGSize)size toImage:(UIImage *)image;

//设置字体颜色：把十六进制颜色转化为UIColor
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;
//评论专用
+(UIViewController*)getParentViewController:(UIView*)view;
//utf编码
+(NSString*)encodeUrlString:(NSString*)urlString;

//加密MD5
+(NSString *)md5:(NSString *)str;

//把时间嘬转换为时间的格式
+(NSString*)getDataZuoGeshi:(NSString*)timeDate;

//时间
+(NSString*)getDateChanged:(NSString*)date;
@end
