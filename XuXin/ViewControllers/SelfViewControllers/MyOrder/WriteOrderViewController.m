//
//  WriteOrderViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "WriteOrderViewController.h"
#import "CovertGradeTableViewCell.h"
#import "RecievePlaceTableViewCell.h"
#import "ImageDisplayTableViewCell.h"
#import "CovertPaperTableViewCell.h"
#import "SectionCovertTableViewCell.h"
#import "RecivePlaceTableViewController.h"
//#import "qucklySendViewController.h"
#import "SelfSendViewController.h"
#import "HDShopCarModel.h"
#import "receivePlaceModel.h"
#import "ConvertGoodsCellModel.h"
#import "GoodsLIstViewController.h"
#import "CouponnsModel.h"
#import "ReadPayViewController.h"

#import "IntergerGoodsDetailModel.h"
NSString * const coverIndertifer = @"CovertGradeTableViewCell";
NSString * const RecievePlaceTableIndertifer = @"RecievePlaceTableViewCell";
NSString * const coverPaperIndertifier = @"CovertPaperTableViewCell";
NSString * const sectionCovertIndertifer = @"SectionCovertTableViewCell";
NSString * const sendWayIndertifer = @"SendwayTableViewCell";

@interface WriteOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (nonatomic,assign)NSInteger lastCellIndex;

//自提
@property(nonatomic,copy)NSString * pickUpAddressId;
@property(nonatomic,copy)NSString * pickUpAddressName;

@property (nonatomic,assign)NSInteger sendType;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)NSUInteger covertPoint;
@property (nonatomic ,copy)NSString * sendPrice;
@property(nonatomic ,strong)NSMutableArray * couponDataArray;
@property (nonatomic ,assign)BOOL isSetAdress;
@property (nonatomic ,assign)NSInteger totalCount;
@property (nonatomic ,strong)NSMutableArray * caputelateArray;

@property(nonatomic,copy)NSString * textContentSting;

@end

@implementation WriteOrderViewController{
    
    UITableView * _mainTableView;
    UITableView * _convertPaperTableView;
    UITableView * _sendTableView;
    //提货方式
    UIButton * _setAdressbtn;
    //快递费
    UILabel * _totalLabel;
    UILabel * _totalCouponLabel;
    //自提点地址
    UILabel * _selfAdressLabel;
    //备注
    UITextView * _textView;
    UIButton * _selfSendBtn;
    UIButton * _sendBtn;
}
-(NSMutableArray *)caputelateArray{
    if (!_caputelateArray) {
        _caputelateArray = [[NSMutableArray alloc] init];
    }
    return _caputelateArray;
}
-(NSMutableArray *)ImageArray{
    if (!_ImageArray) {
        _ImageArray = [[NSMutableArray alloc] init];
    }
    return _ImageArray;
}
-(NSMutableArray *)couponDataArray{
    if (!_couponDataArray) {
        _couponDataArray = [[NSMutableArray alloc] init];
    }
    return _couponDataArray;
}
-(NSMutableArray *)goodIdaArray{
    if (!_goodIdaArray) {
        _goodIdaArray = [[NSMutableArray alloc] init];
    }
    return _goodIdaArray;
}
-(receivePlaceModel *)placeModel{
    if (!_placeModel) {
        _placeModel = [[receivePlaceModel alloc] init];
    }
    return _placeModel;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.view.window.backgroundColor = [UIColor whiteColor];
    
    [MTA trackPageViewBegin:@"WriteOrderViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"WriteOrderViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //初始化
    _sendPrice = @"1";
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAdress:) name:@"refreshingData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAdress:) name:@"selectAdress" object:nil];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self firstLoad];
    
    [self creatNavgationBar];
    
    [self creatTableView];
}
-(void)selectAdress:(NSNotification *)dic{
    
    receivePlaceModel * model = dic.userInfo[@"name"];
    self.placeModel = model;
    
    [_mainTableView reloadData];
    
    _isSetAdress = YES;
    
   
    //重新计算快递费
    [self requestSendFee];

}
-(void)firstLoad{
    //收货地址
     [self requestData];
    //获取兑换券
     [self requestCouponListData];
}

