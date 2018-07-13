//
//  ChatInputView.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatInputView.h"

#import "EmotionView.h"
#import "ChatBottomView.h"
#import "SmiliesAttributedString.h"


@interface ChatInputView()<UITextViewDelegate>
@property (nonatomic,strong)ChatBottomView * bottomView;


@property (nonatomic,strong)UIButton * addBtn;
@property (nonatomic,strong)UIButton * emotionBtn;
@property (nonatomic,strong)UITextView * textTF;

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
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 60)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    _topView = topView;
    
    
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    addBtn.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:addBtn];
    _addBtn = addBtn;
//    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton * emotionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    emotionBtn.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:emotionBtn];
    _emotionBtn = emotionBtn;
//    [emotionBtn addTarget:self action:@selector(emotionClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _textTF = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.width - 20, self.height - 20)];
    _textTF.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9  alpha:0.8];
    _textTF.font = FontBig;
    _textTF.delegate = self;
    _textTF.returnKeyType = UIReturnKeySend;
    [topView addSubview:_textTF];
    
    
    ChatBottomView * bottomView= [[ChatBottomView alloc]initWithFrame:CGRectMake(0, topView.bottom, self.width, 315)];
    [self addSubview:bottomView];
    _bottomView =bottomView;
    bottomView.emotionView.clickBlock = ^(NSString *imageName) {
        [self inputImage:imageName];
    };
    
    self.height = bottomView.bottom;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _topView.top = 0;
    _bottomView.top = _topView.bottom;
    
    
    _addBtn.right = _topView.width - 15;
    _emotionBtn.right = _addBtn.left - 15;
    
    
    
    _textTF.frame = CGRectMake(10, 5, _topView.width - 20, _topView.height - 20);
    _textTF.width = _emotionBtn.left - _textTF.left - 15;
    
    _addBtn.centerY = _emotionBtn.centerY = _textTF.centerY = _topView.height/2;
    
}
#pragma mark -- 点击事件

/**
 表情
 */
-(void)emotionClick{
     [self keyboardView].hidden = ![self keyboardView].hidden;
    if (_index == 1) {
        _index = 0;
    }else{
        _index = 1;
    }
    [self judgeShwoKeyBoardWithIndex:_index];
    
}
/**
 加号
 */
-(void)addClick{
    if (_index == 2) {
        _index = 0;
    }else{
        _index = 2;
    }
    [self judgeShwoKeyBoardWithIndex:_index];
}
#pragma mark -- 判断要不要显示键盘
-(void)judgeShwoKeyBoardWithIndex:(NSUInteger)index{
    if (![[IQKeyboardManager sharedManager]isKeyboardShowing]) {
        [_textTF becomeFirstResponder];
        return;
    }
    
    
    if (index == 0) {
        [self keyboardView].hidden = NO;
    }else{
        [self judgeBottomOffsetWithIndex:index];
        [self keyboardView].hidden = YES;
    }
}
-(void)judgeBottomOffsetWithIndex:(NSUInteger)index{
    if (index != 0) {
        _bottomView.page = index - 1;
    }
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
        [[IQKeyboardManager sharedManager] resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)inputImage:(NSString *)imageName{
//    if (_inputEmotionBlock) {
//        _inputEmotionBlock(image);
//    }
    
    SmiliesTextAttachment *emojiTextAttachment = [SmiliesTextAttachment new];

    //设置表情图片
    emojiTextAttachment.image = [UIImage imageNamed:imageName];
    emojiTextAttachment.smiliesId = imageName;
    

    
   
    NSAttributedString * smiliesas = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
    
    SmiliesAttributedString * smilies = (SmiliesAttributedString *)smiliesas;
    smilies.smiliesId = imageName;
    


    
    //插入表情
    [_textTF.textStorage insertAttributedString:smilies
atIndex:_textTF.selectedRange.location];
    
    
//    _textTF.attributedText = [[NSMutableAttributedString alloc]initWithString:_textTF.text];
//    _textTF.textStorage appendAttributedString:<#(nonnull NSAttributedString *)#>
    
}

//#pragma mark -- keyboard should begin
//-(void)chatBeginEditNoti:(NSNotification *)noti{
////    CGFloat height =  [noti.userInfo[@"UIKeyboardBoundsUserInfoKey"] size].height;
////    CGFloat duration = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
////
////    [UIView animateWithDuration:duration animations:^{
////
////    }];
//
//}
//#pragma mark -- keyboard should end
//-(void)chatEndEditNoti:(NSNotification *)noti{
//
//}
//获取键盘UIKeyboard

- (UIView *)keyboardView
{
    UIWindow* tempWindow;
    
    //Because we cant get access to the UIKeyboard throught the SDK we will just use UIView.
    //UIKeyboard is a subclass of UIView anyways
    UIView* keyboard;
    
    NSLog(@"windows %ld", [[[UIApplication sharedApplication]windows]count]);
    
    //Check each window in our application
    for(int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c ++)
    {
        //Get a reference of the current window
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
        
        //Get a reference of the current view
        for(int i = 0; i < [tempWindow.subviews count]; i++)
        {
            keyboard = [tempWindow.subviews objectAtIndex:i];
            NSLog(@"view: %@, on index: %d, class: %@", [keyboard description], i, [[tempWindow.subviews objectAtIndex:i] class]);
            if([[keyboard description] hasPrefix:@"(lessThen)UIKeyboard"] == YES)
            {
                //If we get to this point, then our UIView "keyboard" is referencing our keyboard.
                return keyboard;
            }
        }
        
        for(UIView* potentialKeyboard in tempWindow.subviews)
            // if the real keyboard-view is found, remember it.
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                if([[potentialKeyboard description] hasPrefix:@"<UILayoutContainerView"] == YES)
                    keyboard = potentialKeyboard;
            }
            else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
                if([[potentialKeyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
                    keyboard = potentialKeyboard;
            }
            else {
                if([[potentialKeyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                    keyboard = potentialKeyboard;
            }
    }
    
    return keyboard;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
