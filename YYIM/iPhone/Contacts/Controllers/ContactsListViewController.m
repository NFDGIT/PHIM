//
//  ContactsListViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ContactsListViewController.h"

#import "ContactsListTableViewCell.h"


#import "ContactsListModel.h"
#import "ChatViewController.h"
#import "PersonDetailViewController.h"



@interface ContactsListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * showDatas;
@property (nonatomic,strong)NSMutableArray * datas;
//@property (nonatomic,strong)NSMutableArray * showDatas;
@end

@implementation ContactsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    
    [self refreshData];
    // Do any additional setup after loading the view.
}
-(void)initNavi{
//    self.title = @"联系人";
}
-(void)initData{
    _showDatas = [NSMutableArray array];
    _datas = [NSMutableArray array];
}
-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor  =[UIColor whiteColor];
    [_tableView registerClass:[ContactsListTableViewCell class] forCellReuseIdentifier:@"contactsCell"];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
}

-(void)refreshUI{
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
}
-(void)refreshData{

    [ProgressTool show];
    [Request getUserListSuccess:^(NSUInteger code, NSString *msg, id data) {
        [ProgressTool hidden];

        if (code == 200) {
            NSArray * nodes = data;

            NSMutableArray * models = [NSMutableArray array];
            for (NSDictionary * dic  in nodes) {
                ContactsListModel * model = [ContactsListModel new];
                [model setValuesForKeysWithDictionary:dic];
                [models addObject:model];
            }
            [self->_datas removeAllObjects];
            [self->_datas addObjectsFromArray:models];
            self->_showDatas= [self resolveDatas:[self getAllDatasWithDatas:self->_datas]];
        }else{
            [self.view makeToast:msg duration:2 position:CSToastPositionCenter];

        }
        
         [self refreshUI];
    } failure:^(NSError *error) {
         [self refreshUI];
       [ProgressTool hidden];
        [self.view makeToast:@"网络请求失败" duration:2 position:CSToastPositionCenter];
        
    }];

//
//
    NSDictionary * data =  @{
                             @"code":@"200",
                             @"msg":@"成功",
                             @"data": @{
                                     @"Nodes": @[@{
                                                     @"Text": @"总裁办",
                                                     @"ImageIndex":@"55",
                                                     @"SelectedImageIndex":@"0",
                                                     @"Checked": @"false",
                                                     @"Expanded": @(YES),
                                                     @"Tag": @"1",
                                                     @"Nodes": @[@{
                                                                     @"Text":@"副总裁助理",
                                                                     @"ImageIndex":@"1",
                                                                     @"SelectedImageIndex":@"1",
                                                                     @"Checked":@"false",
                                                                     @"Expanded":@(YES),
                                                                     @"Tag": @"2",
                                                                     @"Nodes": @[@{
                                                                                     @"Text":@"技术部",
                                                                                     @"ImageIndex": @"20",
                                                                                     @"SelectedImageIndex":@"20",
                                                                                     @"Checked": @"false",
                                                                                     @"Expanded": @(YES),
                                                                                     @"Tag": @"13718967990",
                                                                                     @"Nodes": @[@{
                                                                                                     @"Text":@"鞠文竹-13718967990",
                                                                                                     @"ImageIndex": @"20",
                                                                                                     @"SelectedImageIndex":@"20",
                                                                                                     @"Checked": @"false",
                                                                                                     @"Expanded": @(NO),
                                                                                                     @"Tag": @"13718967990",
                                                                                                     @"Nodes": @[]
                                                                                                     }, @{
                                                                                                     @"Text": @"刘洋-15801603945",
                                                                                                     @"ImageIndex": @"12",
                                                                                                     @"SelectedImageIndex": @"0",
                                                                                                     @"Checked": @"false",
                                                                                                     @"Expanded": @(NO),
                                                                                                     @"Tag": @"15801603945",
                                                                                                     @"Nodes": @[]
                                                                                                     }]
                                                                                     }, @{
                                                                                     @"Text": @"刘洋-15801603945",
                                                                                     @"ImageIndex": @"44",
                                                                                     @"SelectedImageIndex": @"0",
                                                                                     @"Checked": @"false",
                                                                                     @"Expanded": @(NO),
                                                                                     @"Tag": @"15801603945",
                                                                                     @"Nodes": @[]
                                                                                     }]
                                                                     }
                                                                 ]

                                                     },
                                                 @{
                                                     @"Text": @"总裁办",
                                                     @"ImageIndex":@"33",
                                                     @"SelectedImageIndex":@"0",
                                                     @"Checked": @"false",
                                                     @"Expanded": @(YES),
                                                     @"Tag": @"1",
                                                     @"Nodes": @[@{
                                                                     @"Text":@"副总裁助理",
                                                                     @"ImageIndex":@"1",
                                                                     @"SelectedImageIndex":@"1",
                                                                     @"Checked":@"false",
                                                                     @"Expanded":@(NO),
                                                                     @"Tag": @"2",
                                                                     @"Nodes": @[@{
                                                                                     @"Text":@"鞠文竹-13718967990",
                                                                                     @"ImageIndex": @"20",
                                                                                     @"SelectedImageIndex":@"20",
                                                                                     @"Checked": @"false",
                                                                                     @"Expanded": @(YES),
                                                                                     @"Tag": @"13718967990",
                                                                                     @"Nodes": @[]
                                                                                     }, @{
                                                                                     @"Text": @"刘洋-15801603945",
                                                                                     @"ImageIndex": @"12",
                                                                                     @"SelectedImageIndex": @"0",
                                                                                     @"Checked": @"false",
                                                                                     @"Expanded": @(YES),
                                                                                     @"Tag": @"15801603945",
                                                                                     @"Nodes": @[]
                                                                                     }]
                                                                     }
                                                                 ]

                                                     }

                                                 ]

                                     }

                             };



    NSArray * nodes = data[@"data"][@"Nodes"];

    NSMutableArray * models = [NSMutableArray array];
    for (NSDictionary * dic  in nodes) {
        ContactsListModel * model = [ContactsListModel new];
        [model setValuesForKeysWithDictionary:dic];
        [models addObject:model];
    }
    [_datas removeAllObjects];
    [_datas addObjectsFromArray:models];



    _showDatas =[self resolveDatas:[self getAllDatasWithDatas:_datas]];


    [self refreshUI];
}

