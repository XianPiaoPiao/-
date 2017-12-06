//
//  ChoseView.h
//  AddShoppingCart
//

#import <UIKit/UIKit.h>
#import "TypeView.h"
#import "BuyCountView.h"
#import "HDCarNumberCOunt.h"
@interface ChoseView : UIView<UITextFieldDelegate,UIAlertViewDelegate,TypeSeleteDelegete>
@property(nonatomic, retain)UIView *alphaiView;
@property(nonatomic, retain)UIView *whiteView;

@property(nonatomic, retain)UIImageView *img;

@property(nonatomic, retain)UILabel *lb_price;
@property(nonatomic, retain)UILabel *lb_stock;
@property(nonatomic, retain)UILabel *lb_detail;
@property(nonatomic, retain)UILabel *lb_line;

@property(nonatomic, retain)UIScrollView *mainscrollview;

@property(nonatomic, retain)TypeView *sizeView;
@property(nonatomic, retain)TypeView *colorView;
@property(nonatomic, retain)BuyCountView *countView;
@property (nonatomic ,retain)HDCarNumberCOunt * goodsCountView;
@property(nonatomic, retain)UIButton *bt_sure;
@property(nonatomic, retain)UIButton *bt_cancle;
@property(nonatomic ,retain)NSMutableArray *sizearr;
@property(nonatomic ,retain)NSMutableArray *colorarr;

@property(nonatomic ,retain)NSMutableArray *sizeIdArr;
@property(nonatomic ,retain)NSMutableArray *colorIdArr;

@property(nonatomic ,retain)NSMutableArray *stockArray;
@property (nonatomic ,retain)NSMutableArray * resultArray;


@property(nonatomic) int stock;
@property(nonatomic ) NSString * contentString;

-(void)initTypeView:(NSMutableArray *)resltuArray;

-(void)initContentView:(NSMutableArray *)stockarr;

//-(void)initTypeView:(NSMutableArray *)szIdArr :(NSMutableArray *)corIdArr;
@end
