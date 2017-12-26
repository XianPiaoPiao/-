//
//  ChooseCouponViewController.m
//  XuXin
//
//  Created by xian on 2017/12/12.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "ChooseCouponViewController.h"
#import "StoreCouponModel.h"
#import "ChooseCouponTableViewCell.h"

@interface ChooseCouponViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UILabel *label;
}

@property (nonatomic, strong) UITableView *couponTableView;

@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, copy) NSMutableArray *couponArray;

@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
@end

@implementation ChooseCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
    if (!_couponArray) {
        _couponArray = [[NSMutableArray alloc] initWithCapacity:0];
    }

}

- (void)requestData{
    
    if (_couponArray.count > 0) {
        [_couponArray removeAllObjects];
    }
    label.text = @"店铺优惠券";
     __weak typeof(self)weakself= self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    //订单类型，0线上线下，1面对面
    param[@"id"] = _storevcartId;
    param[@"type"] = _orderType;
    [weakself POST:findUserCouponInfoByStoreIdUrl parameters:param success:^(id responseObject) {
        if ([responseObject[@"isSucc"] intValue] == 1) {
            NSArray *array = responseObject[@"result"];
            
            for (NSDictionary *dic in array) {

                StoreCouponModel *model = [[StoreCouponModel alloc] init];
                model.name = dic[@"describe"];
                model.id = dic[@"id"];
                model.order_price = dic[@"orderprice"];
                model.price = dic[@"price"];
                [_couponArray addObject:model];
            }
            StoreCouponModel *model = [[StoreCouponModel alloc] init];
            model.name = @"不使用优惠券";
            [_couponArray addObject:model];
            [self.couponTableView reloadData];
        } else {
            StoreCouponModel *model = [[StoreCouponModel alloc] init];
            model.name = @"不使用优惠券";
            [_couponArray addObject:model];
            [self.couponTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.couponTableView reloadData];
    }];
}

- (void)requestDataRedPacket{
    if (_couponArray.count > 0) {
        [_couponArray removeAllObjects];
    }
    label.text = @"店铺红包";
    __weak typeof(self)weakself= self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    //订单类型，0线上线下，1面对面
    param[@"id"] = _orderId;
    param[@"type"] = _orderType;
    [weakself POST:findUserRedPacketByOrderUrl parameters:param success:^(id responseObject) {
        if ([responseObject[@"isSucc"] intValue] == 1) {
            NSArray *array = responseObject[@"result"];
            
            for (NSDictionary *dic in array) {
                
                StoreCouponModel *model = [[StoreCouponModel alloc] init];
                model.name = [NSString stringWithFormat:@"%@ 满%@减%@",dic[@"describe"],dic[@"orderprice"],dic[@"price"]];
                model.id = dic[@"id"];
                model.order_price = dic[@"orderprice"];
                model.price = dic[@"price"];
                [_couponArray addObject:model];
            }
            StoreCouponModel *model = [[StoreCouponModel alloc] init];
            model.name = @"不使用红包";
            [_couponArray addObject:model];
            [self.couponTableView reloadData];
        } else {
            StoreCouponModel *model = [[StoreCouponModel alloc] init];
            model.name = @"不使用红包";
            [_couponArray addObject:model];
            [self.couponTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.couponTableView reloadData];
    }];
}

- (void)createUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, ScreenW-100, 30)];
    
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    if (!_couponTableView) {
        _couponTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 50, ScreenW, screenH/2-100-self.TabbarHeight)
        _couponTableView.delegate = self;
        _couponTableView.dataSource = self;
        _couponTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_couponTableView registerNib:[UINib nibWithNibName:@"ChooseCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChooseCouponTableViewCell"];
    }
    [self.view addSubview:_couponTableView];
    [self.couponTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(50);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] init];//WithFrame:CGRectMake(0, screenH/2-50-self.TabbarHeight, ScreenW, 50)
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:[UIColor colorWithHexString:MainColor]];
    }
    [self.view addSubview:_finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(50);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [self.finishBtn addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickFinishButton{
    self.cancelBtnBlock(NO);
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCouponTableViewCell" forIndexPath:indexPath];
    StoreCouponModel *model = _couponArray[indexPath.row];
    
    //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
    if (_selIndex == indexPath) {
        //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        model.selected = YES;
    }else {
        //        cell.accessoryType = UITableViewCellAccessoryNone;
        model.selected = NO;
    }
    
    cell.model = model;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //之前选中的，取消选择
    ChooseCouponTableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    StoreCouponModel *modeled = _couponArray[_selIndex.row];
    modeled.selected = NO;
    celled.chooseButton.selected = NO;
    //记录当前选中的位置索引
    _selIndex = indexPath;
    
    ChooseCouponTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    StoreCouponModel *model = _couponArray[indexPath.row];
    model.selected = !model.selected;
    cell.chooseButton.selected = model.selected;
    if (model.selected == YES) {
        if (_isCoupon) {
            self.couponBlock(model);
        } else {
            self.redpacketBlock(model);
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
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
