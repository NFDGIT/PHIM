//
//  PHDocumentPickerViewController.m
//  YYIM
//
//  Created by Jobs on 2018/8/6.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PHDocumentPickerViewController.h"

@interface PHDocumentPickerViewController ()<UIDocumentPickerDelegate>

@end

@implementation PHDocumentPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- delegate
-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    
    if (_selectBlock) {
        _selectBlock(urls);
    }
    
}
-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url{
    if (_selectBlock) {
        _selectBlock(@[url]);
    }
    
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    
    
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
