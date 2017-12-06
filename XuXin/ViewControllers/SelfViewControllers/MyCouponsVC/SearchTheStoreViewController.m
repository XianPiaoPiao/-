//
//  SearchTheStoreViewController.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "SearchTheStoreViewController.h"

@interface SearchTheStoreViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@end

@implementation SearchTheStoreViewController{
    EasySearchBar * _searchBar;
    UITableView * _shopTableView;
    UIImageView * _nullImageView;
    UILabel * _nullLabel;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //

    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self creatNavgationBar];
    
    //创建tableview
    _shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
    _shopTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _shopTableView.separatorStyle = NO;
    [self.view addSubview:_shopTableView];
    _shopTableView.delegate = self;
    _shopTableView.dataSource =self;
    
    //搜索不到商家
    CGFloat imageW = 120;
    _nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
    _nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
    _nullLabel.text = @"没有该商家";
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.textAlignment = 1;
    
    [_nullImageView setImage:[UIImage imageNamed:@"shangjia_kong@2x"]];
    [self.view addSubview:_nullImageView];
    [self.view addSubview:_nullLabel];
}
//点击确定按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self requestDataWithPage];
    [_searchBar.searchField resignFirstResponder];
    return YES;
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = NO;
    
    [self addBackBarButtonItem];
    
    _searchBar = [[EasySearchBar alloc] initWithFrame:CGRectMake(50, 26, ScreenW - 80, 32)];
    _searchBar.searchField.backgroundColor = [UIColor colorWithHexString:BackColor];
    _searchBar.searchField.delegate = self;
    
    [_searchBar.searchField becomeFirstResponder];

    self.navigationItem.titleView = _searchBar;
    
}
-(void)returnToMianVC{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma --数据请求
-(void)requestDataWithPage{
    
    __weak typeof(self)weakself= self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"storeName"] = _searchBar.searchField.text;
    [weakself POST:searcheStoreCouponUrl parameters:param success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            //隐藏
            _nullImageView.hidden = YES;
            _nullLabel.hidden = YES;
            _shopTableView.hidden = NO;

            NSArray * array = responseObject[@"result"];
            
            weakself.dataArray = [NSMutableArray arrayWithArray:array];
            //刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_shopTableView reloadData];
            });
         
            
        }else{
            _shopTableView.hidden = YES;
            [self.dataArray removeAllObjects];

            _nullImageView.hidden = NO;
            _nullLabel.hidden = NO;
            _nullImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 20);
            _nullLabel.frame = CGRectMake(0, screenH/ 2.0f + 60, ScreenW, 20);
        }
        
    } failure:^(NSError *error) {
        
    }];
  }
#pragma mark --- tableview的代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    if (self.dataArray.count) {
        
        cell.textLabel.text = self.dataArray[indexPath.row][@"storeName"];

    }
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count) {
        
        NSString * str = self.dataArray[indexPath.row][@"storeName"];
        NSString * str2 = self.dataArray[indexPath.row][@"storeId"];
        self.block(str,str2);
    }
  
    [self.navigationController popViewControllerAnimated:YES];
}
//收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
//滑动收起键盘
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [_searchBar.searchField resignFirstResponder];
}

@end
