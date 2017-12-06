//
//  PriceSortedViewController.h
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TheTypeOfCollection) {
    TheTypeOfCollectionOne,//有21个item
    TheTypeOfCollectionTwo,//有4个item
    
} ;

typedef void(^TapTheViewBlock)(void);
typedef void(^ReloadButtonTitleBlock)(NSString *);

@interface PriceSortedViewController : UIViewController

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,strong) UIView * translucentView ;



@property (nonatomic,assign) TheTypeOfCollection theTypeOfCollection;




/** 点击下半部分透明视图 block*/
@property (nonatomic,copy) TapTheViewBlock blk;
/** 点击了哪个cell 传值过去*/
@property (nonatomic,copy) ReloadButtonTitleBlock reloadBtnBlk;
@end
