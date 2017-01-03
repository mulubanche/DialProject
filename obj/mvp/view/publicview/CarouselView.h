//
//  CarouselView.h
//  Quhuanbei_IOS
//
//  Created by 开发者1 on 16/9/19.
//  Copyright © 2016年 Master. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ByValUrl)(NSString *, NSInteger);
@interface CarouselView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)BOOL isDrag;
@property (nonatomic,strong)NSArray * imageURLArray;
@property (nonatomic,strong)UIPageControl * pageControl;
@property (nonatomic, strong)UILabel * showNumber;
@property (strong, nonatomic) NSArray *dataArr;
@property (nonatomic) NSArray   *layout_data;
@property (copy, nonatomic) ByValUrl block;

- (void) ByValUrlBolck:(ByValUrl)block;

@end
