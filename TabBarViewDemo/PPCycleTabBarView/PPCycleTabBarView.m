//
//  PPCycleTabBarView.m
//  fetchDemo
//
//  Created by super on 2018/8/31.
//  Copyright © 2018年 Deniss. All rights reserved.
//

#import "PPCycleTabBarView.h"

#define __object_block_return(block, object) \
if(block) { \
block(object); \
} \

//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

#define Label_Font 15
#define Point_Label_Font 10
#define Point_Label_Width 16
#define Line_height 2
#define Interval_width 20
#define Select_Color mRGBToColor(0x26acff)

@interface PPCycleTabBarView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) CGFloat label_X;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *pointLabelArray;
@property (nonatomic, copy) void(^tapHandle)(NSInteger index);

@end

@implementation PPCycleTabBarView

+ (PPCycleTabBarView *)showCycleTabBarViewToView:(UIView *)superView
                       withHeight:(CGFloat)height
                        withTitle:(NSArray *)titles
                        tapHandle:(void(^)(NSInteger index))handle {
    PPCycleTabBarView *tabBarView = [[PPCycleTabBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(superView.frame), height)
                                                                  withHeight:height
                                                                   withTitle:titles];
    tabBarView.tapHandle = handle;
    [superView addSubview:tabBarView];
    return tabBarView;
}

- (instancetype)initWithFrame:(CGRect)frame withHeight:(CGFloat)height withTitle:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.labelArray = @[].mutableCopy;
        self.titleArray = titles;
        self.itemHeight = height-2;
        [self layerView:frame];
    }
    return self;
}

- (void)layerView:(CGRect)frame {
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, frame.size.height-2)];
    self.titleScrollView.backgroundColor = [UIColor whiteColor];
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.delegate = self;
    [self addSubview:self.titleScrollView];
    self.label_X = 0.0f;
    for (NSInteger i = 0; i < self.titleArray.count; i ++) {
        [self.titleScrollView addSubview:[self getTitleLabel:self.titleArray[i] index:i]];
        
        self.label_X += ([self getWidth:self.titleArray[i]]+Interval_width*2);
        [self.titleScrollView addSubview:[self getPointLabel]];
    }
    [self settingDefaultLabelTextColor];
    [self.titleScrollView addSubview:[self getLineLabel:self.titleArray.firstObject]];
    self.titleScrollView.contentSize = CGSizeMake(self.label_X, self.itemHeight);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (offY < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (CGFloat)getWidth:(NSString *)title {
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Label_Font]}
                                      context:nil];
    return rect.size.width;
}

- (UILabel *)getTitleLabel:(NSString *)title index:(NSInteger)index {
    UILabel *label = [self getTargetLabelByRect:CGRectMake(self.label_X+Interval_width, 0, [self getWidth:title], self.itemHeight - Line_height)];
    label.font = [UIFont systemFontOfSize:Label_Font];
    label.textColor = [UIColor blackColor];
    label.text = title;
    label.tag = index;
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[self tapGestureRecognizer]];
    [self.labelArray addObject:label];
    return label;
}

- (UILabel *)getPointLabel {
    UILabel *label = [self getTargetLabelByRect:CGRectMake(self.label_X-(Point_Label_Width+8), 3, Point_Label_Width, Point_Label_Width)];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:Point_Label_Font];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    label.layer.cornerRadius = Point_Label_Width/2;
    label.clipsToBounds = YES;
    label.hidden = YES;
    [self.pointLabelArray addObject:label];
    return label;
}

- (UILabel *)getLineLabel:(NSString *)title {
    self.lineLabel = [self getTargetLabelByRect:CGRectMake(Interval_width, self.itemHeight - Line_height, [self getWidth:title], Line_height)];
    self.lineLabel.backgroundColor = Select_Color;
    return self.lineLabel;
}

- (UILabel *)getTargetLabelByRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    return tap;
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    UILabel *targetLabel = (UILabel *)tapGesture.view;
    [self tabBarViewScrollToCenter:targetLabel];
    [self changeLabelColor:targetLabel];
    __object_block_return(self.tapHandle, targetLabel.tag);
}

- (void)tabBarViewScrollToCenter:(UILabel *)targetLabel {
    CGFloat move_width = targetLabel.center.x - CGRectGetWidth(self.frame)/2;
    //中心点偏移量
    move_width = move_width<=0?0:move_width;
    //实际可偏移量
    CGFloat offset_width = self.label_X-CGRectGetWidth(self.frame);
    //中心点偏移量不能超过实际的偏移量
    offset_width = offset_width<=0?0:offset_width;
    //确定滑动中心点位置
    CGFloat center_x = move_width>=offset_width?offset_width:move_width;
    __typeof__(self) __weak weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.lineLabel.frame = CGRectMake(targetLabel.frame.origin.x, self.itemHeight-Line_height, targetLabel.frame.size.width, Line_height);
        [weakself.titleScrollView setContentOffset:CGPointMake(center_x, 0) animated:YES];
    }];
}

- (void)changeLabelColor:(UILabel *)targetLabel {
    targetLabel.textColor = Select_Color;
    for (UILabel *label in self.labelArray) {
        if (![label isEqual:targetLabel]) {
            label.textColor = [UIColor blackColor];
        }
    }
}

- (void)settingDefaultLabelTextColor {
    UILabel *targetLabel = (UILabel *)self.labelArray.firstObject;
    targetLabel.textColor = Select_Color;
}

- (NSMutableArray *)pointLabelArray {
    if (!_pointLabelArray) {
        _pointLabelArray = @[].mutableCopy;
    }
    return _pointLabelArray;
}

- (void)configLabelNumber:(NSNumber *)number index:(NSInteger)index {
    UILabel *numberLabel  = self.pointLabelArray[index];
    numberLabel.text = number.stringValue;
    numberLabel.hidden = number.integerValue > 0?NO:YES;
}

- (void)configNumberOfPointLabelByData:(NSArray *)countArray {
    for (NSInteger i = 0; i < countArray.count; i++) {
        NSNumber *number = countArray[i];
        [self configLabelNumber:number index:i];
    }
}

- (NSInteger)getNumberOfPointLabelByIndex:(NSInteger)index {
    UILabel *numberLabel  = self.pointLabelArray[index];
    return numberLabel.text.integerValue;
}

- (void)updateNumberOfPointLabel:(NSInteger)count withIndex:(NSInteger)index {
    [self configLabelNumber:[NSNumber numberWithInteger:count] index:index];
}

- (void)scrollToSelectedTabBarByIndex:(NSInteger)index {
    __typeof__(self) __weak weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself tabBarViewScrollToCenter:(UILabel *)self.labelArray[index]];
    });
}

@end
