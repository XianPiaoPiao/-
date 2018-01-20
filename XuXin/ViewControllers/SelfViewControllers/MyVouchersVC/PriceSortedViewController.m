//
//  PriceSortedViewController.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "PriceSortedViewController.h"
#import "PriceSortedCollectionViewCell.h"
@interface PriceSortedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataSourceArray;
@property (nonatomic,strong) NSMutableArray * dataSourceArray1;

@property (nonatomic,assign) NSInteger lastSelectedCell;

@property (nonatomic ,assign)NSInteger lastTableCell;

@property (nonatomic,assign) NSInteger numberOfItems;
@property (nonatomic,assign) CGFloat  widthOfItems;
@property (nonatomic,assign) NSInteger numberOfLines;
@property (nonatomic,strong)UITableView * categoryTableView;
@end
NSString * const collectionCellIdentifier = @"PriceSortedCollectionViewCell";
@implementation PriceSortedViewController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 280) collectionViewLayout:flowLayout];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
    [self.collectionView registerNib:[UINib nibWithNibName:@"PriceSortedCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:collectionCellIdentifier];
        
        self.collectionView.backgroundColor = [UIColor colorWithHexString:BackColor];
        
        self.view.backgroundColor = [UIColor clearColor];
        
        [self addBgView];

    }
    return _collectionView;
    
}
-(UITableView *)categoryTableView{
    if (!_categoryTableView) {
        
        _categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 160) style:UITableViewStylePlain];
        _categoryTableView.dataSource = self;
        _categoryTableView.delegate = self;
        _categoryTableView.scrollEnabled = NO;
        [self addBgView];

    }
    return _categoryTableView;
}
-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray =@[@"全部",@"10元",@"20元"
                            ,@"30元",@"50元",@"100元"
                            ,@"200元",@"300元",@"500元"
                            ,@"1000元",@"2000元",@"3000元"
                            ,@"5000元",@"1万元",@"2万元"
                            ,@"3万元",@"5万元",@"10万元"
                            ,@"20万元",@"30万元",@"50万元"
                            ].mutableCopy;
        
    }
    return _dataSourceArray;
}

-(NSMutableArray *)dataSourceArray1{
    if (!_dataSourceArray1) {
        
        _dataSourceArray1 =@[@"全部",@"排队中",@"已完成",@"已兑换"
                            ].mutableCopy;//,@"已领现"
        
    }
    return _dataSourceArray1;
}

-(void)addBgView{
   
    _translucentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, screenH)];
    _translucentView.backgroundColor = [UIColor blackColor];
    _translucentView.alpha = 0.6;
    
    UIGestureRecognizer * tapGesture = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapTheView)];
    [_translucentView addGestureRecognizer:tapGesture];
    
    
    [self.view addSubview:_translucentView];
}
-(void)setTheTypeOfCollection:(TheTypeOfCollection)theTypeOfCollection{
    
    _theTypeOfCollection = theTypeOfCollection;
    if (self.theTypeOfCollection == TheTypeOfCollectionOne) {
        
        self.categoryTableView.frame = CGRectMake(0, -screenH, ScreenW, 0);
        
        [self.view addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 0, ScreenW, 280);
        
    }else{
        
        self.collectionView.frame =CGRectMake(0, -screenH, ScreenW, 0);
        
        [self.view addSubview:self.categoryTableView];
        self.categoryTableView.frame = CGRectMake(0, 0, ScreenW, 160);
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lastSelectedCell = 0;
    _lastTableCell = 0;
}


//MARK:点击了阴影视图
- (void)tapTheView{
    
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tapTheView" object:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PriceSortedCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = self.dataSourceArray[indexPath.item];
        
        
        if (indexPath.item == 0) {
            
            cell.selectedImageView.hidden = NO;
            cell.titleLabel.textColor = [UIColor colorWithHexString:MainColor];
            
        }else{
            
            cell.selectedImageView.hidden = YES;
            cell.titleLabel.textColor = [UIColor blackColor];
            
        }
        
        return cell;
        
   
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW -3)/3.0f, 40);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 1, 1);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //根据idenxPath获取对应的cell
    PriceSortedCollectionViewCell * lastSelectedcell =  (PriceSortedCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.lastSelectedCell inSection:0]];
    
 
        PriceSortedCollectionViewCell * currentSelectedcell =  (PriceSortedCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
   
    
    
        NSString * str = self.dataSourceArray[indexPath.item];
        NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:str,@"textOne", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"priceValue" object:nil userInfo:info];
   
    self.lastSelectedCell = indexPath.item;
    
    
    currentSelectedcell.selected = YES;
    currentSelectedcell.selectedImageView.hidden = NO;
    currentSelectedcell.titleLabel.textColor = [UIColor colorWithHexString:MainColor];
    
    lastSelectedcell.selected = NO;
    lastSelectedcell.selectedImageView.hidden = YES;
    lastSelectedcell.titleLabel.textColor = [UIColor blackColor];
    

    [self tapTheView];
    
}
#pragma mark  ----uitableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = self.dataSourceArray1[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.textColor = [UIColor colorWithHexString:MainColor];
    }else{
        
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray1.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewCell * lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastTableCell inSection:0]];
    
    self.lastTableCell = indexPath.row;
    
    cell.textLabel.textColor =[UIColor colorWithHexString:MainColor];
    lastCell.textLabel.textColor = [UIColor blackColor];

    NSString * str =[NSString stringWithFormat:@"%ld",indexPath.item];
    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:str,@"textOne", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"status" object:nil userInfo:info];
    
    [self tapTheView];
}
@end
