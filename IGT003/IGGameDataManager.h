//
//  IGGameDataManager.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-13.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"
#import "IGCommonDefine.h"

// 游戏状态
typedef enum
	{
		Game_MainMenu,
		Game_New,
		Game_Playing,
		Game_Pause,
		Game_Help,
		Game_Options,
		Game_Scores,
} GameState;

// 
typedef struct GamePlayingData_tag
{   
    // 游戏时间
    int m_time;
    // 游戏等级
	//int	m_level;
    // 游戏分数
	int m_scores;
    // 页面状态
	int m_fruitIdx[kXDirCellNum][kYDirCellNum];
    // 水果显示顺序
    int m_fruitOdr[kFruitKinds];
} GamePlayingData;

// 纪录游戏中数据
bool GamePlayingData_Write(GamePlayingData* data, const char* fileName);
// 读取游戏中数据
bool GamePlayingData_Read(GamePlayingData* data,  const char* fileName);
// 游戏中数据初始化
void GamePlayingData_Init(GamePlayingData* data);


@interface IGGameDataManager : NSObject 
{
    // 主窗口
	UIWindow*		m_mainWindow;
	// 游戏状态
    GameState		m_gameState;
	// 玩家名字
    NSString*		m_playerName;
    // 玩家名字列表
	NSMutableArray*	m_playerNameListNormal;
	// 分数列表
    NSMutableArray*	m_scoreListNormal;
	// 游戏数据
    GamePlayingData	m_playingData;
	// 是否有保存的游戏数据
    bool			m_hasDataSaved;
    // 游戏音乐开启
	bool			m_isMusicOn;
	// 静音设置
    bool			m_isSoundOn;
	// 声音音量
    int				m_soundVolume;
	// 音乐音量
    int				m_musicVolume;
	// 当前分数
    int				m_score;
    // 当前游戏时间
    int             m_time;
    // 水果顺序列表
	NSMutableArray* m_fruitOrder;
}

@property (nonatomic, assign)	UIWindow*		mainWindow;
@property (nonatomic, assign)	int				initTime;
@property (nonatomic, assign)	int				soundVolume;
@property (nonatomic, assign)	int				musicVolume;
@property (nonatomic, assign)	bool			hasDataSaved;
@property (nonatomic, assign)	bool			isSoundOn;
@property (nonatomic, assign)	bool			isMusicOn;
@property (nonatomic, assign)	int				score;
@property (nonatomic, copy)		NSString*		playerName;
@property (nonatomic, readonly)	NSMutableArray*	playerNameListNormal;
@property (nonatomic, readonly)	NSMutableArray* scoreListNormal;
@property (nonatomic, readonly)	NSMutableArray* fruitOrder;

// 游戏数据初始化
- (id) init;
// 取得当前游戏数据
- (GamePlayingData*)	getPlayingData;
// 添加得分
- (void) insertScore:(int) score player:(NSString*)name;
// 保存游戏数据
- (void) save;
// 读取游戏数据
- (void) load;
- (CGFloat) realSoundVolume;
- (CGFloat) realMusicVolume;

@end
