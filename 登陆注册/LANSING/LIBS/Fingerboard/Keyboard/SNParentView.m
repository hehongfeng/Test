//
//  SNParentView.m
//  DrawTextProject
//
//  Created by nsstring on 14-6-4.
//  Copyright (c) 2014年 Sinoglobal. All rights reserved.
//

#import "SNParentView.h"
//#import "SNSubViewController.h"

#define KEYBORD_HEIGHT        216
#define KEYBORD_HEADER_H      44
#define APPID                 @"535487e9"

@implementation SNParentView

@synthesize parentDelegate = _parentDelegate;
//@synthesize subViewContrl = _subViewContrl;

/*初始化
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
    }
    return self;
}
/*创建表情键盘和添加更多的view
*/
-(void)createFaceViewAndMoreView
{
    
    //上浮框
    _inputBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToolViewBkg_Black.png"]];
    _inputBar.frame = CGRectMake(0,0,self.frame.size.width,KEYBORD_HEADER_H);
    _inputBar.userInteractionEnabled = YES;
    [self  addSubview:_inputBar];
    _inputBar.hidden = NO;
    
    //表情键盘的view
    _faceView = [[SNFaceView alloc]initWithFrame:CGRectMake(0,_inputBar.frame.size.height,self.frame.size.width,self.frame.size.height-_inputBar.frame.size.height )];
    _faceView.faceDelegate = self;
    [self addSubview:_faceView];
    _faceView.hidden   = YES;
    
    //加号的view
    _moreMoreView = [[SNShareMoreView alloc]initWithFrame:CGRectMake(0, _inputBar.frame.size.height, self.frame.size.width, self.frame.size.height-_inputBar.frame.size.height)];
    _moreMoreView.moreDelegate = self;
    [self  addSubview:_moreMoreView];
    _moreMoreView.hidden = YES;

    
    //UITextView 输入各种的
    _messageView = [[UITextView alloc]initWithFrame:CGRectMake(45, 7, 205, 30)];
    _messageView.delegate = self;
    _messageView.returnKeyType = UIReturnKeySend;
    _messageView.font = [UIFont systemFontOfSize:14.0f];
    [_messageView.layer setCornerRadius:6];
    [_messageView.layer setMasksToBounds:YES];
    [self addSubview:_messageView];
    
    
    //为添加更多按钮 比如添加相册图片的选择
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(290, 7, 30, 30);
    btn.showsTouchWhenHighlighted = YES;
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[[g_App imageFilePath] stringByAppendingPathComponent:@"TypeSelectorBtn_Black.png"]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addShareMore:) forControlEvents:UIControlEventTouchUpInside];
    [_inputBar addSubview:btn];
    btn.selected = NO;
    _moreButton = btn;
    
    //语音的按钮 语音讯飞
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 7, 30, 30);
    btn.showsTouchWhenHighlighted = YES;
    NSString* s2 = [NSString stringWithFormat:@"%@ToolViewInputVoice.png",[g_App imageFilePath]];
    NSString* s1 = [NSString stringWithFormat:@"%@keyboard_n.png",[g_App imageFilePath]];
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:s2] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:s1] forState:UIControlStateSelected];
    btn.selected = NO;
    [_inputBar addSubview:btn];
    [btn addTarget:self action:@selector(recordVoiceSwitch:) forControlEvents:UIControlEventTouchUpInside];
    _recordBtnVideo = btn;
    
    //表情键盘和正常键盘的切换
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(252, 7, 30, 30);
    s1 = [NSString stringWithFormat:@"%@keyboard_n.png",[g_App imageFilePath]];
    s2 = [NSString stringWithFormat:@"%@ToolViewEmotion.png",[g_App imageFilePath]];
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:s1] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:s2] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(actionFace:) forControlEvents:UIControlEventTouchUpInside];
    [_inputBar addSubview:btn];
    _btnFace = btn;
    _btnFace.selected = NO;
    
    //初始化语音识别控件
    NSString *initString = [NSString stringWithFormat:@"appid=%@",APPID];