#pragma mark ---默认地址请求
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    
   [weakself.httpManager POST:getDefaultAddressUrl parameters:nil  progress:^(NSProgress * _Nonnull uploadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       

       NSArray * array = responseObject[@"result"];

       NSString * str = responseObject[@"isSucc"];
       
       if ([str intValue] == 1) {
           if (array.count > 0 ) {
               
               _isSetAdress = YES;
               
               NSDictionary * dic = array[0];
               
               self.placeModel = [receivePlaceModel yy_modelWithDictionary:dic];
               
           }else{
               
               _isSetAdress = NO;
           }
           
       }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
               [_mainTableView reloadData];
           });
     
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
   }];
    
}
#pragma mark --- 获取兑换券
-(void)requestCouponListData{
    
    __weak typeof(self)weakself = self;
    
    [weakself POST:couponListUrl parameters:nil success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"][@"couponns"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[CouponnsModel class] json:array];
            
            weakself.couponDataArray = [NSMutableArray arrayWithArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_convertPaperTableView reloadData];
            });
            
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)junmRecivePlaceVC{
    
   // [_setAdressbtn removeFromSuperview];
    
    RecivePlaceTableViewController   * edictPlaceVC = [[RecivePlaceTableViewController alloc] init];

    [self.navigationController pushViewController:edictPlaceVC animated:YES];
}

-(void)creatTableView{
    
   _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    
    //
    _mainTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _mainTableView.sectionHeaderHeight = 5;
    _mainTableView.sectionFooterHeight = 5;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
   
    [_mainTableView registerNib:[UINib nibWithNibName:@"CovertGradeTableViewCell" bundle:nil] forCellReuseIdentifier:coverIndertifer];
    [_mainTableView registerNib:[UINib nibWithNibName:@"RecievePlaceTableViewCell" bundle:nil] forCellReuseIdentifier:RecievePlaceTableIndertifer];
   [_mainTableView registerNib:[UINib nibWithNibName:@"SectionCovertTableViewCell" bundle:nil] forCellReuseIdentifier:sectionCovertIndertifer];
    //关掉cell的分割线
    _mainTableView.separatorStyle = NO;
  
}


