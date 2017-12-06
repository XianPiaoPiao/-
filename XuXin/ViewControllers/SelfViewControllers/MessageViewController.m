//
//  MessageViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/26.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageListModel.h"
NSString * const messageIndertifer = @"MessageTableViewCell";

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong) UITableView * tableView ;

@end

@implementation MessageViewController{
    
    MessageTableViewCell * _cell ;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    [MTA trackPageViewBegin:@"MessageViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MessageViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavgationbar];
    
    [self creatTableView];
    //
    
    [self requestData];
}
-(void)requestData{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    
    __weak typeof(self)weakself = self;
    
    [self POST:msgListUrl parameters:nil success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str integerValue] == 1) {
            
            NSArray * array = responseObject[@"result"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[MessageListModel class] json:array];
            
            weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
            
           [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"badge"];
            
        }else{
            
            CGFloat  imageH = 140 * ScreenScale;
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageH, imageH)];
            [imageView setImage:[UIImage imageNamed:@"messageNull@2x"]];
            imageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f);
            
            UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH)];
            messageLabel.center = CGPointMake(ScreenW/2.0f, screenH/2.0f + imageH /2.0f + 20);
            messageLabel.text = @"亲，消息为空";
            messageLabel.textAlignment = 1;
            
            messageLabel.textColor = [UIColor blackColor];
            
            [weakself.view addSubview:messageLabel];
            [weakself.view addSubview:imageView];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)creatNavgationbar{
   
    [self addNavgationTitle:@"消息"];
    [self addBackBarButtonItem];
}

-(void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatTableView{
    
   _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
    
    _tableView.backgroundColor =[UIColor colorWithHexString:BackColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:messageIndertifer];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   _cell = [tableView dequeueReusableCellWithIdentifier:messageIndertifer];
    
    MessageListModel * model = self.dataArray[indexPath.row];
    
    _cell.model = model;
    
    return _cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageListModel * model = self.dataArray[indexPath.row];
    
    return [_cell getPointCellHeight:model];
}


@end
