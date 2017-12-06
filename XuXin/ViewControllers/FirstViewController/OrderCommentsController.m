//
//  OrderCommentsController.m
//  XuXin
//
//  Created by xuxin on 17/3/6.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "OrderCommentsController.h"
#import "HaiDuiTextView.h"
#import "StartsCommentView.h"
#import "OnlineGoodsModel.h"
@interface OrderCommentsController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic ,assign)NSInteger evalue;
@property (nonatomic ,assign)NSInteger desScore;
@property (nonatomic ,assign)NSInteger serviceScore;
@property (nonatomic ,assign)NSInteger shipScore;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,strong) UITableView * tableView;

@end

@implementation OrderCommentsController{
    
    
    HaiDuiTextView * _textView;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [MTA trackPageViewBegin:@"OrderCommentsController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"OrderCommentsController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self creatUI];
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"评论"];
    
    [self addBackBarButtonItem];
    
}
-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}
#pragma mark ----界面布局
-(void)creatUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;

    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    
    UIButton * sendBtn =[[UIButton alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20, 50)];
    [footView addSubview:sendBtn];
    
    _tableView.tableFooterView = footView;
    sendBtn.layer.cornerRadius = 25;
    sendBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //
    [sendBtn addTarget:self action:@selector(sendComments) forControlEvents:UIControlEventTouchDown];
    
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;

        //商家logo
        for (int i = 0; i < self.goodsArray.count; i++) {
            
            ONLINEgoodsModel * model = self.goodsArray[i];
            
            CGFloat shopImageH = 40;
            UIImageView * shopImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 +(shopImageH * i), 10, shopImageH, shopImageH)];
            shopImage.layer.masksToBounds = YES;
            shopImage.layer.cornerRadius = 3;
            [cell.contentView addSubview:shopImage];
            [shopImage sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        }
       
        
        UILabel * shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 110, 10, 100, 40)];
        
        shopNameLabel.textAlignment = 2;
        shopNameLabel.text = [NSString stringWithFormat:@"共%ld件",self.goodsArray.count];
        [shopNameLabel setTextColor:[UIColor blackColor]];
        [shopNameLabel setFont: [UIFont systemFontOfSize:14]];
        [cell.contentView addSubview:shopNameLabel];
        return cell;
        
    }else if (indexPath.section == 1){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 40)];
        if (_orderType == 3) {
            
            label.text = @"店铺评分";

        }else{
            label.text = @"商品描述相符";

        }
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        CGFloat btnH = 50;
        
        NSArray * array  = @[@"difference",@"in",@"good"];
        NSArray * selectArray =@[@"difference-2",@"in-2",@"good-2"];
        NSArray * nameArray = @[@"差评",@"一般",@"好评"];
        
        for (int i = 0; i < 3; i++) {
            
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(105 + (btnH +10) * i, 10, btnH, btnH)];
            
            [btn setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selectArray[i]] forState:UIControlStateSelected];
            
            [btn addTarget:self action:@selector(goodsSelect:) forControlEvents:UIControlEventTouchDown];
            if (i == 2) {
                
               btn.selected = YES;
                _evalue = 1;
            }
            btn.tag = buttonTag + i;
            
            [btn setTitle:nameArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor colorWithHexString:WordLightColor] forState:UIControlStateNormal];
            
            [btn setImagePositionWithType:SSImagePositionTypeTop spacing:2];
            
            [cell.contentView addSubview:btn];
        }
        return cell;
    }else if (indexPath.section == 2){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        UIImageView * storeImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        storeImageView.layer.masksToBounds = YES;
        storeImageView.layer.cornerRadius = 25;
        
        [storeImageView sd_setImageWithURL:[NSURL URLWithString:self.storeLogo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, ScreenW - 100, 20)];
        nameLabel.text = self.storeName;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = 0;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 100, 20)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:WordLightColor];
        label.text = @"店铺评分";
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:storeImageView];
        return cell;
        
    }else if(indexPath.section == 3){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;

        UILabel * NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80 , 50)];
        NameLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:NameLabel];
        [NameLabel setTextColor:[UIColor colorWithHexString:WordLightColor]];
        
        NSArray * nameArray = @[@"服务态度",@"用餐环境",@"商品口味"];
        NameLabel.text = nameArray[indexPath.row];
        
        StartsCommentView * starsView = [[StartsCommentView alloc] initWithFrame:CGRectMake(90, 15, 200 , 30)];
        starsView.starValue  =  5;
        
        starsView.tag = buttonTag + 10 + indexPath.row;
        
        [cell.contentView addSubview:starsView];

        return cell;
    }else{
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        _textView = [[HaiDuiTextView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
        
        _textView.delegate = self;
        
        [cell.contentView addSubview:_textView];
        [_textView setMyPlaceholder:@"说说商家的亮点和不足吧!(写够15字，才是好同志)"];
        _textView.textColor = [UIColor colorWithHexString:WordLightColor];
        return cell;
    }
    
}
#pragma mark ---店铺评分
-(void)goodsSelect:(UIButton *)sender{
    //
  UIButton * btn = (UIButton *)[self.view viewWithTag:buttonTag + 2];
    btn.selected = NO;
    
    UIButton * selectedBtn = (UIButton *)[self.view viewWithTag:_index + buttonTag];
    //将之前选中的变成非选中状态
    selectedBtn.selected = NO;
    //让按钮可以点击
    selectedBtn.userInteractionEnabled = YES;
    
    //2.让被点击的按钮变成选中状态
    sender.selected = YES;

    self.index = sender.tag - buttonTag;
    
    if (_index == 0) {
        
        _evalue = -1;
        
    }else if (_index == 1){
        
        _evalue = 0;
        
    }else{
        _evalue = 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
   if (section == 1){
        
        return 1;
   }else if (section == 2){
       
       return 8;
   }
   else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_orderType == 3) {
            
            return 0;
        }else{
            
            return  56;
        }
        
    }else if(indexPath.section == 1){
    
            
            return  70;

    }else if (indexPath.section == 2){
        
        return 70;
        
    }else if (indexPath.section == 3){
        
        return 50;
    }
    else{
        
        return 200;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_orderType == 3) {
            
            return 0;
        }else{
            
           return 1;
        }
    }else if(section == 1){
     
        return 1;
        
    }else if (section== 3){
        
        return 3;
    }
    else{
        
        return 1;
    }
}

