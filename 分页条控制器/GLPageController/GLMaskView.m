//
//  GLMaskView.m
//  分页条控制器
//
//  Created by lang on 2018/5/10.
//  Copyright © 2018年 cnovit. All rights reserved.
//

#import "GLMaskView.h"

@implementation GLMaskView

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //画矩形
    path = [self drawRect:(CGRect){0, 0, rect.size.width, rect.size.height - self.triangleHeight} fillColor:self.fillColor];
    
    //画三角形
    CGPoint pointOne = CGPointMake(rect.size.width/2- self.triangleWidth/2, rect.size.height - self.triangleHeight);
    CGPoint pointTwo = CGPointMake(rect.size.width/2, rect.size.height);
    CGPoint pointThree = CGPointMake(rect.size.width/2 + self.triangleWidth/2, rect.size.height - self.triangleHeight);
    path = [self drawTrianglePointOne:pointOne pointTwo:pointTwo PointThree:pointThree fillColor:self.fillColor];
    
    
}


#pragma mark - setter
- (void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setTriangleWidth:(CGFloat)triangleWidth{
    _triangleWidth = triangleWidth;
    [self setNeedsDisplay];
}

- (void)setTriangleHeight:(CGFloat)triangleHeight{
    _triangleHeight = triangleHeight;
    [self setNeedsDisplay];
}


#pragma mark - 绘制矩形&三角形
//矩形
- (UIBezierPath *)drawRect:(CGRect)rect fillColor:(UIColor *)fillColor{
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    [fillColor setFill];
    [rectPath fill];
    return rectPath;
}

//三角形
- (UIBezierPath *)drawTrianglePointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo PointThree:(CGPoint)pointThree fillColor:(UIColor *)fillColor{
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    //起点
    [trianglePath moveToPoint:pointOne];
    //画线
    [trianglePath addLineToPoint:pointTwo];
    [trianglePath addLineToPoint:pointThree];
    [trianglePath closePath];
    [fillColor set];
    [trianglePath fill];
    
    return trianglePath;
    
}


@end
