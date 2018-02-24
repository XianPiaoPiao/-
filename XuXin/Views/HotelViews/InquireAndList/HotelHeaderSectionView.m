//
//  HotelHeaderSectionView.m
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/2.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import "HotelHeaderSectionView.h"
//cell
#import "HotelToolCell.h"
#import "ACMacros.h"

@interface HotelHeaderSectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 功能列表
 */
@property (strong, nonatomic) UICollectionView *toolCollection;
@end

@implementation HotelHeaderSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.toolCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0)).equalTo(self);
        }];
    }
    return self;
}

#pragma -mark UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotelToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotelToolCell" forIndexPath:indexPath];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 31);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 12, 8, 12);
}

#pragma -mark lazy
-(UICollectionView *)toolCollection{
    if (!_toolCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 8;
        _toolCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _toolCollection.showsHorizontalScrollIndicator = NO;
        _toolCollection.showsVerticalScrollIndicator = NO;
        _toolCollection.delegate = self;
        _toolCollection.dataSource = self;
        _toolCollection.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [_toolCollection registerNib:[UINib nibWithNibName:@"HotelToolCell" bundle:nil] forCellWithReuseIdentifier:@"HotelToolCell"];
        [self addSubview:_toolCollection];
    }
    return _toolCollection;
}

@end
