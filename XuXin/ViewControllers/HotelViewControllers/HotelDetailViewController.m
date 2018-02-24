//
//  HotelDetailViewController.m
//  XuXin
//
//  Created by xian on 2018/2/3.
//  Copyright © 2018年 xienashen. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "HotelHeaderSectionView.h"
#import "RoomListTableViewCell.h"

@interface HotelDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, strong) UITableView *roomTableView;

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self requestData];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor cyanColor];
    
    if (!_roomTableView) {
        _roomTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _roomTableView.delegate = self;
        _roomTableView.dataSource = self;
        [self.view addSubview:_roomTableView];
    }
    
    [self.roomTableView registerClass:[RoomListTableViewCell class] forCellReuseIdentifier:@"RoomListTableViewCell"];
    
}

- (void)requestData {
    
}


#pragma -mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RoomListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomListTableViewCell" forIndexPath:indexPath];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
