//
//  HotelMainCell.m
//  XuXin
//
//  Created by xian on 2018/2/2.
//  Copyright © 2018年 xienashen. All rights reserved.
//

#import "HotelMainCell.h"
#import "HotelCollectionViewCell.h"

@interface HotelMainCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *shopCollection;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HotelMainCell

+ (instancetype)initWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"HotelMainCell";
    HotelMainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //设置collectionView
    cell.shopCollection.delegate = cell;
    cell.shopCollection.dataSource = cell;
    cell.shopCollection.scrollEnabled = NO;
    [cell.shopCollection registerNib:[UINib nibWithNibName:@"HotelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotelCollectionViewCell"];
    
    return cell;
}

- (void)showData:(id)data {
    self.dataSource = data;
    [self.shopCollection reloadData];
}

+ (CGFloat)getHeight:(id)data {
    NSArray *model = data;
    if (model.count%3 == 0 && model.count >= 3) {
        return (model.count/3)*[HotelCollectionViewCell getSize].height;
    } else {
        return ((model.count/3)+1)*[HotelCollectionViewCell getSize].height;
    }
}

#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotelCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"item:%li",indexPath.item);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [HotelCollectionViewCell getSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置单元格之间间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
