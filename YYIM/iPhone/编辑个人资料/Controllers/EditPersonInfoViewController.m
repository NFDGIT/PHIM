//
//  EditPersonInfoViewController.m
//  YYIM
//
//  Created by Jobs on 2018/8/22.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "EditPersonInfoViewController.h"
#import "UserInfoModel.h"
#import "PersonManager.h"

@interface EditPersonInfoViewController ()
@property (nonatomic,strong)UserInfoModel * infoModel;

@property (nonatomic,strong)UILabel * labelEmail;
@property (nonatomic,strong)UILabel * labelAge;
@property (nonatomic,strong)UILabel * labelPhone;
@property (nonatomic,strong)UILabel * labelAddress;
@property (nonatomic,strong)UILabel * labelSign;
@end

@implementation EditPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    
    [self refreshData];
    // Do any additional setup after loading the view.
}
-(void)initData{
    
    
}
-(void)initNavi{
    self.title = @"编辑资料";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}
-(void)refreshData{
    if (_userId) {
        _infoModel = [[PersonManager share]getModelWithId:_userId];
        [self refreshUI];
    }
    

}

-(void)initUI{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:scrollView];
    
    __block CGFloat setY = 10;
    
    
    
    
 
    for (int i = 0; i < 6; i ++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, setY, scrollView.width, 60)];
        btn.backgroundColor = ColorWhite;
        setY = btn.bottom;
        [scrollView addSubview:btn];
        
        
        UILabel * labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 30)];
        labelTitle.centerY = btn.height/2;
        labelTitle.font = FontNormal;
        labelTitle.textColor = ColorBlack;
        [btn addSubview:labelTitle];
        
        
        UILabel * labelContent = [[UILabel alloc]initWithFrame:CGRectMake(labelTitle.right+ 40, 10, 150, 20)];
        labelContent.centerY = labelTitle.centerY;
        [btn addSubview:labelContent];
        labelContent.font = FontNormal;
        labelContent.textColor = ColorGray;
        
        
        UIImageView * imgArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
        imgArrow.backgroundColor = ColorGray;
        [btn addSubview:imgArrow];
        imgArrow.right = btn.width - 10;
        imgArrow.centerY = btn.height/ 2;
        
        
        
        UILabel * labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        [btn addSubview:labelDesc];
        labelDesc.textColor = ColorGray;
        labelDesc.font = FontNormal;
        labelDesc.textAlignment = NSTextAlignmentRight;
        labelDesc.right = imgArrow.left - 10;
        labelDesc.centerY = imgArrow.centerY;
        
        
        
        UIImageView * imgline = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, btn.width, 0.5)];
        imgline.backgroundColor = ColorGray;
        [btn addSubview:imgline];
        imgline.bottom = btn.height;
        
        
        switch (i) {
            case 0:
                labelTitle.text = @"邮箱";
                labelContent.text = @"你的邮箱";
                _labelEmail = labelContent;
                break;
            case 1:
                labelTitle.text = @"年龄";
                labelDesc.text = @"18岁";
                _labelAge = labelDesc;
                break;
            case 2:
                labelTitle.text = @"电话";
                labelContent.text = @"你的电话";
                _labelPhone = labelContent;
                break;
            case 3:
                labelTitle.text = @"邮箱";
                labelContent.text = @"你的邮箱";
                break;
            case 4:
                labelTitle.text = @"地址";
                labelDesc.text = @"北京-海淀";
                _labelAddress = labelDesc;
                break;
            case 5:
                labelTitle.text = @"签名";
                labelContent.text = @"你的签名";
                _labelSign = labelContent;
                break;
                
            default:
                break;
        }
    }
    
    
    
}

-(void)refreshUI{
    if (_infoModel) {
        _labelEmail.text = [NSString stringWithFormat:@"%@",_infoModel.Email];
        _labelAge.text = [NSString stringWithFormat:@"%@岁",@""];
        _labelPhone.text = [NSString stringWithFormat:@"%@",_infoModel.Phone];
        _labelAddress.text = [NSString stringWithFormat:@"%@",@""];
        _labelSign.text = [NSString stringWithFormat:@"%@",_infoModel.UnderWrite];
        
    }
    
    
}
#pragma mark -- done
-(void)done{
    
    
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