//    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:_subViewContrl.view.center initParam:initString];
//    _iflyRecognizerView.delegate = self;
//    [_iflyRecognizerView setParameter:@"domain" value:@"iat"]; [_iflyRecognizerView setParameter:@"asr_audio_path" value:@"asrview.pcm"];
    keyboardHeight = KEYBORD_HEIGHT;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
  
    //手势的view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFingerCliked:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired =1;
//    [_subViewContrl.view addGestureRecognizer:tap];
    
}



/*键盘即将出来的时候 调用的方法
 */
-(void)keyboardWillShown:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    keyboardHeight = keyboardRect.size.height;
    [_parentDelegate adjustKeyboardBigFrameHeight:keyboardRect.size.height + _inputBar.frame.size.height];

}

/*点击手势空白处键盘回收
 */
-(void)tapFingerCliked:(UIGestureRecognizer*)tap
{
    [self hiddenTapView];

}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer {
    // 触发手勢事件后，在这里作些事情
    [self hiddenTapView];
}

/*隐藏键盘的方法a
 */
-(void)hiddenTapView
{

    [_messageView resignFirstResponder];
    
    if(![_messageView.text isEqualToString:@""]){
        keyboardHeight =_inputBar.frame.size.height;
        [_parentDelegate adjustKeyboardSmallFrameHeight:keyboardHeight];

    }else{
        keyboardHeight = KEYBORD_HEADER_H;
        CGRect frame = _inputBar.frame;
        frame.size.height = KEYBORD_HEADER_H ;
        _inputBar.frame = frame;
        _messageView.frame =CGRectMake(45, 7, 205, 30);
        
        _faceView.frame = CGRectMake(0,_inputBar.frame.size.height,self.frame.size.width,self.frame.size.height-_inputBar.frame.size.height );
        
        _moreMoreView.frame = CGRectMake(0, _inputBar.frame.size.height, self.frame.size.width, self.frame.size.height-_inputBar.frame.size.height);
        [_parentDelegate adjustKeyboardSmallFrameHeight:keyboardHeight];

    }

}

#pragma mark - textViewDelegate
/*开始编辑textview
 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    [_parentDelegate adjustKeyboardBigFrameHeight:keyboardHeight + _inputBar.frame.size.height];
    _faceView.hidden = YES;
    _btnFace.selected = NO;
    _moreMoreView.hidden = YES;
    _moreButton.selected = NO;
    
    return YES;
    
}
/*正在编辑的时候所触发的方法
 */
- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = textView.contentSize;
    size.height -=3;
    
    if ( size.height >= 64 ) {
        
        size.height = 64;
    }
    else if ( size.height <= 30 ) {
        
        size.height = 30;
    }
    
    if ( size.height != textView.frame.size.height ) {
        
        CGFloat span = size.height - textView.frame.size.height;
        
        
        CGRect frame = _inputBar.frame;
        frame.size.height += span ;
        _inputBar.frame = frame;
        
        frame = textView.frame;
        frame.origin.y = 7;
        frame.size = size;
        
        textView.frame = frame;
        
        [_parentDelegate  adjustKeyboardBigFrameHeight:keyboardHeight+_inputBar.frame.size.height];
        _faceView.frame = CGRectMake(0,_inputBar.frame.size.height,self.frame.size.width,self.frame.size.height-_inputBar.frame.size.height );

        _moreMoreView.frame = CGRectMake(0, _inputBar.frame.size.height, self.frame.size.width, self.frame.size.height-_inputBar.frame.size.height);
      }
    
   }

/*正在编辑的时候 用来限制输入的字符长度
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        
        CGRect frame = _inputBar.frame;
        frame.size.height = KEYBORD_HEADER_H ;
        _inputBar.frame = frame;
        _messageView.frame =CGRectMake(45, 7, 205, 30);
        
        _faceView.frame = CGRectMake(0,_inputBar.frame.size.height,self.frame.size.width,self.frame.size.height-_inputBar.frame.size.height );
        
        _moreMoreView.frame = CGRectMake(0, _inputBar.frame.size.height, self.frame.size.width, self.frame.size.height-_inputBar.frame.size.height);
        //[_parentDelegate adjustKeyboardSmallFrameHeight:keyboardHeight];

        
        if(![textView.text isEqualToString:@""]){
            [_parentDelegate keyboardClickSendWithText:textView.text];
        }
        
        _messageView.text = @"";
        return NO;
    }
    
    return YES;
}
/*点击添加更多的按钮触发的事件方法
 */
