//
//  ChatInputView.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatInputView.h"
#import <SVProgressHUD.h>

@interface ChatInputView()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField * textTF;
@end
@implementation ChatInputView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    
    _textTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, self.width - 20, self.height - 10)];
    _textTF.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9  alpha:0.8];
    _textTF.delegate = self;
    [self addSubview:_textTF];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _textTF.frame = CGRectMake(10, 5, self.width - 20, self.height - 10);
    
}

#pragma mark -- texttf delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length <= 0) {
//        [SVProgressHUD showWithStatus:@"请输入内容"];
        return NO;
    }
    
    
    if (_inputBlock) {
        _inputBlock(textField.text);
    }
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
