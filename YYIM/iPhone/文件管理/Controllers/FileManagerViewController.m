//
//  FileManagerViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/30.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "FileManagerViewController.h"
#import "FileManagerCollectionViewCell.h"
#import "TabBarController.h"


@interface FileManagerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView  * collectionView;
@property (nonatomic,strong)NSMutableArray * datas;

@end

@implementation FileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    [self refreshData];
    // Do any additional setup after loading the view.
}

-(void)show{
    NavigationController * navi = [[NavigationController alloc]initWithRootViewController:self];
    [[TabBarController share]presentViewController:navi animated:YES completion:^{
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
}
-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}



-(void)initData{
    _datas = [NSMutableArray array];
}
-(void)initNavi{
    self.title = @"文件夹";
    
}
-(void)initUI{
    
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((self.view.width - 10)/4 - 10 , (self.view.width - 50)/4  * 1.3);
    layout.estimatedItemSize = CGSizeMake((self.view.width - 20)/4 , (self.view.width - 20)/4  * 1.3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(self.view.width, 40);
    layout.footerReferenceSize = CGSizeMake(self.view.width, 40);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    
    
    
    _collectionView= [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = ColorBack;
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[FileManagerCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    
    
    
    
    
}
-(void)refreshData{

    if (!_filePath) {
        NSString *homePath = NSHomeDirectory();
        _filePath = homePath;

    }

    

    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray * fileSubs =    [manager contentsOfDirectoryAtPath:_filePath error:nil];
    
    [_datas removeAllObjects];
    for (NSString * fileName in fileSubs) {
        
        NSString * currentPath = [NSString stringWithFormat:@"%@/%@",_filePath,fileName];
        NSDictionary * fileAttri = [manager attributesOfItemAtPath:currentPath error:nil];
        
        
        FileManagerModel * model = [FileManagerModel new];
        model.filePath = currentPath;
        model.fileName = fileName;
        model.fileAttributes = fileAttri;
        
        [_datas addObject:model];
        
    }
    
    
    


    
    
    
    
    [self refreshUI];
}
-(void)refreshUI{
    [_collectionView reloadData];
    NSArray * filepathcompont = [_filePath componentsSeparatedByString:@"/"];
    
    
     self.title = filepathcompont.lastObject;
    
    
    
}
#pragma mark -- delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _datas.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FileManagerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    FileManagerModel * model = _datas[indexPath.row];
    
    
    
    cell.model = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     FileManagerModel * model = _datas[indexPath.row];


    NSString *  fileType = model.fileAttributes[NSFileType];
    if ([fileType isEqualToString:NSFileTypeDirectory]) {
        FileManagerViewController * fileManger = [FileManagerViewController new];
        fileManger.filePath = model.filePath;
        [self.navigationController pushViewController:fileManger animated:YES];
    }else{
        if ([self getRootVC].selectBlock) {
            NSURL * url = [NSURL URLWithString:model.filePath];
            [self exitWithUrl:url];
            
        }
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 退出并返回 文件
-(void)exitWithUrl:(NSURL *)url{

    
    if ([self getRootVC].selectBlock) {
        [self getRootVC].selectBlock(url);
        [[self getRootVC] dismiss];
        [self.navigationController popToRootViewControllerAnimated:NO];

        
    }

}
-(instancetype)getRootVC{
    return  (FileManagerViewController *)(self.navigationController.viewControllers.firstObject);
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
