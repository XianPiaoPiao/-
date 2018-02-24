//
//  UIView+baseExtra.h
//  LR_FrameWork
//
//  Created by LiRun on 15/9/21.
//  Copyright © 2015年 李润. All rights reserved.
//

#import "UIView+baseExtra.h"

@implementation UIView (baseExtra)

- (void)addTapTarget:(id)target action:(SEL)sel{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)removeSubviews{
    for(UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

- (UITextField *)textfiled4Tag:(int)tag{
    UIView *view = [self viewWithTag:tag];
    if (view!=nil && [view isKindOfClass:[UITextField class]]) {
        return (UITextField *)view;
    }
    return nil;
}

- (UIButton *)button4Tag:(int)tag{
    UIView *view = [self viewWithTag:tag];
    if (view!=nil && [view isKindOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    return nil;
}

- (UILabel *)label4Tag:(int)tag{
    UIView *view = [self viewWithTag:tag];
    if (view!=nil && [view isKindOfClass:[UILabel class]]) {
        return (UILabel *)view;
    }
    return nil;
}

- (UIImageView *)imageView4Tag:(int)tag{
    UIView *view = [self viewWithTag:tag];
    if (view!=nil && [view isKindOfClass:[UIImageView class]]) {
        return (UIImageView *)view;
    }
    return nil;
}


#pragma mark ---计算view 的x y w h


- (CGFloat)endY {
    
    return CGRectGetMaxY(self.frame);
}
-(void)setEndY:(CGFloat)endY{
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetMaxY(self.frame);
    [self setFrame:frame];
}

- (CGFloat)endX {
    return CGRectGetMaxX(self.frame);
}
-(void)setEndX:(CGFloat)endX{
    CGRect frame = self.frame;
    frame.origin.x = CGRectGetMaxX(self.frame);
    [self setFrame:frame];
}

-(void)setX:(CGFloat)x{
   
    CGRect frame = self.frame;
    frame.origin.x = x;
    [self setFrame:frame];
}
- (CGFloat)x {
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    [self setFrame:frame];
}
- (CGFloat)y {
    return self.frame.origin.y;
}


- (CGFloat)height {
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}


- (CGFloat)width {
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)width{

    CGRect frame = self.frame;
    frame.size.width = width;
    [self setFrame:frame];
}


- (CGSize)size{
    CGRect frame = [self frame];
    return frame.size;
}
-(void)setSize:(CGSize)size
{
  CGRect frame = self.frame;
    frame.size = size;
   [self setFrame:frame];
}

-(CGPoint)XY{
  
    return CGPointMake(self.x, self.y);
}
-(void)setXY:(CGPoint)XY{
    CGRect frame = self.frame;
    frame.origin = XY;
    [self setFrame:frame];
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

//将UIView转成UIImage
-(UIImage *)yjy_viewToImage
{
    UIGraphicsBeginImageContext(self.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)setRoundType{
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.masksToBounds = YES;
}
-(void)setRoundTypeByAngle:(float)angle{
    self.layer.cornerRadius = angle;
    self.layer.masksToBounds = YES;
}
-(void)setBorderColor:(UIColor*)color borderWidth:(CGFloat)width{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}
-(void)cornerRadius{
    //将图层的边框设置为圆脚
    self.layer.cornerRadius =3;
    self.layer.masksToBounds = YES;
}
-(void)cornerRadiusWithColor:(UIColor *)color{
    self.layer.cornerRadius =3;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
}
-(void)cornerRadius:(CGFloat )cornerRadius AndBorderWidth:(CGFloat )borderWidth AndBorderColor:(UIColor *)borderColor{
    //将图层的边框设置为圆脚
    self.layer.cornerRadius =cornerRadius;
    self.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
}

@end
@implementation UIView (registerCell)

-(void )registerHeaderWithHeaderViewNibNames:(NSArray *)headerViewNames{
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView=(UICollectionView *)self;
        for(NSString *headerViewName in headerViewNames){
            [collectionView registerNib:[UINib nibWithNibName:headerViewName bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewName];
        }
    }
}
-(void )registerHeaderWithHeaderViewClassNames:(NSArray *)headerViewNames{
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView=(UICollectionView *)self;
        for(NSString *headerViewName in headerViewNames){
            [collectionView registerClass:NSClassFromString(headerViewName) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewName];
        }
    }
}
-(void )registerFooterWithFooterViewClassNames:(NSArray *)footerViewNames{
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView=(UICollectionView *)self;
        for(NSString *footerViewName in footerViewNames){
            [collectionView registerClass:NSClassFromString(footerViewName) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewName];
        }
    }
}
-(void )registerFooterWithFooterViewNibNames:(NSArray *)footerViewNames{
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView=(UICollectionView *)self;
        for(NSString *footerViewName in footerViewNames){
            [collectionView registerNib:[UINib nibWithNibName:footerViewName bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewName];
        }
    }
}
-(void )registerCellWithCellNibNames:(NSArray *)cellNibNames{
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView=(UITableView *)self;
        for (NSString * temeCellNibName in cellNibNames) {
            UINib *temeCellNib=[[[NSBundle mainBundle] loadNibNamed:temeCellNibName owner:nil options:nil] firstObject];
            [tableView registerNib:temeCellNib forCellReuseIdentifier:temeCellNibName];
        }
    }
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView=(UICollectionView *)self;
        for (NSString * templateCellNibName in cellNibNames) {
            UINib *templateCellNib = [UINib nibWithNibName:templateCellNibName
                                                    bundle: [NSBundle mainBundle]];
            [collectionView registerNib:templateCellNib forCellWithReuseIdentifier:templateCellNibName];
        }
    }
}
-(void )registerCellWithCellClassNames:(NSArray *)classNames{
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView=(UITableView *)self;
        for (NSString * templateCellClass in classNames) {
            [tableView registerClass:NSClassFromString(templateCellClass) forCellReuseIdentifier:templateCellClass];
        }
    }
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView=(UICollectionView *)self;
        for (NSString * templateCellClass in classNames) {
            [collectionView registerClass:NSClassFromString(templateCellClass) forCellWithReuseIdentifier:templateCellClass];
        }
    }
}
@end
