//
//  ChatInputView.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatInputView.h"

#import "EmotionView.h"
#import "ChatAddView.h"

#import "SmiliesAttributedString.h"


@interface ChatInputView()<UITextViewDelegate>



@property (nonatomic,strong)UIButton * addBtn;
@property (nonatomic,strong)UIButton * emotionBtn;
@property (nonatomic,strong)UITextView * textTF;
@property (nonatomic,strong)UIButton * textTFbtn;

@property (nonatomic,assign)NSUInteger index;

@end
@implementation ChatInputView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initData];
        [self initUI];
    }
    return self;
}
-(void)initData{
    _index = 0;
 
}
-(void)initUI{
    
    
    
    self.backgroundColor = [UIColor whiteColor];    
//    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 60)];
//    topView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:topView];
//    _topView = topView;
    
    
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self addSubview:addBtn];
    [addBtn setImage:[UIImage imageNamed:@"chat_add"] forState:UIControlStateNormal];
    _addBtn = addBtn;
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton * emotionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    emotionBtn.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:emotionBtn];
    [emotionBtn setImage:[UIImage imageNamed:@"chat_emotion"] forState:UIControlStateNormal];
    _emotionBtn = emotionBtn;
    [emotionBtn addTarget:self action:@selector(emotionClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _textTF = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.width - 20, self.height - 20)];
    _textTF.exclusiveTouch = NO;
    _textTF.layer.cornerRadius = 3;
    _textTF.layer.masksToBounds = YES;
    _textTF.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9  alpha:0.8];
    _textTF.font = FontBig;
    _textTF.delegate = self;
    _textTF.returnKeyType = UIReturnKeySend;
    [self addSubview:_textTF];
    
    
//    UIButton * textTFbtn = [[UIButton alloc]initWithFrame:_textTF.frame];
//    [self addSubview:textTFbtn];
//    _textTFbtn = textTFbtn;
//    _textTFbtn.exclusiveTouch = YES;
//    [_textTFbtn addTarget:self action:@selector(textViewClick) forControlEvents:UIControlEventTouchUpInside];

    
}
-(void)layout{
    _addBtn.right = self.width - 15;
    _emotionBtn.right = _addBtn.left - 15;
    
    _addBtn.centerY = _emotionBtn.centerY = _textTF.centerY = self.height/2;
    
    
    _textTF.width = _emotionBtn.left - _textTF.left - 15;
    
    
    [_textTF sizeToFit];
    if (_textTF.height < 20) {
        _textTF.height = 20;
    }
    if (_textTF.width < _emotionBtn.left - _textTF.left - 15) {
        _textTF.width = _emotionBtn.left - _textTF.left - 15;
    }
    _textTF.top = 10;
    
    
    
    
    self.height = _textTF.bottom + 10;
    
    
    _addBtn.bottom = _emotionBtn.bottom = _textTF.bottom;
    
    if(_changeHeightBlock){
        _changeHeightBlock();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layout];

}
#pragma mark -- 点击事件

/**
 表情
 */
-(void)emotionClick{
    [_textTF becomeFirstResponder];
    
    if (_index == 1) {
        _index = 0;
        _textTF.inputView = nil;
    }else{
        _index = 1;

        
        EmotionView * emotionView = [[EmotionView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 220)];
        emotionView.clickBlock = ^(NSString *imgName) {
            [self inputImage:imgName];
        };
        emotionView.deleteBlock = ^{
            [self deleteClick];
        };
        self->_textTF.inputView = emotionView;
    }

    [_textTF reloadInputViews];
 
}
/**
 加号
 */
-(void)addClick{
    [_textTF becomeFirstResponder];
    
    if (_index == 2) {
        _index = 0;
        _textTF.inputView = nil;
    }else{
        _index = 2;
        ChatAddView * chatAddView = [[ChatAddView alloc]init];
        chatAddView.clickBlock = ^(ChatAddType type, id data) {
            if (self->_inputAddDataBlock) {
                self->_inputAddDataBlock(type,data);
            }
        };

        _textTF.inputView = chatAddView;
        
    }
    

    [_textTF reloadInputViews];
}
#pragma mark -- texttf delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if (textView.text.length <= 0) {
            //        [SVProgressHUD showWithStatus:@"请输入内容"];
            return NO;
        }
        
    
        if (_inputBlock) {
            _inputBlock(textView.text);
        }
//        [[IQKeyboardManager sharedManager] resignFirstResponder];
        textView.text = @"";
        [self layout];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if ([text isEqualToString:@""]) { // 删除键
        
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.inputView = nil;
    [textView reloadInputViews];

    
    return YES;
}
-(void)textViewClick{
    
    
    
}

-(void)textViewDidChange:(UITextView *)textView{
    [self layout];

}



-(void)inputImage:(NSString *)imageName{
    _textTF.text = [_textTF.text stringByAppendingString:imageName];
}
-(void)deleteClick{
    if (_textTF.text.length < 1) {
        return;
    }
    
    _textTF.text = [_textTF.text stringByReplacingCharactersInRange:NSMakeRange(_textTF.text.length -1, 1) withString:@""];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