-(void)addShareMore:(UIButton*)sender
{

    if( !sender.selected ){
        
        keyboardHeight = KEYBORD_HEIGHT;

        sender.selected = YES;
        _moreButton.selected = YES;
        _moreMoreView.hidden = NO;
        _faceView.hidden = YES;
        [_messageView resignFirstResponder];
        [_parentDelegate adjustKeyboardBigFrameHeight:keyboardHeight + _inputBar.frame.size.height];
        
    }else{
        
        sender.selected = NO;
        _moreMoreView.hidden = YES;
        
        _moreButton.selected = NO;
        [_messageView becomeFirstResponder];

    }

}

/*录制声音用讯飞语音转换音频
 */
-(void)recordVoiceSwitch:(UIButton*)sender
{
    
    if( !sender.selected ){
        
        sender.selected = !sender.selected;
        _recordBtnVideo.selected = YES;
       [_messageView resignFirstResponder];
        
        keyboardHeight =_inputBar.frame.size.height;
        
        [_parentDelegate adjustKeyboardSmallFrameHeight:keyboardHeight];
        [_iflyRecognizerView start];

        
    }else
    {
         sender.selected = !sender.selected;
         _recordBtnVideo.selected = NO;
        [_messageView becomeFirstResponder];
        
    }
}

/*切换头像和键盘的按钮
 */
-(void)actionFace:(UIButton*)sender
{

    if ( sender.selected ){
        
        sender.selected = NO;
        _faceView.hidden = YES;
        _btnFace.selected = sender.selected;
        [_messageView becomeFirstResponder];
       
        
    }else{
        keyboardHeight = KEYBORD_HEIGHT;

        sender.selected = YES;
        _faceView.hidden = NO;
        _moreMoreView.hidden = YES;
        [_messageView resignFirstResponder];
        [_parentDelegate adjustKeyboardBigFrameHeight:keyboardHeight +_inputBar.frame.size.height];

       
    }

}

#pragma mark - faceViewDeelage
/*点击表情的代理方法
 */
-(void)faceViewFromfaceImage:(NSString*)faceStr
{
    _messageView.text = [NSString stringWithFormat:@"%@%@",_messageView.text,faceStr];
    [self textViewDidChange:_messageView];
}

/*点击删除按钮
 */
-(void)faceViewFromCancel:(UIButton*)sender
{
   if(![_messageView.text isEqualToString:@""]){
       
       NSString * lastText = [_messageView.text substringFromIndex:_messageView.text.length-1];
       NSString * nextText;
       if(_messageView.text.length>=4){
           nextText = [_messageView.text substringFromIndex:_messageView.text.length-4];
       }
       if([lastText isEqualToString:@"]"]&& [[nextText substringToIndex:1]isEqualToString:@"["]){
           
           _messageView.text = [_messageView.text substringToIndex:_messageView.text.length-4];
           
       }else{
           _messageView.text = [_messageView.text substringToIndex:_messageView.text.length-1];

       }
       
       [self textViewDidChange:_messageView];
    }
    
}

#pragma mark - moreViewDelegate
/*点击更多返回的代理方法
 */

-(void)moreView:(SNShareMoreView*)moreView selectedmoreBtn:(UIButton*)moreBtn
{
    [_parentDelegate clikeMoreButtonSubButtonWithButtonTag:moreBtn.tag];
}


//识别结果返回代理
- (void)onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray
{
    
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    _messageView.text = [NSString stringWithFormat:@"%@%@",_messageView.text,result];
    
    _recordBtnVideo.selected = NO;
    //识别结果保存在resultArray中,会实时的将识别结果通过onResult返回,开发者需要手动 的拼接识别结果
}
//识别会话结束代理
- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *)error {
    _recordBtnVideo.selected = NO;

    // IFlySpeechError是错误描述类,包含_errorCode错误码和_errorType两个属性和相关接口 //正常情况下会话结束时错误码为0
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
