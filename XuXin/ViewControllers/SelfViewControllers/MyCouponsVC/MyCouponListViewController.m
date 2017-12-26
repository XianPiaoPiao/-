//
//  MyCouponListViewController.m
//  XuXin
//
//  Created by xian on 2017/12/14.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "MyCouponListViewController.h"
#import "StoreCouponModel.h"
#import "MyCouponTableViewCell.h"

@interface MyCouponListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *couponTableView;

@property (nonatomic, copy) NSMutableArray *couponArray;

@end

@implementation MyCouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self addNavgationTitle:@"我的优惠券"];
    [self addBackBarButtonItem];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    if (!_couponTableView) {
        _couponTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _couponTableView.dataSource = self;
        _couponTableView.delegate = self;
        _couponTableView.separatorStyle = NO;
        self.couponTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
        [self.view addSubview:_couponTableView];
    }
    [_couponTableView registerNib:[UINib nibWithNibName:@"MyCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCouponTableViewCell"];
    
}

- (void)requestData{
    if (!_couponArray) {
        _couponArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    __weak typeof(self)weakself= self;
    
    [weakself POST:findUserCouponUrl parameters:nil success:^(id responseObject) {
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

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCouponTableViewCell *cell;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponTableViewCell" forIndexPath:indexPath];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    StoreCouponModel *model = _couponArray[indexPath.row];
    cell.descLabel.text = [NSString stringWithFormat:@"满%@元可使用",model.order_price];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    
    NSTimeInterval timeS = [model.start_time doubleValue]/1000.0;
    NSTimeInterval timeE = [model.end_time doubleValue]/1000.0;
    
    NSDate * dateS = [NSDate dateWithTimeIntervalSince1970:timeS];
    NSDate * dateE = [NSDate dateWithTimeIntervalSince1970:timeE];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy.MM.dd"];
    NSString * start = [format stringFromDate:dateS];
    NSString * end = [format stringFromDate:dateE];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@-%@",start,end];
    cell.companyLabel.text = model.store_name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreCouponModel *model = _couponArray[indexPath.row];
    NSInteger storeId = [model.store_id integerValue];
    [User defalutManager].selectedShop =[NSString stringWithFormat:@"%ld",(long)storeId];
    
    UIStoryboard * storybord =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController * MyVC = [storybord instantiateViewControllerWithIdentifier:@"ShopDetailViewController"] ;
    
    
    [self.navigationController pushViewController:MyVC animated:YES];
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
