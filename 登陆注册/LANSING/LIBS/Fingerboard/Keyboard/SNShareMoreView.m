//
//  SNShareMoreView.m
//  DrawTextProject
//
//  Created by nsstring on 14-5-30.
//  Copyright (c) 2014年 Sinoglobal. All rights reserved.
//

#import "SNShareMoreView.h"

#define WIDTH_PAGE 320  //当前表情键盘的宽度
#define HEIGHT_PAGE self.frame.size.height //当前表情键盘的高度
#define BU_WFRAME 60  //宽度
#define BU_HEIGHT 50 //当前表情的高度
#define ROE_COUNT 3  //行
#define COL_COUNT 2   //列




@interface SNShareMoreView  ()

<UIScrollViewDelegate>
{
    
    UIScrollView * _moreScrollView; //添加更多的ScrollView
    UIPageControl * _pageControl;    //有多少页
    NSMutableArray * _selectArray;  //显示的平台
}


@end
@implementation SNShareMoreView

@synthesize moreDelegate = _moreDelegate;

@synthesize moreDict = _moreDict;

/*初始化
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //获取plist文件
        _selectArray = [[NSMutableArray alloc]init];
        
        NSMutableArray * data = [[NSMutableArray alloc]initWithObjects:@"sharemore_pic.png",@"sharemore_video.png",@"head_temp8.jpg",@"sharemoreAdd.png", nil];
        
        for( int i = 0 ; i < data.count ; i++){
            
            NSDictionary * dict = [NSDictionary dictionaryWithObject:[data objectAtIndex:i] forKey:@"image"];
            
            [_selectArray addObject:dict];
            
        }
        //创建ScroolView上面的控键

        [self createScrollView];
    }
    return self;
}
/*在scrollView上面布局表情的frame
 */
-(void)createScrollView
{
    
    NSInteger pageCount=0;
    
    NSInteger imageCount = _selectArray.count;
    
    if(imageCount%(COL_COUNT*ROE_COUNT)==0){
        
        pageCount=imageCount/(COL_COUNT*ROE_COUNT);
        
    }else{
        
        pageCount=imageCount/(COL_COUNT*ROE_COUNT)+1;
        
    }
    NSInteger paceWframe=(WIDTH_PAGE-BU_WFRAME*ROE_COUNT)/(ROE_COUNT+1);
    
    NSInteger paceHframe=(HEIGHT_PAGE-BU_HEIGHT*COL_COUNT)/(COL_COUNT+1);
    
    _moreScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,WIDTH_PAGE,HEIGHT_PAGE)];
    
    _moreScrollView.backgroundColor = [UIColor lightGrayColor];
    
    _moreScrollView.contentSize = CGSizeMake(WIDTH_PAGE*pageCount,HEIGHT_PAGE);
    
    _moreScrollView.delegate = self;
    
    _moreScrollView.pagingEnabled=YES;
    
    [self  addSubview:_moreScrollView];
    
    //隐藏横向与纵向的滚动条
    [_moreScrollView setShowsVerticalScrollIndicator:NO];
    
    [_moreScrollView setShowsHorizontalScrollIndicator:NO];
    
    for( int i = 0 ; i < _selectArray.count ; i++){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        [button setBackgroundImage:[UIImage imageNamed:
                                    [[_selectArray objectAtIndex:i]objectForKey:@"image"]] forState:UIControlStateNormal];
        
        button.tag = 1000 + i ;
        [button addTarget:self action:@selector(ButtonClikeAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger pageIndex = i/(COL_COUNT*ROE_COUNT);
        
        NSInteger posX=pageIndex *  self.frame.size.width +paceWframe+ (BU_WFRAME +paceWframe)* (i%ROE_COUNT);
        
        NSInteger posY=paceHframe +(BU_HEIGHT + paceHframe)*(i%(COL_COUNT*ROE_COUNT)/ROE_COUNT);
        
        button.frame = CGRectMake(posX, posY, BU_WFRAME, BU_HEIGHT);
        
        [_moreScrollView addSubview:button];
       
    }
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, self.frame.size.height-30, 120, 30)];
    
    _pageControl.numberOfPages  = pageCount;
    
    [_pageControl addTarget:self action:@selector(actionPage) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_pageControl];
}

/*点击对应的平台 返回的方法
 */
-(void)ButtonClikeAction:(UIButton*)sender
{
    
    [_moreDelegate moreView:self selectedmoreBtn:sender];
    
}
- (void) setPage
{
	_moreScrollView.contentOffset = CGPointMake(WIDTH_PAGE*_pageControl.currentPage, 0.0f);
    
    NSLog(@"setPage:%f,%ld",_moreScrollView.contentOffset.x,(long)_pageControl.currentPage);
    
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