#pragma mark ---提交评论

-(void)sendComments{
    
    StartsCommentView * serveStarsView = [self.view viewWithTag:buttonTag + 10];
    
    StartsCommentView * shipStarsView = [self.view viewWithTag:buttonTag + 11];

    StartsCommentView * desStarsView = [self.view viewWithTag:buttonTag + 12];

    _desScore = desStarsView.starValue;
        
    _serviceScore = serveStarsView.starValue;
        
    _shipScore =shipStarsView.starValue;
    //
    if (_orderType == 3) {
        //面对面评论
        [SVProgressHUD showWithStatus:@"请稍等"];
        [self uploadFaceOrderComment];
        
    }else{
        //线上线下评论
        [SVProgressHUD showWithStatus:@"请稍等"];

        [self uploadComments];
 
    }

    
}

//线上线下商品评价
-(void)uploadComments{
    
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"content"] = _textView.text;
    
    param[@"orderFormId"] = self.goodsId;
    
    param[@"evaluateLevel"] =[NSString stringWithFormat:@"%ld", _evalue];
    
    param[@"desScore"] = [NSString stringWithFormat:@"%ld",_desScore];
    
    param[@"shipScore"] = [NSString stringWithFormat:@"%ld",_shipScore];
    
    param[@"serviceScore"] =  [NSString stringWithFormat:@"%ld",_serviceScore];
    
    
    [self POST:evaluateUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            [weakself showStaus:@"评价成功"];

            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                UIViewController * vc = self.navigationController.viewControllers[1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"commened" object:nil];
                
            [self.navigationController popToViewController:vc animated:YES];
                
            });
           
        }
    } failure:^(NSError *error) {
        
    }];
}
//面对面评价
-(void)uploadFaceOrderComment{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"content"] = _textView.text;
    
    param[@"evaluateLevel"] =[NSString stringWithFormat:@"%ld", _evalue];

    param[@"faceOrderId"] = self.storeId;
    
    param[@"desScore"] = [NSString stringWithFormat:@"%ld",_desScore];
    
    param[@"shipScore"] = [NSString stringWithFormat:@"%ld",_shipScore];
    
    param[@"serviceScore"] =  [NSString stringWithFormat:@"%ld",_serviceScore];
    
    [self POST:face_two_faceUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            [weakself showStaus:@"评价成功"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                UIViewController * vc = self.navigationController.viewControllers[1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"commened" object:nil];
                
                [self.navigationController popToViewController:vc animated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.tableView.contentOffset = CGPointMake(0, 200);

    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}
@end
