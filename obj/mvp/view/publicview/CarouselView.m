//
//  CarouselView.m
//  Quhuanbei_IOS
//
//  Created by 开发者1 on 16/9/19.
//  Copyright © 2016年 Master. All rights reserved.
//

#import "CarouselView.h"

@implementation CarouselView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        CGFloat width  = frame.size.width;
        CGFloat height = frame.size.height;
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
        _pageControl.center = CGPointMake(width/2, height - 7);
        [self addSubview:_pageControl];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = JCDRGBA(255, 255, 255, 0.5);
        
        self.showNumber = [[UILabel alloc] initWithFrame:CGRectMake(15, height-30, width-30, 20)];
        self.showNumber.font = [UIFont systemFontOfSize:12];
        self.showNumber.textColor = [UIColor whiteColor];
        self.showNumber.textAlignment = NSTextAlignmentCenter;
        self.showNumber.layer.cornerRadius = 2;
        self.showNumber.layer.borderColor = [UIColor grayColor].CGColor;
        self.showNumber.layer.borderWidth = 1;
        self.showNumber.backgroundColor = JCDRGBA(21, 21, 21, 0.3);
        [self addSubview:self.showNumber];
        self.showNumber.hidden = true;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        self.scrollView = [UIScrollView newAutoLayoutView];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        self.pageControl = [UIPageControl new];
        [self addSubview:_pageControl];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = JCDRGBA(255, 255, 255, 0.5);
        
//        [self.scrollView autoSetDimensionsToSize:CGSizeMake(10, 10)];
        [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
//        [self.pageControl autoSetDimensionsToSize:CGSizeMake(300, 10)];
        [self.pageControl autoSetDimension:ALDimensionHeight toSize:10];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        
        self.showNumber = [UILabel newAutoLayoutView];
        self.showNumber.font = [UIFont systemFontOfSize:12];
        self.showNumber.textColor = [UIColor whiteColor];
        self.showNumber.textAlignment = NSTextAlignmentCenter;
        self.showNumber.layer.cornerRadius = 2;
        self.showNumber.layer.borderColor = [UIColor grayColor].CGColor;
        self.showNumber.layer.borderWidth = 1;
        self.showNumber.backgroundColor = JCDRGBA(21, 21, 21, 0.3);
        [self addSubview:self.showNumber];
        self.showNumber.hidden = true;
        
        [self.showNumber autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.showNumber autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    }
    return self;
}

- (void) changeNumber:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / self.frame.size.width;
    if (page == 0) {
        page = self.dataArr.count;
    }
    if (page == self.dataArr.count + 1) {
        page = 1;
    }
    page --;
    
    self.pageControl.currentPage = page;
    
    self.showNumber.text = [NSString stringWithFormat:@"%ld/%ld", (long)((long)page==0?1:page), (unsigned long)self.dataArr.count];
    CGFloat width = [self.showNumber.text textsizelimit:CGSizeMake(300, 20) font:self.showNumber.font].width + 12;
    CGRect frame = self.showNumber.frame;
    frame.size.width = width;
    frame.origin.x = self.width-width-10;
    self.showNumber.frame = frame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isDrag = NO;
    [self changeNumber:scrollView];