-(void)creatNavgationBar{
    
    [self addBackBarButtonItem];
    [self addNavgationTitle:@"填写兑换订单"];
}
#pragma mark --- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _mainTableView) {
        return 10;
    } else if (tableView == _convertPaperTableView){
        return 1;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _mainTableView) {
          return 1;
    } else if (tableView == _convertPaperTableView){
        return self.couponDataArray.count;
    }
    return 0;
  
}
#pragma mark ---界面布局
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _mainTableView) {
        //填写地址
        if (indexPath.section == 0){
         

            if (_isSetAdress == NO) {
                
                UITableViewCell * cell = [[UITableViewCell alloc] init];
                _setAdressbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
                [_setAdressbtn setTitle:@"请选择收货地址以确保顺利到达" forState:UIControlStateNormal];
                
                _setAdressbtn.titleLabel.font = [UIFont systemFontOfSize:15];
                _setAdressbtn.backgroundColor = [UIColor whiteColor];
                [_setAdressbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [_setAdressbtn addTarget:self action:@selector(junmRecivePlaceVC) forControlEvents:UIControlEventTouchDown];
                [cell.contentView addSubview:_setAdressbtn];
                return cell;
            } else{
                
            RecievePlaceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RecievePlaceTableIndertifer forIndexPath:indexPath];
          
            cell.NameLabel.text = self.placeModel.trueName;
            cell.phoneNumberLabel.text = self.placeModel.mobile;
            cell.receivePlaceLbael.text = self.placeModel.area;
                return cell;
            }
        }//图片
        else if (indexPath.section == 1){
  
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 60, 10, 60, 20)];
            countLabel.center = CGPointMake(ScreenW - 30 - 20, 53);
            countLabel.textColor = [UIColor blackColor];
            countLabel.font = [UIFont systemFontOfSize:14];
            countLabel.text = [NSString stringWithFormat:@"共%ld件",self.shopCarNumber];//self.ImageArray.count];
            [cell.contentView addSubview:countLabel];
            
            UIImageView * nextImageView =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 22, 10, 8, 8)];
            nextImageView.center = CGPointMake(ScreenW - 10, 53);
            [nextImageView setImage:[UIImage imageNamed:@"icon_address_right_arrow@2x"]];
            [cell.contentView addSubview:nextImageView];
            
            for (int i = 0; i < self.ImageArray.count; i++) {
                
                HDShopCarModel * goodModel = self.ImageArray[i];
                CGFloat imageViewW = 86;
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (imageViewW +10) *i, 10 , imageViewW, imageViewW)];
                [cell.contentView addSubview:imageView];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:goodModel.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
                if (i>= 2) {
                    imageView.hidden = YES;
                }
            }
         
            return cell;
        }//兑换需要的积分
        else if (indexPath.section == 2){
            CovertGradeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:coverIndertifer forIndexPath:indexPath];
            cell.gradeLabel.text =[NSString stringWithFormat:@"%.f",_totalIntegral];
            cell.selectionStyle = NO;
            return cell;
        }//兑换需要的现金
        else if (indexPath.section == 3){
            
            CovertGradeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:coverIndertifer forIndexPath:indexPath];
            cell.nameLabel.text = @"商品需支付现金:";
            cell.gradeLabel.text = [NSString stringWithFormat:@"%.2f",_totalPrice];
            cell.selectionStyle = NO;
            return cell;
            
        }//我的积分
        else if (indexPath.section == 4){
            
            CovertGradeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:coverIndertifer forIndexPath:indexPath];
            cell.nameLabel.text = @"我的积分:";
            cell.gradeLabel.text = [NSString stringWithFormat:@"%ld",[User defalutManager].integral];
            cell.selectionStyle = NO;
            return cell;
        }else if (indexPath.section ==5){
            
        SectionCovertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sectionCovertIndertifer forIndexPath:indexPath];
            cell.selectionStyle = NO;
            return cell;
        }
        else if (indexPath.section == 6){
            
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = NO;
            //兑换券tableView
            _convertPaperTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, ScreenW, 140) style:UITableViewStylePlain];
            
            _convertPaperTableView.delegate = self;
            _convertPaperTableView.dataSource = self;
            _convertPaperTableView.separatorStyle = NO;
            [_convertPaperTableView registerNib:[UINib nibWithNibName:@"CovertPaperTableViewCell" bundle:nil] forCellReuseIdentifier:coverPaperIndertifier];
            [cell.contentView addSubview:_convertPaperTableView];
            return cell;
            
        }else if (indexPath.section == 7){
            
            UITableViewCell * cell =[[UITableViewCell alloc] init];
            cell.selectionStyle = NO;
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
            label.text = @"使用兑换:";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            cell.selectionStyle = NO;
            
            //兑换券积分
            _totalCouponLabel  = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, ScreenW - 110, 40)];
            _totalCouponLabel.textAlignment = 2;
            _totalCouponLabel.font = [UIFont systemFontOfSize:15];
            _totalCouponLabel.textColor = [UIColor colorWithHexString:MainColor];
            [cell.contentView addSubview:_totalCouponLabel];
            
            return cell;
        }
        //配送方式
        else if (indexPath.section == 8){
            
          UITableViewCell * cell = [[UITableViewCell alloc] init];

            cell.selectionStyle = NO;
            UILabel * sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 25)];
            
            sendLabel.text = @"配送方式:";
            sendLabel.textColor = [UIColor blackColor];
            sendLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:sendLabel];
           //快递费
            
            _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, ScreenW - 170, 25)];
            _totalLabel.textAlignment = 2;
            _totalLabel.textColor = [UIColor colorWithHexString:MainColor];
            _totalLabel.font = [UIFont systemFontOfSize:15];
          
         
            [cell.contentView addSubview:_totalLabel];
            //自提地点
            _selfAdressLabel =  [[UILabel alloc] initWithFrame:CGRectMake(160, 35, ScreenW - 170, 25)];
            _selfAdressLabel.textAlignment = 2;
            _selfAdressLabel.textColor = [UIColor colorWithHexString:MainColor];
 
            _selfAdressLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:_selfAdressLabel];
            CGFloat buttonW = 80;
            //快递
            _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 10 , buttonW, 25)];
            _sendBtn.tag = buttonTag ;
            [_sendBtn setTitle:@"快递" forState:UIControlStateNormal];
            _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_sendBtn setImage:[UIImage imageNamed:@"btn_shopcart_radio_off.png"] forState:UIControlStateNormal];
            [_sendBtn setImage:[UIImage imageNamed:@"exchange_selected"] forState:UIControlStateSelected];
            [_sendBtn setImagePositionWithType:SSImagePositionTypeRight spacing:10];
            [cell.contentView addSubview:_sendBtn];
            
            [_sendBtn addTarget:self action:@selector(queuelySned:) forControlEvents:UIControlEventTouchDown];
            
            //自提
            _selfSendBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 10 + 25 , buttonW, 25)];
            _selfSendBtn.tag = buttonTag + 1;
            [_selfSendBtn setTitle:@"自提" forState:UIControlStateNormal];
            _selfSendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_selfSendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_selfSendBtn setImage:[UIImage imageNamed:@"btn_shopcart_radio_off.png"] forState:UIControlStateNormal];
            [_selfSendBtn setImage:[UIImage imageNamed:@"exchange_selected"] forState:UIControlStateSelected];
            [_selfSendBtn setImagePositionWithType:SSImagePositionTypeRight spacing:10];
            [cell.contentView addSubview:_selfSendBtn];
            
            [_selfSendBtn addTarget:self action:@selector(queuelySned:) forControlEvents:UIControlEventTouchDown];
            if ([self.vendor isEqualToString:@"admin"] || [self.vendor isEqualToString:@"嗨兑平台"]) {
//                [_selfSendBtn setHidden:NO];
                _selfSendBtn.hidden = NO;
            } else {
//                [_selfSendBtn setHidden:YES];
                _selfSendBtn.hidden = YES;
            }
            //保持状态
            if ([_sendPrice integerValue] > 1) {
                
                [_totalLabel setText:[NSString stringWithFormat:@"%@元",_sendPrice]];
                _sendBtn.selected = YES;
            }
            //保持状态
            if (_pickUpAddressName.length) {
                
                _selfAdressLabel.text = _pickUpAddressName;
                
                _selfSendBtn.selected = YES;
            }
            return cell;
            
        }else if (indexPath.section == 9){
            
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = NO;
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
            label.text = @"备注消息:";
            label.font = [UIFont systemFontOfSize:14];
            [label setTextColor:[UIColor blackColor]];
            //
            _textView =[[UITextView alloc] initWithFrame:CGRectMake(70, 4, ScreenW - 100, 67)];
            _textView.font = [UIFont systemFontOfSize:14];
            _textView.delegate = self;
            
            _textView.text = _textContentSting;
            [cell.contentView addSubview:_textView];
            [cell.contentView addSubview:label];
            return cell;
        }

    }else if (tableView == _convertPaperTableView) {
        
        CovertPaperTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:coverPaperIndertifier forIndexPath:indexPath];
        
        CouponnsModel * model= self.couponDataArray[indexPath.row];
        
        cell.model = model;
        
        return cell;
    }
     return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _mainTableView) {
        if (section == 0) {
            
            return 0.1;
        } else if (section ==1){
            
            return 0.1;
        }
        else if (section == 5){
            
            return 0.1;
        } else if (section == 6){
            
            return 1;
            
        } else if (section ==7){
            
            return 1;
        } else if (section == 8){
            
            return 1;
        }

    }
   
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _mainTableView) {
        if (section == 0) {
            return 0;
        } else if (section ==4){
            return 8;
        } else if (section == 5){
            return 1;
        } else if (section ==6){
            return 35;
        } else if (section ==7){
            return 1;
        } else if (section ==8){
            return 1;
        }
    }
      return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 6) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
        bgView.backgroundColor = [UIColor whiteColor];
        //分割线
        UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
        [bgView addSubview:seperateView];
        //sb图片
        UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
        [imageView setImage:[UIImage imageNamed:@"btn_shopcart_shrink@2x"]];
        imageView.center = CGPointMake(ScreenW /2.0f, 17);
        [bgView addSubview:imageView];
        
        return bgView;
    }
   else if (section == 9) {
        //背景图
        UIView * buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
        buttonBgView.backgroundColor = [UIColor colorWithHexString:BackColor];
        //创建BUtton
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, ScreenW - 20, 50)];
        //设置字体和圆角
        button.layer.cornerRadius = 5;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = [UIColor colorWithHexString:MainColor];
        [button setTitle:@"确定兑换" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sureConvertAction) forControlEvents:UIControlEventTouchDown];
        [buttonBgView addSubview:button];
        tableView.tableFooterView = buttonBgView;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==_mainTableView) {
        if (indexPath.section == 0) {
            return 120;
        } else if (indexPath.section == 1){
            return 106;
        } else if (indexPath.section == 2){
            return 40;
        } else if (indexPath.section == 3){
            return 40;
        } else if (indexPath.section == 4){
            return 35;
        } else if (indexPath.section == 5){
            return 35;
        } else if (indexPath.section == 6){
            return 140;
        } else if (indexPath.section == 7){
            return 35;
        }else if (indexPath.section ==8){
            return 70;
        }else if (indexPath.section == 9){
            return 72;
        }
    } else if (tableView == _convertPaperTableView){
        return 35;
    }

    return 0;
}
//跳转到收货地址
#pragma mark ----选择兑换券
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _mainTableView) {
        if (indexPath.section == 0) {
            
          RecivePlaceTableViewController   * edictPlaceVC = [[RecivePlaceTableViewController alloc] init];
            
            [self.navigationController pushViewController:edictPlaceVC animated:YES];
            
            //跳转到商品列表
        }else if (indexPath.section == 1){

            GoodsLIstViewController * goodListVC = [[GoodsLIstViewController alloc] init];
            if (_shopCartype == 1) {
                
                goodListVC.shopCarType = 1;
                for ( HDShopCarModel * goodModel in self.ImageArray) {
                    
                    [goodListVC.goodsModelArray addObject:goodModel];
                    
                }
            }else{
                
                for ( IntergerGoodsDetailModel * goodModel in self.ImageArray) {
                    
                    [goodListVC.goodsModelArray addObject:goodModel];
                    
                }
            }
          

            [self.navigationController pushViewController:goodListVC animated:YES];
         }
    } else if (tableView == _convertPaperTableView){
        
        CovertPaperTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
        CouponnsModel *model = self.couponDataArray[indexPath.row];
        
        //计算劵的总数
        NSInteger totalCount = 0;
        
        if (model.isSelected == YES) {
            
  
            model.isSelected = NO;
            cell.selectedStateBtn.selected = NO;
            [self.caputelateArray removeObject:model];
            
            
            for (CouponnsModel *model in self.caputelateArray) {
                
                totalCount = model.value + totalCount;
                
            }
            _totalCouponLabel.text =[NSString stringWithFormat:@"%ld积分", totalCount];
            _totalCount = totalCount;
            
        }else{
            
            model.isSelected = YES;
            cell.selectedStateBtn.selected = YES;
            
            [self.caputelateArray addObject:model];
            

            for (CouponnsModel *model in self.caputelateArray) {
                
                totalCount = model.value + totalCount;
            
            }
            _totalCount = totalCount;
            _totalCouponLabel.text =[NSString stringWithFormat:@"%ld积分", totalCount];
            
        }
    }
}

