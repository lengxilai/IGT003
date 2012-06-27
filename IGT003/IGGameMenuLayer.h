//
//  IGGameMenuLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameStateLayer.h"

@interface IGGameMenuLayer : IGGameStateLayer {

}

// 菜单初始化
- (id) initWithDataManager:(IGGameDataManager*)manager;
// 带动画效果的菜单初始化
- (id) initWithDataManagerWithAnimate:(IGGameDataManager*)manager;

// 启动新游戏
- (void) startNew:(id) sender;
// 重新开始
- (void) startResume:(id) sender;
// 设置页面
- (void) startOptions:(id) sender;
// 分数排行榜
- (void) startScores:(id) sender;
// 帮助页面
- (void) startHelp:(id) sender;

@end
