//
//  FileManagerViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/30.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "FileManager.h"
#import "FileManagerCollectionViewCell.h"
#import "TabBarController.h"


@interface FileManager ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView  * collectionView;
@property (nonatomic,strong)NSMutableArray * datas;

@end

@implementation FileManager

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
        NSString *filePath = [FileManager getResourceFolder];
        _filePath = filePath;

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
        FileManager * fileManger = [FileManager new];
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
    return  (FileManager *)(self.navigationController.viewControllers.firstObject);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**
 获取私人资源文件夹

 @return 文件夹路径
 */
+(NSString *)getResourceFolder{
    //获取Document文件
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    
    
    NSString * accountsFilePath = [docsdir stringByAppendingPathComponent:@"Accounts"];//将需要创建的串拼接到后面
    NSString * accountFilePath = [accountsFilePath stringByAppendingPathComponent:CurrentUserId];//
    NSString * resourceFilePath = [accountFilePath stringByAppendingPathComponent:@"resource"];//
    
    BOOL resourceIsDir = NO;
    BOOL resourceExisted = [fileManager fileExistsAtPath:resourceFilePath isDirectory:&resourceIsDir];

    if (resourceExisted) {
        return resourceFilePath;
    }else{
        [FileManager createResourceFolder];
        return [FileManager getResourceFolder];
    }
}
/**
 创建私人资源文件夹

 */
+(void)createResourceFolder{

        //获取Document文件
        NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        
        NSString * accountsFilePath = [docsdir stringByAppendingPathComponent:@"Accounts"];//将需要创建的串拼接到后面
        BOOL accountsIsDir = NO;
        // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        BOOL accountsExisted = [fileManager fileExistsAtPath:accountsFilePath isDirectory:&accountsIsDir];
        if ( !(accountsIsDir == YES && accountsExisted == YES) ) {//如果
            [fileManager createDirectoryAtPath:accountsFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        
    NSString * accountFilePath = [accountsFilePath stringByAppendingPathComponent:CurrentUserId];
        BOOL accountIsDir = NO;
        BOOL accountExisted = [fileManager fileExistsAtPath:accountFilePath isDirectory:&accountIsDir];
        if (!(accountIsDir == YES && accountExisted == YES) ) {
            [fileManager createDirectoryAtPath:accountFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    
    
    NSString * resourceFilePath = [accountFilePath stringByAppendingPathComponent:@"resource"];
    BOOL resourceIsDir = NO;
    BOOL resourceExisted = [fileManager fileExistsAtPath:resourceFilePath isDirectory:&resourceIsDir];
    if (!(resourceIsDir == YES && resourceExisted == YES) ) {
        [fileManager createDirectoryAtPath:resourceFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }


    
}
/**
 存储文件到私人资源文件
 */
+(void)saveImageToResourceFolder:(UIImage *)image{
    //拿到图片
    NSString *path_document = [FileManager getResourceFolder];
    //设置一个图片的存储路径
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSString *imagePath = [path_document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",str]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    
}

@end