#pragma mark ---计算快递费

-(void)requestSendFee{
    
    NSMutableString * goodsID = [NSMutableString string];
    
    for (int i = 0; i< self.goodIdaArray.count; i++) {
        
        [goodsID appendString:[NSString stringWithFormat:@"%@,",self.goodIdaArray[i]]];
    }
    if (goodsID.length) {
        
        [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
    }
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"areaId"] =[NSString stringWithFormat:@"%ld",self.placeModel.id];
    if (_type == 1) {
        
        //立即兑换
        param[@"cartIds"] = [NSString stringWithFormat:@"%ld",_cartId];
    } else {
        //购物车
        param[@"cartIds"] = goodsID;
    }
    
    [weakself POST:calculateFreightUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            //获取快递费
            _sendPrice = responseObject[@"result"][@"fee"];
            _sendBtn.selected = YES;

                [_totalLabel setText:[NSString stringWithFormat:@"%@元",_sendPrice]];
                _sendType = 1;

        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [_mainTableView reloadData];
//        });

    } failure:^(NSError *error) {
        
        
    }];


}
#pragma mark ---选择提货方式
-(void)queuelySned:(UIButton *)sender{
    
    
    _index = sender.tag - buttonTag;
     //快递
    if (_index == 0 ) {
        
        _sendBtn.selected = YES;
        _selfSendBtn.selected = NO;
        if (_isSetAdress == YES) {
            //清空自提
            _pickUpAddressName = @"";
            _selfAdressLabel.text = @"";
            sender.selected = YES;
            
            [self requestSendFee];

        }else{
            
            [self showStaus:@"请先填写收货地址"];

        }
        
    } else if (_index ==  1){
        
        
        //自提
        
        if (_isSetAdress == YES) {
          
            
            SelfSendViewController * selfSendVC = [[SelfSendViewController alloc] init];
            selfSendVC.block = ^(NSString * adressId,NSString * adressName){
                //清空快递
                _sendPrice = @"";
                _totalLabel.text = @"";
                
                _pickUpAddressId = adressId;
                _pickUpAddressName = adressName;
                _selfAdressLabel.text = adressName;
                _selfSendBtn.selected = YES;
                _sendBtn.selected = NO;
                
                 _sendType = 2;

            };
            
            [self.navigationController pushViewController:selfSendVC animated:YES];
        }else{
            
            [self showStaus:@"请先填写收货地址"];
        }
       
    }
    
}

