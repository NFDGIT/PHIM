//
//  PhotoBrowserView.h
//  YYIM
//
//  Created by Jobs on 2018/7/27.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserView : UIView
-(void)appearFromView:(UIView*)view imgs:(NSArray *)imgs;
-(void)disAppear;
@end
