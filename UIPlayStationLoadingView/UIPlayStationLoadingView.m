//
//  UIPlayStationLoadingView.m
//  UIPlayStationLoadingView
//
//  The MIT License (MIT)
//
//  Copyright © 2016 Zhi-Wei Cai. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "UIPlayStationLoadingView.h"

#define kAnimationDuration   1.f
#define kDefaultShapeColor  [UIColor darkGrayColor].CGColor

#pragma mark - UIPlayStationShapeView

typedef enum {
    UIPlayStationShapeTriangle = 0,
    UIPlayStationShapeCircle,
    UIPlayStationShapeCross,
    UIPlayStationShapeSquare
} UIPlayStationShape;

@interface UIPlayStationShapeView : UIView
@property (nonatomic)           UIPlayStationShape shape;
@property (nonatomic, strong)   UIColor *color;
@end

@implementation UIPlayStationShapeView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat size = rect.size.width * .9f;
    CGFloat lineWidth = size * .1f;
    CGFloat theta = 2.f * M_PI / 3;
    CGFloat radius = size / (1.f + sin(theta)) - lineWidth;
    CGFloat diameter = radius * sin(theta) * 2.f;
    CGFloat delta = (rect.size.width - diameter) / 2.f;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, _color ? _color.CGColor : kDefaultShapeColor);
    CGContextSetLineWidth(ctx, lineWidth);
    switch (_shape) {
        case UIPlayStationShapeTriangle: {
            delta = (rect.size.height - radius * (1.f + sin(theta / 2.f))) / 2.f;
            CGPoint center = CGPointMake(rect.size.width / 2.f,
                                         rect.size.width / 2.f + delta);
            CGContextMoveToPoint(ctx, center.x, center.y - radius);
            for (NSUInteger i = 1; i < 3; i++) {
                CGFloat x = radius * sin(i * theta);
                CGFloat y = radius * cos(i * theta);
                CGContextAddLineToPoint(ctx, center.x + x, center.y - y);
            }
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
            break;
        }
        case UIPlayStationShapeCircle: {
            CGContextStrokeEllipseInRect(ctx,
                                         CGRectMake(delta, delta,
                                                    diameter, diameter));
            break;
        }
        case UIPlayStationShapeCross: {
            CGContextMoveToPoint(ctx, delta, delta);
            CGContextAddLineToPoint(ctx, delta + diameter, delta + diameter);
            CGContextMoveToPoint(ctx, delta + diameter, delta);
            CGContextAddLineToPoint(ctx, delta, delta + diameter);
            CGContextStrokePath(ctx);
            break;
        }
        case UIPlayStationShapeSquare: {
            CGContextStrokeRect(ctx,
                                CGRectMake(delta, delta,
                                           diameter, diameter));
            break;
        }
        default:
            break;
    }
}

- (void)rotateViewWithDuration:(CGFloat)duration delay:(CGFloat)delay
{
    CGFloat relativeDuration = duration * .5f;
    CGFloat scaleUnit = 1.f / 3.f;
    CGFloat scaleUnit2X = scaleUnit * 2.f;
    
    self.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformMakeScale(.0f, .0f);
    self.alpha = .0f;
    [UIView animateKeyframesWithDuration:relativeDuration
                                   delay:delay
                                 options:UIViewKeyframeAnimationOptionCalculationModePaced
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:.0f relativeDuration:.0f animations:^{
                                      self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scaleUnit, scaleUnit),
                                                                               CGAffineTransformMakeRotation(M_PI * 2.f / 3.f));
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:.0f relativeDuration:.0f animations:^{
                                      self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scaleUnit2X, scaleUnit2X),
                                                                               CGAffineTransformMakeRotation(M_PI * 4.f / 3.f));
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:.0f relativeDuration:.0f animations:^{
                                      self.transform = CGAffineTransformIdentity;
                                      self.alpha = !self.alpha;
                                  }];
                              } completion:^(BOOL finished) {
                                  if (finished) {
                                      [UIView animateKeyframesWithDuration:relativeDuration
                                                                     delay:duration
                                                                   options:UIViewKeyframeAnimationOptionCalculationModePaced
                                                                animations:^{
                                                                    [UIView addKeyframeWithRelativeStartTime:.0f relativeDuration:.0f animations:^{
                                                                        self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scaleUnit2X, scaleUnit2X),
                                                                                                                 CGAffineTransformMakeRotation(M_PI * 2.f / 3.f));
                                                                    }];
                                                                    [UIView addKeyframeWithRelativeStartTime:.0f relativeDuration:.0f animations:^{
                                                                        self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scaleUnit, scaleUnit),
                                                                                                                 CGAffineTransformMakeRotation(M_PI * 4.f / 3.f));
                                                                    }];
                                                                    [UIView addKeyframeWithRelativeStartTime:.0f relativeDuration:.0f animations:^{
                                                                        self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.0f, .0f),
                                                                                                                 CGAffineTransformMakeRotation(M_PI * 2.f));
                                                                        self.alpha = !self.alpha;
                                                                    }];
                                                                }
                                                                completion:^(BOOL finished) {
                                                                    if (finished) {
                                                                        self.shape = ++self.shape % 4;
                                                                        [self setNeedsDisplay];
                                                                        [self rotateViewWithDuration:duration delay:delay];
                                                                    }
                                                                }];
                                  }
                              }];
}

@end

#pragma mark - UIPlayStationLoadingView

@implementation UIPlayStationLoadingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(draw)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)draw
{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    CGFloat width = self.bounds.size.width / 4.f;
    CGFloat duration = _animationSpeedFactor ? kAnimationDuration / _animationSpeedFactor : .0f;
    CGFloat delay = duration * .05f;
    for (int i = 0; i < 4; i++) {
        UIPlayStationShapeView *shape = [[UIPlayStationShapeView alloc]
                                         initWithFrame:CGRectMake(i * width, 0,
                                                                  width, width)];
        shape.shape = i;
        if (_color) {
            shape.color = _color;
        }
        shape.backgroundColor = [UIColor clearColor];
        [self addSubview:shape];
        if (duration) {
            [shape rotateViewWithDuration:duration delay:delay * i];
                    
        }
    }
}

@end
