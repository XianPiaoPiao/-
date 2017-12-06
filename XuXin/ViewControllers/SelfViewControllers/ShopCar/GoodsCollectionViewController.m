//
//  GoodsCollectionViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/27.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "GoodsCollectionViewController.h"
#import "GoodsCollectionTableViewCell.h"
NSString * const goodsCollectionIdertifer = @"GoodsCollectionTableViewCell";
@interface GoodsCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GoodsCollectionViewController{
    UITableView * _tableView;
}

- (void)viewDidLoad {
        [super viewDidLoad];
    
        [self creatTableView];
    //注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allSelect) name:@"allSelect" object:nil];

      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(edict) name:@"edict" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(compelete) name:@"compelete" object:nil];
    //删除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteIsSelcted) name:@"delete" object:nil];

}
//删除收藏的cell
-(void)deleteIsSelcted{
    for (GoodsCollectionTableViewCell * cell in  _tableView.visibleCells) {
        if (cell.selected == YES) {
            //删除数据，再删除UI
      //      NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
      //      [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    
        }
    }
}
-(void)compelete{
    for (GoodsCollectionTableViewCell * cell in  _tableView.visibleCells) {
        
        [UIView animateWithDuration:0.4 animations:^{
            cell.contentView.frame= CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        }];
        
        
    }
}
-(void)edict{
    for (GoodsCollectionTableViewCell * cell in  _tableView.visibleCells) {
   
        [UIView animateWithDuration:0.4 animations:^{
              cell.contentView.frame = CGRectMake(30, 0, cell.frame.size.width, cell.frame.size.height);
        }];
      
     
    }
}
//选中cell
-(void)allSelect{
   
    for (GoodsCollectionTableViewCell * cell in  _tableView.visibleCells) {
        
        cell.contentView.frame = CGRectMake(30, 0, cell.frame.size.width, cell.frame.size.height);
        
    }
  
}



-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH ) style:UITableViewStylePlain];
    _tableView.rowHeight = 80;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"GoodsCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:goodsCollectionIdertifer];
}
#pragma mark ---TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsCollectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsCollectionIdertifer forIndexPath:indexPath];
  
    return cell;
}
//改变button的状态
-(void)exchageImage:(UIButton *)btn{
    
    static int i = 0;
    if (i== 0) {
    btn.selected = YES;
        i++;
    } else if (i ==1){
        btn.selected =NO;
        i--;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    GoodsCollectionTableViewCell * currentSelectedcell =  (GoodsCollectionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    currentSelectedcell.selected = YES;
    
}
//移除观察者

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
