//
//  AppDelegate.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "IGGameStateLayer.h"
#import "IGGameDataManager.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    // 共用场景
	CCScene*		m_currentScene;
    // 数据
    IGGameDataManager*	m_dataManager;
    // 当前运行页面
	IGGameStateLayer*		m_currentLayer;
    
}

@property (nonatomic, retain) UIWindow *window;

// 取得游戏代理
+ (AppDelegate*) instance;
// 取得当前页面
- (IGGameStateLayer*) getCurrentLayer;

// 开始新游戏
- (void) startStartNewGame:(bool)flag;
// 暂停游戏
- (void) startGamePause:(bool)flag;
// 查看排行榜
- (void) startGameScores:(bool)flag;
// 设定页面
- (void) startGameOptions:(bool)flag;
// 帮助页面
- (void) startGameHelp:(bool)flag;
// 主菜单页面
- (void) startMainMenu:(bool)flag;
// 新游戏
- (void) startGameNew:(bool)flag;
// 游戏结束页面
- (void) startGameOver:(bool)flag;
@end