#pragma mark -- delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _showDatas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightWithIndexPath:indexPath];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
    ContactsListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell" forIndexPath:indexPath];


    ContactsListModel * model = _showDatas[indexPath.row];
    cell.indexPath = indexPath;
    cell.model = model;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self rowClickWithRow:indexPath.row];
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSMutableArray *)setExtenWithIndex:(NSUInteger)index models:(NSMutableArray<ContactsListModel *> *)models{
    NSMutableArray * showDatas  = models;
    return showDatas;
}

#pragma mark -- 处理 多级列表的一些逻辑
/**
 列表的点击事件

 @param row 第几行
 */
-(void)rowClickWithRow:(NSUInteger)row{
    ContactsListModel * model = _showDatas[row];
    if (model.Nodes.count <= 0) {
        
        
        
        MessageTargetModel * target = [MessageTargetModel new];
        target.Id = model.Tag;
        target.imgUrl = model.ImageIndex;
        target.name = model.Text;
        
        ChatViewController * chatvc = [ChatViewController new];
//        chatvc.userId = model.Tag;
        chatvc.targetModel = target;
        [self.navigationController pushViewController:chatvc animated:YES];
        
        
        
//        PersonDetailViewController * detail = [PersonDetailViewController new];
//        detail.Id = @"";
//        [self.navigationController pushViewController:detail animated:YES];
        
        return;
    }
    
    
    if (model.level.count == 1) { // 一层
        NSInteger lev0 = [model.level[0] integerValue];
        ContactsListModel * model0 = _datas[lev0];
        model0.Expanded = !model0.Expanded;
        
        _showDatas = [self resolveDatas:[self getAllDatasWithDatas:_datas]];
        [_tableView reloadData];
    }
    if (model.level.count == 2) { // 二层
        NSInteger lev0 = [model.level[0] integerValue];
        ContactsListModel * model0 = _datas[lev0];
        NSMutableArray * nodes0 = [NSMutableArray arrayWithArray:model0.Nodes];
        
        
        NSInteger lev1 = [model.level[1] integerValue];
        ContactsListModel * model1 = model0.Nodes[lev1];
        model1.Expanded = !model1.Expanded;
        
        
        [nodes0 replaceObjectAtIndex:lev1 withObject:model1];
        model0.Nodes = nodes0;
        
        _showDatas = [self resolveDatas:[self getAllDatasWithDatas:_datas]];
        [_tableView reloadData];
        
    }
    if (model.level.count == 3) { // 三层
        NSInteger lev0 = [model.level[0] integerValue];
        ContactsListModel * model0 = _datas[lev0];
        NSMutableArray * nodes0 = [NSMutableArray arrayWithArray:model0.Nodes];
        
        
        NSInteger lev1 = [model.level[1] integerValue];
        ContactsListModel * model1 = model0.Nodes[lev1];
        NSMutableArray * nodes1 = [NSMutableArray arrayWithArray:model1.Nodes];
        
        
        NSInteger lev2 = [model.level[2] integerValue];
        ContactsListModel * model2 = model1.Nodes[lev2];
        model2.Expanded =!model2.Expanded;
        
        
        
        
        [nodes1 replaceObjectAtIndex:lev2 withObject:model2];
        model1.Nodes = nodes1;
        
        [nodes0 replaceObjectAtIndex:lev1 withObject:model1];
        model0.Nodes = nodes0;
        
        
        _showDatas = [self resolveDatas:[self getAllDatasWithDatas:_datas]];
        [_tableView reloadData];
        
    }
    
    
}

