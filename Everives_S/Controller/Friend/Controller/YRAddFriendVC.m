//
//  YRAddFriendVC.m
//  Everives_S
//
//  Created by darkclouds on 16/3/16.
//  Copyright © 2016年 darkclouds. All rights reserved.
//

#import "YRAddFriendVC.h"
#import "RequestData.h"
#import "YRUserStatus.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
@interface YRAddFriendVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSArray *_resArray;
}
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UIButton *phoneContact;
@property(nonatomic,strong) UITableView *resTable;
@end

@implementation YRAddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.phoneContact];
    [self.view addSubview:self.resTable];

}
-(void)phoneContactBtnClick:(UIButton*)sender{
    
}


#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [RequestData GET:[NSString stringWithFormat:@"%@%@",STUDENT_SEARCH_USER,_searchBar.text]  parameters:nil complete:^(NSDictionary *responseDic) {
        _resArray = [YRUserStatus mj_objectArrayWithKeyValuesArray:responseDic];
        [_resTable reloadData];
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - UItableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 25;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[_resArray[indexPath.row] avatar]]];
    cell.textLabel.text = [_resArray[indexPath.row] name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - Getters
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 60)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入驾友用户名或手机号码";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}
-(UIButton *)phoneContact{
    if (!_phoneContact) {
        _phoneContact = [[UIButton alloc] initWithFrame:CGRectMake(8, 128, kScreenWidth-16, 44)];
        [_phoneContact setTitle:@"关注手机联系人" forState:UIControlStateNormal];
        [_phoneContact setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_phoneContact addTarget:self action:@selector(phoneContactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _phoneContact.layer.masksToBounds = YES;
        _phoneContact.layer.cornerRadius = 5;
        _phoneContact.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _phoneContact.layer.borderWidth = 0.5;
    }
    return _phoneContact;
}
-(UITableView *)resTable{
    if (!_resTable) {
        _resTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 175, kScreenWidth, kScreenHeight)];
        _resTable.tableFooterView = [[UIView alloc] init];
        _resTable.rowHeight = 50;
        _resTable.delegate = self;
        _resTable.dataSource = self;
    }
    return _resTable;
}
@end
