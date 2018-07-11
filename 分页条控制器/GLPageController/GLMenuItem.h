//
//  GLMenuItem.h
//  分页条控制器
//
//  Created by lang on 2018/5/10.
//  Copyright © 2018年 cnovit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMenuItem : UICollectionViewCell

@property (nonatomic, copy) NSString *titleText;        /*!< 标题内容*/
@property (nonatomic, strong) UIColor *titleColor;      /*!< 标题文字颜色*/
@property (nonatomic, strong) UIFont *titleTextFont;    /*!< 标题文字字体*/
@property (nonatomic, assign) CGFloat titleLabelHeight; /*!< 标题lable高度*/


@property (nonatomic, copy) NSString *subTitleText;         /*!< 副标题内容*/
@property (nonatomic, strong) UIColor *subTitleColor;       /*!< 副标题文字颜色*/
@property (nonatomic, strong) UIFont *subTitleTextFont;     /*!< 副标题文字字体*/
@property (nonatomic, assign) CGFloat subTitleLabelHeight;  /*!< 副标题label的高度*/


@end
