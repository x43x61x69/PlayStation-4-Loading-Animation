//
//  UIPlayStationShapeView.m
//  PlayStation 4 Loading Animation
//
//  Created by Zhi-Wei Cai on 18/12/2016.
//  Copyright © 2016 Zhi-Wei Cai. All rights reserved.
//
#define kDefaultShapeColor  [UIColor darkGrayColor].CGColor

#import "UIPlayStationShapeView.h"

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
            CGPoint center = CGPointMake(rect.size.width  / 2.f,
                                         rect.size.height / 2.f + delta);
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

@end