#pragma mark ------确定兑换
-(void)sureConvertAction{
    //创建订单
    if (_isSetAdress == NO) {
        
        [self showStaus:@"请先填写收货地址"];
    } else  if ([User defalutManager].integral + _totalCount < _totalPrice) {
        
        [self showStaus:@"你的积分不足"];
        
    }else if ( _sendBtn.selected == NO && _selfSendBtn.selected == NO){
      
        [self showStaus:@"请选择提货方式"];

    }else{
        
        [SVProgressHUD showWithStatus:@"正在生成兑换订单"];
        [self requestOrderData];
    }
}
-(void)requestOrderData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSMutableString * goodsID = [NSMutableString string];
    
    for (int i = 0; i< self.goodIdaArray.count; i++) {
        
        [goodsID appendString:[NSString stringWithFormat:@"%@,",self.goodIdaArray[i]]];
        
    }
    if (goodsID.length) {
        
        [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
    }
    //必填参数
//    param[@"cartIds"] = [NSString stringWithFormat:@"%ld",_cartId];
    if (_type == 1) {
        
        //立即兑换
        param[@"cartIds"] = [NSString stringWithFormat:@"%ld",_cartId];
    } else {
        //购物车
        param[@"cartIds"] = goodsID;
    }
    param[@"type"] = [NSString stringWithFormat:@"%ld",self.type];
    
    param[@"sendType"] =[NSString stringWithFormat:@"%ld",_sendType];
    
    //选填参数
    //劵
    NSMutableString * couponsString = [NSMutableString string];
    if (self.caputelateArray.count > 0) {
        for (CouponnsModel * model in self.caputelateArray) {
            
            NSString * str =[NSString stringWithFormat:@",%ld",model.id];
            [couponsString appendFormat:@"%@",str];
        }
        if (couponsString.length) {
            
            [couponsString deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        
        param[@"couponIds"] = couponsString;
        
    }
    
    if (_sendType == 1) {
        
        param[@"addressId"] =[NSString stringWithFormat:@"%ld", self.placeModel.id];
        
    }else if (_sendType == 2){
        
        param[@"pickUpAddressId"] =_pickUpAddressId;
        
        param[@"addressId"] =[NSString stringWithFormat:@"%ld", self.placeModel.id];
    }
    //立即兑换
//    if (self.type == 1) {
        
        param[@"count"] = [NSString stringWithFormat:@"%ld" ,self.count];
//    }
    
    param[@"igo_msg"] = _textView.text;
    
    [weakself POST:createIntegralOrderUrl parameters:param success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSDictionary * dic  = [NSDictionary dictionary];
            dic = responseObject[@"result"];
            
            ReadPayViewController * readPayVC =[[ReadPayViewController alloc] init];
            //购物车被兑换的数量
            readPayVC.shopCarNumber = _shopCarNumber;
            
            //从哪儿进入的订单方式
            readPayVC.categoryType = _type;
            readPayVC.backString = @"NotPayYet";
            
            if (_sendType == 1) {
                //快递
                readPayVC.sendType = 1;
                //交流困难，自己计算本地的购物车数量
                
                //订单类型，兑换订单
                readPayVC.orderType = 3;
                readPayVC.sendPriceValue = _sendPrice;
                readPayVC.orderId = dic[@"igo_order_id"];
                readPayVC.integral = dic[@"total_integral"];
                readPayVC.order_sn = dic[@"igo_order_sn"];
                readPayVC.price = dic[@"total_cash"];
                
                [self.navigationController pushViewController:readPayVC animated:YES];
                
                
            }else if (_sendType == 2){
                //自提
                readPayVC.sendType = 2;
                //订单类型,兑换订单
                readPayVC.orderType = 3;
                readPayVC.orderId = dic[@"igo_order_id"];
                readPayVC.integral = dic[@"total_integral"];
                readPayVC.order_sn = dic[@"igo_order_sn"];
                readPayVC.price = dic[@"total_cash"];
                readPayVC.sendPriceValue = @"0";
                
                [self.navigationController pushViewController:readPayVC animated:YES];
                
            }
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];


}
//收起键盘
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    _textContentSting = _textView.text ;

    [self.view endEditing:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
 
    [UIView animateWithDuration:0.6 animations:^{
        
    _mainTableView.contentOffset = CGPointMake(0, 500);

    }];
    
}
#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
