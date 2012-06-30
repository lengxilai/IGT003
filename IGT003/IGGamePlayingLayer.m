//
//  IGGamePlayingLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-13.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGamePlayingLayer.h"
#import "IGScoreUtil.h"
#import "IGGameUtil.h"
#import "AppDelegate.h"
#import "IGGameMenu.h"
#import "SimpleAudioEngine.h"

#define kCurCellTag			1001
#define kCurStripTag		1002
#define kCurShotStripTag	1003
#define kCurCellYPos	    29


@implementation IGGamePlayingLayer

- (void) enterLayer
{
	[super enterLayer];
	[self unLockGameInput];
	[m_gameBoard startTimer];
    [m_gameTime startTimer];
}



- (void) levelLayer:(IGGameDataManager*)manager
{
	[super levelLayer:manager];
	[self lockGameInput];
	[m_gameBoard stopTimer];
	[self unschedule:@selector(step:)];
	
	manager.hasDataSaved = false;
	manager.score = m_gameScore.score;

	if (!m_isGameOver)
	{
		manager.hasDataSaved = true;
		GamePlayingData* data = [manager getPlayingData];

		data->m_time = m_gameTime.time;
		data->m_scores = m_gameScore.score;
		[m_gameBoard fillKindData:data];
	}
	else
	{
		[manager insertScore:manager.score player:manager.playerName];
	}
}


- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
	
    // 游戏数据初始化
	GamePlayingData* playingData = [manager getPlayingData];
	int score = manager.score;
	int time = manager.initTime;
	
    // 如果有保存数据，读取
	if (manager.hasDataSaved)
	{
		score = playingData->m_scores;
		time = playingData->m_time;
	}
	
    // 游戏结束标志
	m_isGameOver = false;
	
	m_gameBoard = [[IGGameBoard alloc] initWithDataManager:manager];
	m_gameBoard.gamePlayingLayer = self;
	
	m_gameTime = [[IGGameTime alloc] initWithTime:time];
    
    m_gameTime.m_board = m_gameBoard;
    
	m_gameScore = [[IGGameScore alloc] initWithScore:score];
	
	m_gameScore.anchorPoint = ccp(0.0, 0.0);
	m_gameScore.position = ccp(60, 400);
	[self addChild:m_gameScore];
	
	m_gameTime.anchorPoint = ccp(0.0, 0.0);
	m_gameTime.position = ccp(200, 400);
	[self addChild:m_gameTime];
	
	CCMenuItemImage* mi0 = [CCMenuItemImage itemFromNormalImage:@"PauseButton.png" 
											  selectedImage:@"PauseButton_p.png" 
													 target:self 
												   selector:@selector(startPauseButton:)];
	m_pauseButton = [IGGameMenu menuWithItems:mi0, nil];
	m_pauseButton.position = ccp(320 - 20, 20);
	[self addChild:m_pauseButton];
	m_pauseButton.isTouchEnabled = FALSE;
	
	
	m_gameBoard.anchorPoint = ccp(0, 0);
    m_gameBoard.position = ccp(8, 64);
	[self addChild:m_gameBoard];
	
	[IGGameUtil playerBKMusic:@"GameBkMusic.mp3" volume:[m_dataManager realMusicVolume]];
	
	return self;	
}


- (void) startPauseButton:(id) sender
{
	[[AppDelegate instance] startGamePause:false];
}

- (void) delloc
{
	[m_gameScore release];
	[m_gameTime release];
	[m_gameBoard release];
	[super dealloc];
}


- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    if ([IGGameBoard checkIsInBoard:location]) {
        m_curCellIdx = [IGGameBoard getCellIdx:location];
        // 显示点击对象
        NSLog(@"我该换背景了");
    }
	return YES;
}


- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	if ([IGGameBoard checkIsInBoard:location]) {
        FruitCellPosition tempCellIdx = [IGGameBoard getCellIdx:location];;
        if (m_curCellIdx.m_xIdx != tempCellIdx.m_xIdx || m_curCellIdx.m_yIdx != tempCellIdx.m_yIdx)
        {
            m_curCellIdx = tempCellIdx;
            // 显示点击对象
            NSLog(@"换点击对象了");
        }
    }
    return YES;
}


- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];

    if ([IGGameBoard checkIsInBoard:location]) {
        // 消除十字上的水果
        if (![m_gameBoard removeCellWillClick:m_curCellIdx]);
        {
            return YES;
        }
    }		 
	return YES;
}

- (BOOL)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	return NO;//[self CCTouchesEnded:touches withEvent:event];
}


- (void) lockGameInput
{
	self.isTouchEnabled = FALSE;
	m_pauseButton.isTouchEnabled = FALSE;
}


- (void) unLockGameInput
{
	self.isTouchEnabled = TRUE;
	m_pauseButton.isTouchEnabled = TRUE;
}

//  游戏结束
- (void) beginGameOverAnimate
{
	m_isGameOver = true;
	[self lockGameInput];
}

// 跳转到游戏结束页面
- (void) endGameOverAnimate
{
	[[AppDelegate instance] startGameOver:false];
}

// 更新分数
- (void) accumulateScores:(int) addedScore
{
	int score = m_gameScore.score;
	score += addedScore;
	m_gameScore.score = score;
}

// 更新分数
- (int) returnScore
{
	return m_gameScore.score;
}

@end
