//
//  MyAnnoation.h
//  LessonMapKit
//
//  Created by lanouhn on 16/10/9.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnoation : NSObject<MAAnnotation>
//创建大头针标注模型，必须遵守标注模型的协议

//遵循协议之后，必须要声明三个属性
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;
@property (nonatomic ,assign)CGFloat lat;
@property (nonatomic, copy)NSString *storeId;
@property (nonatomic ,assign)BOOL isSelected;
@property (nonatomic ,assign)CGFloat longTiude;
@end
