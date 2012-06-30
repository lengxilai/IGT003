//
//  IGGameBoard.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-13.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "GameConfig.h"
#import "IGGameDataManager.h"
#import "IGCommonDefine.h"

// 水果位置做成
inline static FruitCellPosition Pos_Make(int xPos, int yPos)
{
	FruitCellPosition pos = { xPos, yPos };
	return pos;
}

// 水果格初始化
inline static void FruitCell_Reset(FruitCell* cell)
{
	cell->m_kindIdx = kKindBlankIndex;
	cell->m_sprite = nil;
}

// 判断是否是空的水果格子
inline static bool IsBlankFruitsCell(FruitCell* cell)
{
	if (cell->m_kindIdx == kKindBlankIndex)
	{
		assert(cell->m_sprite == nil);
		return true;
	}
	return false;
}

@class IGGamePlayingLayer;

@interface IGGameBoard : CCLayer 
{
    // 水果精灵集合
	CCSpriteBatchNode*	m_ballsManager;
    // 下落水果集合
	NSMutableArray*		m_fallingDwonFruits;
	// 玩家显示界面
    IGGamePlayingLayer*	m_gamePlayingLayer;    
    // 全部水果列表
    FruitCell			m_FruitCells[kXDirCellNum][kYDirCellNum];
    // 当前点击的水果
    FruitCell           m_activeFruit;
    // 需要消除的水果列表
    NSMutableArray*     m_needRemovedFruits;
    // 消除完毕后需要下落的水果列表
    NSMutableArray*     m_needFallDownFruits;
    // 消除完毕后需要填充的水果列表
    NSMutableArray*     m_needAddNewFruits;
    // 游戏状态
    Game_State		    m_gameBoardState;
    // GameOver
    bool	            s_needGameOver;
}

@property (nonatomic, assign)	IGGamePlayingLayer* gamePlayingLayer;
@property (nonatomic, assign)	bool s_needGameOver;

// 通过分数提升游戏等级
+(int) calLevelWithScores:(int) score;

// 判断是否点击在游戏区域
+(BOOL) checkIsInBoard:(CGPoint) location;

// 确定点击所在位置
+(FruitCellPosition) getCellIdx:(CGPoint) pt;

// 初始化
- (id) initWithDataManager:(IGGameDataManager*)manager;

// 追加新水果
- (void) addNewCellxIdx:(int) xIdx yIdx:(int)yIdx kindIdx:(int)kindIdx;

// 点击开始消除水果
- (bool) removeCellWillClick:(FruitCellPosition)cellIdx;

// 此函数检查(xIdx, yIdx)中的格子, 进行十字线上消除
- (void) addNeedToRemoveXIdx:(int) xIdx yIdx:(int)yIdx;

// 保存游戏数据
- (void) fillKindData:(GamePlayingData*) data;

// 移除任意位置的水果
- (void) removeCellxIdx:(int) xIdx yIdx:(int)yIdx;
- (void) stopTimer;
- (void) startTimer;

- (void) removePositionArray;
// 填充水果
- (bool) geningNewFruitAnimate:(ccTime) t;
// 释放资源
- (void) clearResoucre;
// 得分显示
- (void) playScoresAnimateBaseScore:(int) score;
// 消除动画
- (bool) removingAnimate:(ccTime) t;
// 下落动画
- (bool) fallDownAnimate;
// 清除下落信息
- (void) clearFallingDownInfo;
// 下落
- (bool) downToTopXIdx:(int)xIdx;
// 游戏结束逻辑
- (void) addGreyCellxIdx:(int) xIdx yIdx:(int)yIdx;
// 游戏结束状态设置
- (void) dealWithGameOver;
// 游戏结束的时候调用
- (bool) gameOverAnimate:(ccTime) t;
@end
