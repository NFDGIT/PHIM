//
//  PHPlayer.m
//  YYIM
//
//  Created by Jobs on 2018/7/24.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PHPlayer.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation PHPlayer
+(void)playAudioWith:(NSString *)url{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:@"url" ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
//    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
    //3.销毁声音
    AudioServicesDisposeSystemSoundID(soundID);
    
}
@end
