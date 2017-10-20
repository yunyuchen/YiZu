//
//  YYScrollAddressView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYScrollAddressView.h"

@interface YYScrollAddressView()<UIScrollViewDelegate>

@end

@implementation YYScrollAddressView

#define kImageViewCount 3
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.contentSize = CGSizeMake(kScreenWidth * kImageViewCount, 120);
        scrollView.contentOffset = CGPointMake(kScreenWidth, 0.0);
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        [self addImageViewsToScrollView];
    }
    return self;
}

-(void)setModels:(NSArray<YYSiteModel *> *)models
{
    _models = models;
    
    _imageCount = models.count;
    
    [self setDefaultInfo];
}

- (void)addImageViewsToScrollView {
    //图片视图；左边
    _imgVLeft = [[YYAddressView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, 200)];
    _imgVLeft.frame = CGRectMake(10, 0, kScreenWidth - 20, 120);
    [self.scrollView addSubview:_imgVLeft];
    
    //图片视图；中间
    _imgVCenter = [[YYAddressView alloc] initWithFrame:CGRectMake(kScreenWidth, 0.0, kScreenWidth, 200)];
    _imgVCenter.frame = CGRectMake(kScreenWidth + 10 , 0, kScreenWidth - 20, 120);
    [self.scrollView addSubview:_imgVCenter];
    
    //图片视图；右边
    _imgVRight = [[YYAddressView alloc] initWithFrame:CGRectMake(kScreenWidth * 2.0, 0.0, kScreenWidth, 200)];
    _imgVRight.frame = CGRectMake(kScreenWidth * 2.0 + 10, 0, kScreenWidth - 20, 120);

    [self.scrollView addSubview:_imgVRight];
}

- (void)setDefaultInfo {
    _currentImageIndex = 0;
    [self setInfoByCurrentModelIndex:_currentImageIndex];
}

- (void)setInfoByCurrentModelIndex:(NSUInteger)currentModelIndex {
    if (self.models.count <= 0) {
        return;
    }
    _currentImageIndex = currentModelIndex;
    _imgVCenter.model = self.models[currentModelIndex];
    NSLog(@"%ld",(unsigned long)((currentModelIndex - 1 + _imageCount) % _imageCount));
    NSLog(@"%ld",(unsigned long)((currentModelIndex + 1) % _imageCount));
    _imgVLeft.model = self.models[(unsigned long)((currentModelIndex - 1 + _imageCount) % _imageCount)];
    _imgVRight.model = self.models[(unsigned long)((currentModelIndex + 1) % _imageCount)];
    
}

- (void)reloadImage {
    CGPoint contentOffset = [self.scrollView contentOffset];
    if (contentOffset.x > kScreenWidth) { //向左滑动
        _currentImageIndex = (_currentImageIndex + 1) % _imageCount;
    } else if (contentOffset.x < kScreenWidth) { //向右滑动
        _currentImageIndex = (_currentImageIndex - 1 + _imageCount) % _imageCount;
    }
    
    [self setInfoByCurrentModelIndex:_currentImageIndex];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    if ([self.delegate respondsToSelector:@selector(navScrollView:didSelectCurrentModel:)]) {
        [self.delegate navScrollView:self didSelectCurrentModel:self.models[_currentImageIndex]];
    }
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0.0);
}

@end
