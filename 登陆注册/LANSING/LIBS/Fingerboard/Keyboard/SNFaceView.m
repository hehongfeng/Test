//
//  SNFaceView.m
//  DrawTextProject
//
//  Created by nsstring on 14-5-27.
//  Copyright (c) 2014年 Sinoglobal. All rights reserved.
//

#import "SNFaceView.h"

#define WIDTH_PAGE 320  //当前表情键盘的宽度
#define HEIGHT_PAGE self.frame.size.height  //当前表情键盘的高度
#define BU_WFRAME 35   //当前表情的宽度
#define BU_HEIGHT 35   //当前表情的高度
#define ROE_COUNT 6   //行
#define COL_COUNT 4  //列

@interface SNFaceView ()

<UIScrollViewDelegate>
{
    
    UIScrollView * _faceScrollView; //表情键盘的数组
    UIPageControl * _pageControl;   //有多少页
}

@property (nonatomic,strong)NSMutableArray * faceArray;//获取表情标记的plist文件


@end


@implementation SNFaceView

@synthesize faceArray = _faceArray;
@synthesize faceDelegate = _faceDelegate;

/*初始化
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //获取plist文件
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
        
        _faceArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
        
        if(!g_App.imageDict){
            g_App.imageDict = [[NSMutableDictionary alloc]init];
        }
        for(int i = 0 ; i < _faceArray.count ; i ++){
            
                NSString * faceString = [NSString stringWithFormat:@"%@",[[_faceArray objectAtIndex:i] objectForKey:@"image"]];
                [g_App.imageDict setObject:faceString forKey:[[_faceArray objectAtIndex:i] objectForKey:@"name"]];
            
        }
        //当当页的表情个数大于或等于当前显示的个数的时候 后面添加删除的图标
        
        if((_faceArray.count /(ROE_COUNT*COL_COUNT)))
        {
            NSInteger num =_faceArray.count /(ROE_COUNT*COL_COUNT);
            
            for( int i = 1 ;i <=num ; i++){
                
                NSDictionary * dict = [NSDictionary dictionaryWithObject:@"playback_close.png" forKey:@"image"];
                
                [_faceArray insertObject:dict atIndex:ROE_COUNT*COL_COUNT*i-1];
            }
        }
            
        // Initialization code
    }
    
    //创建ScroolView上面的控键
    [self createScrollView];
    
    return self;
}


- (NSString *)imageFilePath {
    
    NSString *s=[[NSBundle mainBundle] bundlePath];
    
    s = [s stringByAppendingString:@"/"];
    
    return s;
}
/*在scrollView上面布局表情的frame
 */
-(void)createScrollView
{
    
    NSInteger pageCount=0;
    
    NSInteger imageCount = _faceArray.count;
    
    
    if(imageCount%(COL_COUNT*ROE_COUNT)==0){
        
      pageCount=imageCount/(COL_COUNT*ROE_COUNT);
        
   }else{
       
       pageCount=imageCount/(COL_COUNT*ROE_COUNT)+1;
       
   }
     NSInteger paceWframe=(WIDTH_PAGE-BU_WFRAME*ROE_COUNT)/(ROE_COUNT+1);
    
     NSInteger paceHframe=(HEIGHT_PAGE-BU_HEIGHT*COL_COUNT)/(COL_COUNT+1);
    
    _faceScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,WIDTH_PAGE,HEIGHT_PAGE)];
    
    _faceScrollView.backgroundColor = [UIColor lightGrayColor];
    
    _faceScrollView.contentSize = CGSizeMake(WIDTH_PAGE*pageCount,HEIGHT_PAGE);
    
    _faceScrollView.delegate = self;
    
    _faceScrollView.pagingEnabled=YES;
    
    [self  addSubview:_faceScrollView];
    
    //隐藏横向与纵向的滚动条
       [_faceScrollView setShowsVerticalScrollIndicator:NO];
    
      [_faceScrollView setShowsHorizontalScrollIndicator:NO];
    
    for( int i = 0 ; i < _faceArray.count ; i++){
        
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.tag = 1000+i;
            [button setBackgroundImage:[UIImage imageNamed:
                                        [[_faceArray objectAtIndex:i] objectForKey:@"image"]] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(ButtonClikeAction:)
            forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger pageIndex = i/(COL_COUNT*ROE_COUNT);
            
            NSInteger posX=pageIndex *  self.frame.size.width +paceWframe+ (BU_WFRAME +paceWframe)* (i%ROE_COUNT);
            
            NSInteger posY=paceHframe +(BU_HEIGHT + paceHframe)*(i%(COL_COUNT*ROE_COUNT)/ROE_COUNT);
            
            button.frame = CGRectMake(posX, posY, BU_WFRAME, BU_HEIGHT);
            
            [_faceScrollView addSubview:button];
        
        }
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, self.frame.size.height-30, 120, 30)];
    
    _pageControl.numberOfPages  = pageCount;
    
    [_pageControl addTarget:self action:@selector(actionPage) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_pageControl];
}
/*点击对应的表情 根据buuton的tag 判断是删除按钮还是表情的按钮
 */
-(void)ButtonClikeAction:(UIButton*)sender
{
    //当被取余等于0 的情况说明是删除的按钮  否则 是表情的按钮
    if((sender.tag-999)/(COL_COUNT*ROE_COUNT)&&((sender.tag-999)%(COL_COUNT*ROE_COUNT))==0){

        [_faceDelegate faceViewFromCancel:sender];
    }else{
        [_faceDelegate faceViewFromfaceImage:[[_faceArray objectAtIndex:sender.tag-1000]objectForKey:@"name" ]];
 
    }
    
}

- (void) setPage
{
	_faceScrollView.contentOffset = CGPointMake(WIDTH_PAGE*_pageControl.currentPage, 0.0f);
    
    NSLog(@"setPage:%f,%ld",_faceScrollView.contentOffset.x,(long)_pageControl.currentPage);
    
    [_pageControl setNeedsDisplay];
}

#pragma mark - ScrollViewDelegate
/*当滑动停止的时候调用的方法 判断偏移量设置 currentPage
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/320;
    
    int mod   = fmod(scrollView.contentOffset.x,320);
    
    if( mod >= 160)
        
        index++;
    
    _pageControl.currentPage = index;
    
}
/*点击对应的UIPageControl设置当前的 currentPage
 */
-(void)actionPage{
    
    [self setPage];
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
