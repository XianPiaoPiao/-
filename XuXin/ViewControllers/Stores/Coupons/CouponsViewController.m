//
//  CouponsViewController.m
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "CouponsViewController.h"
#import "StoreCouponTableViewCell.h"
#import "StoreCouponModel.h"

@interface CouponsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *couponTableView;

@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, copy) NSMutableArray *couponArray;

@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
//    [self requestData];
    
}

- (void)setStoreID:(NSString *)storeID{
    _storeID = storeID;
    [self requestData];
}

- (void)requestData{
    
    if (!_couponArray) {
        _couponArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    __weak typeof(self)weakself= self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"storeid"] = _storeID;
    [weakself POST:findUnclaimedUrl parameters:param success:^(id responseObject) {
        if ([responseObject[@"isSucc"] intValue] == 1) {
            NSArray *array = responseObject[@"result"];
            for (NSDictionary *dic in array) {
                StoreCouponModel *model = [StoreCouponModel yy_modelWithDictionary:dic];
                [_couponArray addObject:model];
            }
            [self.couponTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)createUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, ScreenW-100, 30)];
    label.text = @"店铺优惠券";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    if (!_couponTableView) {
        _couponTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, screenH/3*2-100-self.TabbarHeight) style:UITableViewStylePlain];
        _couponTableView.delegate = self;
        _couponTableView.dataSource = self;
        _couponTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_couponTableView registerNib:[UINib nibWithNibName:@"StoreCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreCouponTableViewCell"];
    }
    [self.view addSubview:_couponTableView];
    
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, screenH/3*2-50-self.TabbarHeight, ScreenW, 50)];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:[UIColor colorWithHexString:MainColor]];
    }
    [self.view addSubview:_finishBtn];
    [self.finishBtn addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickFinishButton{
    self.finishBtnBlock(NO);
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCouponTableViewCell" forIndexPath:indexPath];
    cell.model = _couponArray[indexPath.row];
    cell.getCouponButton.tag = indexPath.row;
    [cell.getCouponButton addTarget:self action:@selector(clickGetCoupon:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115.0f;
}

- (void)clickGetCoupon:(UIButton *)getCouponBtn{
    __weak typeof(self)weakself= self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    StoreCouponModel *model = [_couponArray objectAtIndex:getCouponBtn.tag];
    param[@"id"] = model.id;
    [weakself POST:sellerCouponSendSaveUrl parameters:param success:^(id responseObject) {
        if ([responseObject[@"isSucc"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"已领取"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
