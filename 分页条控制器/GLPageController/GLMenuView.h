//
//  GLMenuView.h
//  分页条控制器
//
//  Created by lang on 2018/5/10.
//  Copyright © 2018年 cnovit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMenuView : UIView

@property (nonatomic, assign) CGFloat itemWidth;                /*!< item的宽度*/
@property (nonatomic, strong) UIColor *menuBackgroundColor;     /*!< 背景颜色*/
@property (nonatomic, strong) UIColor *maskFillColor;           /*!< mask的填充颜色*/
@property (nonatomic, assign) CGFloat triangleWidth;            /*!< mask三角形的宽度*/
@property (nonatomic, assign) CGFloat triangleHeight;           /*!< mask三角形的高度*/


@property (nonatomic, copy) NSArray<NSString *>*titles;         /*!< 标题数组*/
@property (nonatomic, strong) UIColor *normalTitleColor;        /*!< 标题未选中时的颜色*/
@property (nonatomic, strong) UIColor *selectedTitleColor;      /*!< 标题选中时的颜色*/
@property (nonatomic, strong) UIFont *titleTextFont;            /*!< 标题文字字体*/
@property (nonatomic, assign) CGFloat titleTextHeight;          /*!< 标题文字高度*/



@property (nonatomic, copy)   NSArray<NSString *> *subTitles;   /*!< 副标题数组 */
@property (nonatomic, strong) UIColor *normalSubTitleColor;     /*!< 副标题未选中时的颜色 */
@property (nonatomic, strong) UIColor *selectedSubTitleColor;   /*!< 副标题选中时的颜色 */
@property (nonatomic, strong) UIFont  *subTitleTextFont;        /*!< 副标题文字字体 */
@property (nonatomic, assign) CGFloat subTitleTextHeight;       /*!< 副标题文字高度 */


@property (nonatomic, assign) int selectIndex;                  /*!< 设置选中的下标*/


@property (nonatomic, copy) void (^clickIndexBlock)(int clickIndex);    /*!< block方式监听点击*/


/**
 初始化分段选择控件
 @param frame  frame
 @param titles 标题数组
 @param subTitles 副标题数组
 
 @return 结果
 */
+ (instancetype)glMenuViewWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)titles subTitles:(NSArray<NSString *> *)subTitles;

/**
 设置菜单的滚动
 
 @param offect 位置
 */

- (void)setMenuContentOffect:(CGPoint)offect;

/**
 刷新数据
 */
- (void)reload;

@end
