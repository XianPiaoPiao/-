//
//  CheckVoucherViewController.m
//  XuXin
//
//  Created by xian on 2017/11/7.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import "CheckVoucherViewController.h"
#import "VoucherTableViewCell.h"
#import "VoucherModel.h"

@interface CheckVoucherViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *voucherTableView;
@property (nonatomic, copy) NSMutableArray *voucherArray;
@property (nonatomic, copy) NSMutableArray *selectedArray;
@end

@implementation CheckVoucherViewController

- (NSMutableArray *)voucherArray{
    if (!_voucherArray) {
        _voucherArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _voucherArray;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData:) name:@"voucherArrayChange" object:nil];
//    [self requestDataVoucher];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.view addSubview:topView];
    UILabel *moneyLbl = [UILabel new];
    moneyLbl.text = @"面额";
    moneyLbl.font = [UIFont systemFontOfSize:14.0f];
    moneyLbl.textColor = [UIColor colorWithHexString:WordColor];
    [topView addSubview:moneyLbl];
    [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(10);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_offset(60);
        make.height.mas_offset(30);
    }];
    
    UILabel *codeLbl = [UILabel new];
    codeLbl.text = @"兑换券编号";
    codeLbl.font = [UIFont systemFontOfSize:14.0f];
    codeLbl.textColor = [UIColor colorWithHexString:WordColor];
    [topView addSubview:codeLbl];
    [codeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLbl.mas_right).offset(0);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_offset(120);
        make.height.mas_offset(30);
    }];
    
    UILabel *numberLbl = [UILabel new];
    numberLbl.text = @"排队序号";
    numberLbl.font = [UIFont systemFontOfSize:14.0f];
    numberLbl.textColor = [UIColor colorWithHexString:WordColor];
    [topView addSubview:numberLbl];
    [numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeLbl.mas_right).offset(20);
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right).offset(-50);
        make.height.mas_offset(30);
    }];
    
    UILabel *chooseLbl = [UILabel new];
    chooseLbl.text = @"选择";
    chooseLbl.font = [UIFont systemFontOfSize:14.0f];
    chooseLbl.textColor = [UIColor colorWithHexString:WordColor];
    [topView addSubview:chooseLbl];
    chooseLbl.textAlignment = NSTextAlignmentRight;
    [chooseLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-20);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_offset(40);
        make.height.mas_offset(30);
    }];
    
    
    if (!_voucherTableView) {
        _voucherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, screenH/2-100) style:UITableViewStylePlain];
        _voucherTableView.delegate = self;
        _voucherTableView.dataSource = self;
        _voucherTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_voucherTableView registerNib:[UINib nibWithNibName:@"VoucherTableViewCell" bundle:nil] forCellReuseIdentifier:@"VoucherTableViewCell"];
    }
    [self.view addSubview:_voucherTableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH/2-50, ScreenW, 49)];
    footerView.backgroundColor = [UIColor whiteColor];
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW/2, 49)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_cancelBtn addTarget:self action:@selector(hideContentView) forControlEvents:UIControlEventTouchUpInside];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW/2, 0, ScreenW/2, 49)];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *centerLbl = [UILabel new];
    centerLbl.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:centerLbl];
    [centerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView.mas_centerX);
        make.size.sizeOffset(CGSizeMake(1, 49));
        make.top.equalTo(footerView.mas_top);
    }];
    UILabel *topLbl = [UILabel new];
    topLbl.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:topLbl];
    [topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left);
        make.size.sizeOffset(CGSizeMake(ScreenW, 1));
        make.top.equalTo(footerView.mas_top);
    }];
    
    [footerView addSubview:_cancelBtn];
    [footerView addSubview:_sureBtn];
    
    [self.view addSubview:footerView];
}

- (void)requestData:(NSNotification *)notification{
    
    _voucherArray = notification.userInfo[@"array"];
    if (_voucherArray.count > 0) {
        [self.voucherTableView reloadData];
    }
}

- (void)requestDataVoucher{
    
        __weak typeof(self)weakself= self;
    
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
        param[@"currentPage"] = [NSString stringWithFormat:@"%d",0];
    
        [weakself POST:userListCouponUrl parameters:param success:^(id responseObject) {
    
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
    
                NSArray * array = responseObject[@"result"][@"coupon"];
                for (NSDictionary *dic in array) {
                    VoucherModel *model = [VoucherModel new];
                    model.card_name = dic[@"cradName"];
                    model.value = dic[@"propWei"];
                    model.ID = dic[@"id"];
                    model.num = dic[@"value"];
    
                    [weakself.voucherArray addObject:model];
                }
                [self.voucherTableView reloadData];
            }
        } failure:^(NSError *error) {
    
        }];

}

- (void)hideContentView{
    self.cancelBtnBlock(NO);
}

- (void)clickSureBtn{
    self.sureBtnBlock(self.selectedArray);
}

#pragma mard UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _voucherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoucherTableViewCell *cell;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"VoucherTableViewCell" forIndexPath:indexPath];
    }
    VoucherModel *model = _voucherArray[indexPath.row];
    
    cell.model = model;
    
    cell.selectedCheckBtnBlock = ^(VoucherModel *model) {
        
        if (model.selected == YES) {
            [self.selectedArray addObject:model];
            
        }else{
            [self.selectedArray removeObject:model];
        }
//        [self.voucherTableView reloadData];
    };

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VoucherModel *model = _voucherArray[indexPath.row];
    model.selected = !model.selected;
    VoucherTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checkButton.selected = model.selected;
    if (model.selected == YES) {
        [self.selectedArray addObject:model];

    }else{
        [self.selectedArray removeObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
