//
//  PPCycleTabBarView.h
//  fetchDemo
//
//  Created by super on 2018/8/31.
//  Copyright © 2018年 Deniss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCycleTabBarView : UIView

+ (PPCycleTabBarView *)showCycleTabBarViewToView:(UIView *)superView
                       withHeight:(CGFloat)height
                        withTitle:(NSArray *)titles
                        tapHandle:(void(^)(NSInteger index))handle;
/*
 * 配置title上显示的角标
 */
- (void)configNumberOfPointLabelByData:(NSArray *)countArray;//number数组
/*
 * g获得title上显示的角标
 */
- (NSInteger)getNumberOfPointLabelByIndex:(NSInteger)index;
/*
 * 更新title上显示的角标
 */
- (void)updateNumberOfPointLabel:(NSInteger)count withIndex:(NSInteger)index;
/*
 * 联动
 */
- (void)scrollToSelectedTabBarByIndex:(NSInteger)index;

@end
