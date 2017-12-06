//
//  AddressItemModel.h
//  TestDemo
//
//

#import <Foundation/Foundation.h>

@interface AddressItemModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic ,copy)NSString * areaId;

@property (nonatomic, assign) BOOL isSelected;

+(instancetype)initWithName:(NSString *)name andId:(NSString *)ID isSelected:(BOOL)isSelected;
@end
