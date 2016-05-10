//
//  ViewController.m
//  LZXLoopView
//
//  Created by 齐英 on 16/4/20.
//  Copyright © 2016年 lzx. All rights reserved.
//

#import "ViewController.h"

#define KmainWidth self.view.frame.size.width
#define KmainHeight self.view.bounds.size.height
@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *pageControl;
    NSMutableArray *picArray;
    UIView *iView;
    CGFloat offset;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    picArray = [NSMutableArray array];
//    for (int i = 0; i < 7; i ++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
//
//        [picArray addObject:image];
//        
//    }
//    
//    
//    [self makeUI];
    offset = 0.0;
    picArray = [NSMutableArray array];
    for (int i = 0; i < 7; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        [picArray addObject:image];
    }
    [self scrollViewWithPicArr:picArray];
}

- (void)scrollViewWithPicArr:(NSMutableArray *)arr
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(KmainWidth, 0);
    _scrollView.maximumZoomScale = 3;
    
    _scrollView.contentSize = CGSizeMake(KmainWidth * (picArray.count + 2), KmainHeight);
    [self.view addSubview:_scrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(KmainWidth/2-50, KmainHeight - 40, 100, 20)];
    pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.numberOfPages = picArray.count;
    [self.view addSubview:pageControl];
    
    for (int i = 0; i<arr.count + 2; i ++) {
        
        UIScrollView *tempScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(KmainWidth*i, 0, KmainWidth, KmainHeight)];
        tempScrollV.backgroundColor = [UIColor cyanColor];
        tempScrollV.contentSize = CGSizeMake(KmainWidth, KmainHeight);
        tempScrollV.showsHorizontalScrollIndicator = NO;
        tempScrollV.showsVerticalScrollIndicator = NO;
        tempScrollV.delegate = self;
        tempScrollV.maximumZoomScale = 3;
        tempScrollV.minimumZoomScale = 1;
        
        
        UIImageView *imageViews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KmainWidth, KmainHeight)];
        if (i == 0) {
            imageViews.image = [picArray lastObject];
        }else if (i == picArray.count + 1) {
            imageViews.image = [picArray firstObject];
        }else {
            imageViews.image = picArray[i - 1];
        }
        [tempScrollV addSubview:imageViews];
        [_scrollView addSubview:tempScrollV];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        _scrollView.contentOffset = CGPointMake(KmainWidth * picArray.count, 0);
    }else if (scrollView.contentOffset.x == KmainWidth * (picArray.count + 1)) {
        _scrollView.contentOffset = CGPointMake(KmainWidth, 0);
    }
    
    int pageNum = _scrollView.contentOffset.x / KmainWidth;
    if (pageNum == 0) {
        pageControl.currentPage = picArray.count - 1;
    }else if (pageNum == picArray.count + 1){
        pageControl.currentPage = 0;
    }else {
        pageControl.currentPage = pageNum - 1;
    }
    
    // 当图片放大后,滑到下一张返回时,要复原
    if (scrollView == _scrollView) {
//        CGFloat x = scrollView.contentOffset.x;
//        if (x == offset) {
//            
//        }else {
//            offset = x;
            for (UIScrollView *s in scrollView.subviews) {
                if ([s isKindOfClass:[UIScrollView class]]) {
                    [s setZoomScale:1];
                    UIImageView *imageV = [[s subviews] objectAtIndex:0];
                    imageV.frame = CGRectMake(0, 0, KmainWidth, KmainHeight);
                }
            }
//        }
        // 注释
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *v in scrollView.subviews) {
        return v;
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