/**
  将 树状数据 转化为界面上显示的依次排序 的数组

 @param datas 原始的树状 model数组
 @return 依次排序的全部数据
 */
-(NSMutableArray *)getAllDatasWithDatas:(NSMutableArray *)datas{
    NSMutableArray * allDatas = [NSMutableArray array];
    for (int x = 0; x < datas.count; x ++) {
        ContactsListModel * model = datas[x];
        model.level = @[@(x)];
        [allDatas addObject:model];
        
        
        for (int y = 0; y < model.Nodes.count; y ++) {
            ContactsListModel * model1 = model.Nodes[y];
            model1.level = @[@(x),@(y)];
            [allDatas addObject:model1];
            
            for (int z = 0; z < model1.Nodes.count; z ++) {
                ContactsListModel * model2 = model1.Nodes[z];
                model2.level = @[@(x),@(y),@(z)];
                [allDatas addObject:model2];
                
                
                for (int w = 0; w < model2.Nodes.count; w ++) {
                    ContactsListModel * model3 = model2.Nodes[w];
                    model3.level = @[@(x),@(y),@(z),@(w)];
                    [allDatas addObject:model3];
                    
                };
            };
        };
    };
    return allDatas;
}

/**
 将可以显示的数据 依次放到showDatas 数组里面

 @param datas 原始的树状 model数组
 @return 返回 要显示的数据
 */
-(NSMutableArray *)resolveDatas:(NSMutableArray *)datas{
    NSMutableArray * showDatas = [NSMutableArray array];
    for (int x = 0; x < datas.count; x ++) {
        ContactsListModel * model = datas[x];
        if ([self isShowWithDatas:_datas model:model]) {
          [showDatas addObject:model];
        }
    };
    return showDatas;
}


/**
 判断是不是 要显示

 @param datas 保持树状结构的数据
 @param model 要判断的model
 @return 返回是不是要显示
 */
-(BOOL)isShowWithDatas:(NSArray *)datas model:(ContactsListModel *)model{
    if (model.level.count <= 1 ) {
        return YES;
    };
    for (int i = 1; i < model.level.count; i ++) {///
            // 第几级 的时候在第几个
        if (i == 1) {
            NSInteger lev0 =  [model.level[0] integerValue];
            ContactsListModel * model0 = datas[lev0];
            
            if (!model0.Expanded) {
                return NO;
            }
        }
        
        if (i == 2) {
            NSInteger lev0 =  [model.level[0] integerValue];
            ContactsListModel * model0 = datas[lev0];
            

            NSInteger lev1 = [model.level[1] integerValue];
            ContactsListModel * model1 = model0.Nodes[lev1];
            
            
            NSLog(@"%ld: %ld ::::%@",(long)lev0,(long)lev1,model1.Expanded?@"yes":@"no");
            if (!model0.Expanded) {
                return NO;
            }
            if (!model1.Expanded) {
                return NO;
            }
        }
        if (i == 3) {
            NSInteger lev0 =  [model.level[0] integerValue];
            ContactsListModel * model0 = datas[lev0];
            
            
            NSInteger lev1 = [model.level[1] integerValue];
            ContactsListModel * model1 = model0.Nodes[lev1];
            
            NSInteger lev2 = [model.level[2] integerValue];
            ContactsListModel * model2 = model1.Nodes[lev2];
            
            
            NSLog(@"%ld: %ld ::::%@",(long)lev0,(long)lev1,model1.Expanded?@"yes":@"no");
            if (!model0.Expanded) {
                return NO;
            }
            if (!model1.Expanded) {
                return NO;
            }
            if (!model2.Expanded) {
                return NO;
            }
        }
     
        
        
     
    }
    return YES;

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