//    NSInteger page = scrollView.contentOffset.x / self.frame.size.width;
//    if (page == 0) {
//        page = self.dataArr.count;
//    }
//    if (page == self.dataArr.count + 1) {
//        page = 1;
//    }
//    page --;
//    
//    self.pageControl.currentPage = page;
//    
//    self.showNumber.text = [NSString stringWithFormat:@"%ld/%ld", (long)page==0?1:page, (unsigned long)self.dataArr.count];
//    CGFloat width = [self.showNumber.text textsizelimit:CGSizeMake(300, 20) font:self.showNumber.font].width + 12;
//    CGRect frame = self.showNumber.frame;
//    frame.size.width = width;
//    frame.origin.x = self.width-width-10;
//    self.showNumber.frame = frame;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDrag = YES;
    [self changeNumber:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float page = scrollView.contentOffset.x / self.frame.size.width;
    if (page >= self.dataArr.count + 1) {
        [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    }
    if (page <= 0) {
        [scrollView setContentOffset:CGPointMake(self.frame.size.width * self.dataArr.count, 0) animated:NO];
    }
}

- (void)nextImage:(NSTimer *)timer{
    
    if (self.isDrag) {
        return;
    }
    //当前位置
    int page = self.scrollView.contentOffset.x / self.frame.size.width;
    page ++;
    NSInteger x = page;
    //如果到了最后一张
    if (x == self.dataArr.count + 1) {
        x = 1;
    }
    x --;
    self.pageControl.currentPage = x;
    
    self.showNumber.text = [NSString stringWithFormat:@"%ld/%ld", (unsigned long)((++x==0)?self.dataArr.count:x), (unsigned long)self.dataArr.count];
    CGFloat width = [self.showNumber.text textsizelimit:CGSizeMake(300, 20) font:self.showNumber.font].width + 12;
    CGRect frame = self.showNumber.frame;
    frame.size.width = width;
    frame.origin.x = self.width-width-10;
    
    self.showNumber.frame = frame;
    if (page == self.dataArr.count + 1) {
        self.scrollView.delegate = nil;
        [UIView animateWithDuration:.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(page * self.frame.size.width, 0);
        } completion:^(BOOL finished) {
            self.scrollView.contentOffset = CGPointMake( self.frame.size.width, 0);
            self.scrollView.delegate = self;
        }];
        return;
    }
    [UIView animateWithDuration:.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(page * self.frame.size.width, 0);
    }];
    
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (_dataArr.count<=0) {
        return;
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * (dataArr.count + 2), self.frame.size.height);
    self.pageControl.numberOfPages = dataArr.count;
    for (UIView *item in self.scrollView.subviews) {
        [item removeFromSuperview];
    }
    
    for (UIView *item in _scrollView.subviews) {
        [item removeFromSuperview];
    }
    
    for (int i = 0 ; i < dataArr.count + 2; i ++) {
        NSInteger x = i - 1;
        if (i == 0) {
            x = dataArr.count - 1;
        }
        if (i == dataArr.count + 1) {
            x = 0;
        }
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [imageView sd_setImageWithURL:[NSURL URLWithString:dataArr[i]] placeholderImage:[UIImage imageNamed:@"huan_Long"]];
        imageView.image = [UIImage imageNamed:dataArr[x]];
        imageView.tag = 1000 + x;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = true;
        imageView.userInteractionEnabled = true;
        
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    if (dataArr.count == 1) {
        _pageControl.hidden = YES;
        return;
    }
    else{
        if (self.timer) {
            return;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    self.showNumber.text = [NSString stringWithFormat:@"1/%ld", (unsigned long)self.dataArr.count];
    CGFloat width = [self.showNumber.text textsizelimit:CGSizeMake(300, 20) font:self.showNumber.font].width + 12;
    CGRect frame = self.showNumber.frame;
    frame.size.width = width;
    frame.origin.x = self.width-width-10;
    self.showNumber.frame = frame;
}

- (void)layoutSubviews{
    if (_dataArr.count<=0) {
        return;
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * (_dataArr.count + 2), self.frame.size.height);
    self.pageControl.numberOfPages = _dataArr.count;
    for (UIView *item in self.scrollView.subviews) {
        [item removeFromSuperview];
    }
    
    for (UIView *item in _scrollView.subviews) {
        [item removeFromSuperview];
    }
    
    for (int i = 0 ; i < _dataArr.count + 2; i ++) {
        NSInteger x = i - 1;
        if (i == 0) {
            x = _dataArr.count - 1;
        }
        if (i == _dataArr.count + 1) {
            x = 0;
        }
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        //        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        [imageView sd_setImageWithURL:[NSURL URLWithString:dataArr[i]] placeholderImage:[UIImage imageNamed:@"huan_Long"]];
        imageView.image = [UIImage imageNamed:_dataArr[x]];
        imageView.tag = 1000 + x;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = true;
        imageView.userInteractionEnabled = true;
        
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    if (_dataArr.count == 1) {
        _pageControl.hidden = YES;
        return;
    }
    else{
        if (self.timer) {
            return;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    self.showNumber.text = [NSString stringWithFormat:@"1/%ld", (unsigned long)self.dataArr.count];
    CGFloat width = [self.showNumber.text textsizelimit:CGSizeMake(300, 20) font:self.showNumber.font].width + 12;
    CGRect frame = self.showNumber.frame;
    frame.size.width = width;
    frame.origin.x = self.width-width-10;
    self.showNumber.frame = frame;

}


- (void) ByValUrlBolck:(ByValUrl)block{
    _block = block;
}
- (void) tapClick:(UITapGestureRecognizer *)sender{
    
}


@end
