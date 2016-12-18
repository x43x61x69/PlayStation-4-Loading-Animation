//
//  UIPlayStationShapeView.h
//  PlayStation 4 Loading Animation
//
//  Created by Zhi-Wei Cai on 18/12/2016.
//  Copyright © 2016 Zhi-Wei Cai. All rights reserved.
//

#import <UIKit/UIKit.h>

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
