//
//  IGGamePlayingLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-13.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameBoard.h"
#import "IGGameTime.h"
#import "IGGameScore.h"
#import "IGGameStateLayer.h"


@interface IGGamePlayingLayer: IGGameStateLayer
{
	IGGameScore*		m_gameScore;
	IGGameBoard*		m_gameBoard;
	IGGameTime*			m_gameTime;
	CCMenu*				m_pauseButton;
	FruitCellPosition	m_curCellIdx;
	bool				m_isGameOver;
}

- (id) initWithDataManager:(IGGameDataManager*)manager;

// 暂停
- (void) startPauseButton:(id) sender;
// 更新分数
- (void) accumulateScores:(int) addedScore;
// 返回分数
- (int) returnScore;

- (void) lockGameInput;
- (void) unLockGameInput;

- (void) beginGameOverAnimate;
- (void) endGameOverAnimate;

@end
