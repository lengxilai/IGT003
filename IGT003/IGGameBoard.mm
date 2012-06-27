//
//  IGGameBoard.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-13.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameBoard.h"
#import "IGScoreUtil.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"
#import "IGGamePlayingLayer.h"
#import "IGGameFloatingScores.h"
#import <vector>


#define kRemovingAnimateTime		0.15
#define kFallingAnimateTime			0.2
#define kRemovingCounterTime		0.8



typedef struct BallFallingDownInfo_tag
	{
		CGFloat	m_leftDist;
		CGFloat m_delta;
	} BallFallingDownInfo;

inline static BallFallingDownInfo* New_BallFallingDownInfo(CGFloat leftDist, CGFloat delta)
{
	BallFallingDownInfo* info = (BallFallingDownInfo*)malloc(sizeof(BallFallingDownInfo));
	info->m_leftDist = leftDist;
	info->m_delta = delta;
	return info;
}


typedef std::vector<FruitCellPosition>	CellPositionArray;
static CellPositionArray	s_needRemoveArray;
static CellPositionArray	s_needaddNewArray;
static int					s_needFallingDownArray[kXDirCellNum];


// x轴位置获取
static inline CGFloat GetXPos(int xIdx)
{
	return (xIdx + 0.5)* 38;
}
// y轴位置获取
static inline CGFloat GetYPos(int yIdx)
{
	return  (yIdx + 0.5) * 38;
}
// 水果位置确定
static inline CGPoint GetPostion(int xIdx, int yIdx)
{
	return ccp(GetXPos(xIdx), GetYPos(yIdx));
}

// 添加ayylist信息
static inline bool AddToArray(FruitCellPosition pos, CellPositionArray& array)
{
	for (int i = 0; i < (int)array.size(); i++)
	{
		if (pos.m_xIdx == array[i].m_xIdx && pos.m_yIdx == array[i].m_yIdx)
		{
			return false;
		}
	}
	
	array.push_back(pos);
	return true;	
}


@implementation IGGameBoard

@synthesize gamePlayingLayer = m_gamePlayingLayer;
@synthesize s_needGameOver;


- (void) stopTimer
{
	[self unschedule:@selector(timeStep:)];
}

- (void) startTimer
{
	[self schedule:@selector(timeStep:)];
}

static int		g_gameOverXIdx = 0;
static int		g_gameOverYIdx = kYDirCellNum - 1;
static CGFloat	g_totalTime	= 0;


- (void) dealWithGameOver
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"GameOver.wav"];
	g_gameOverXIdx = 0;
	g_gameOverYIdx = kYDirCellNum - 1;
	g_totalTime = 0;
	m_gameBoardState = State_GameOverAnimate;
	[self clearResoucre];
}

- (void) clearResoucre
{
	for (CCSprite* sp in m_fallingDwonBalls)
	{
		free(sp.userData);
		sp.userData = nil;
	}
	[m_fallingDwonBalls removeAllObjects];
}

- (void) dealloc
{
	[self clearResoucre];
	[m_fallingDwonBalls release];
	[m_ballsManager release];
	[super dealloc];
}

- (bool) gameOverAnimate:(ccTime) t
{
	if (g_gameOverYIdx < 0)
	{
		return false;
	}
	
	g_totalTime += t;
	if (g_totalTime > 0.07)
	{
		for (g_gameOverXIdx = 0; g_gameOverXIdx < kXDirCellNum; g_gameOverXIdx++)
		{
			[self addGreyCellxIdx:g_gameOverXIdx yIdx:g_gameOverYIdx];
		}
		g_gameOverXIdx = 0;
		g_gameOverYIdx--;
		g_totalTime = g_totalTime - 0.07;
	}
	return true;
}

- (CGPoint) calRemovingPostion
{
	assert(!s_needRemoveArray.empty());
	CGFloat xPos = 0;
	CGFloat yPos = 0;
	
	for (int i = 0; i < (int)s_needRemoveArray.size(); i++)
	{
		FruitCellPosition cellPos = s_needRemoveArray[i];
		CCSprite* sp = m_FruitCells[cellPos.m_xIdx][cellPos.m_yIdx].m_sprite;
		CGPoint pos = sp.position;
		
		xPos += pos.x;
		yPos += pos.y;
	}
	
	xPos /= s_needRemoveArray.size();
	yPos /= s_needRemoveArray.size();
	
	return CGPointMake(xPos, yPos);
}


- (void) afterScoresAnimate:(CCNode*)node
{
	[self removeChild:node cleanup:YES];
}


// 保存游戏数据
- (void) fillKindData:(GamePlayingData*) data
{
	for (int i = 0; i < kXDirCellNum; i++)
	{
		for (int j = 0; j < kYDirCellNum; j++)
		{
			data->m_fruitIdx[i][j] = m_FruitCells[i][j].m_kindIdx;
		}
	}
}

// 水果消除界面初始化
- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super init];
	// 背景添加
	CCSprite* bg = [CCSprite spriteWithFile:@"Board_bg.png"];
	self.contentSize = bg.contentSize;
    bg.anchorPoint = ccp(0.0, 0.0);
	[self addChild:bg];
	
    // 水果区域生成
    m_ballsManager = [[CCSpriteBatchNode alloc] initWithFile:@"Fruits.png" capacity:10];
	[self addChild:m_ballsManager];
	
	// 初始化
	for (int i = 0; i < kXDirCellNum; i++)
	{
		for (int j = 0; j < kYDirCellNum; j++)
		{
			FruitCell_Reset(&m_FruitCells[i][j]);
		}
	}
	
    // 如果有保存的游戏数据直接读取
	if (manager.hasDataSaved)
	{
		GamePlayingData* data = [manager getPlayingData];
		for (int i = 0; i < kXDirCellNum; i++)
		{
			for (int j = 0; j < kYDirCellNum; j++)
			{
				int kind = data->m_fruitIdx[i][j];
                [self addNewCellxIdx:i yIdx:j kindIdx:kind];
			}
		}
	}
	else
	{
        // 初始化
		for (int i = 0; i < kXDirCellNum; i++)
		{
            for (int j = 0; j < kYDirCellNum; j++)
            {
                [self addNewCellxIdx:i yIdx:j kindIdx:rand() % 2];
            }
		}		
	}
	
	
	for (int i = 0; i < kXDirCellNum; i++)
	{
		s_needFallingDownArray[i] = -1;
	}
	s_needGameOver = false;
    
	m_fallingDwonBalls = [[NSMutableArray alloc] init];
    
	m_gameBoardState = State_Nothing;
    
	m_removeTimeCounter = 0.0;
	m_chainTime = 1;
	m_gamePlayingLayer = nil;
	
	return self;
}

// 追加新的水果
- (void) addNewCellxIdx:(int) xIdx yIdx:(int)yIdx kindIdx:(int)kindIdx
{
	assert(xIdx >= 0 && xIdx < kXDirCellNum);
	assert(yIdx >= 0 && yIdx < kYDirCellNum);
	//assert(kindIdx >= 0 && kindIdx < kKindMaxNumber);
	
	CGRect rect = CGRectMake(kFruitCell_W * kindIdx, 0, kFruitCell_W, kFruitCell_W);
    CCSprite *sprite = [CCSprite spriteWithBatchNode:m_ballsManager rect:rect];
	[m_ballsManager addChild:sprite];
	sprite.position = GetPostion(xIdx, yIdx);
	
	FruitCell* cell = &m_FruitCells[xIdx][yIdx];
	cell->m_sprite = sprite;
	cell->m_kindIdx = kindIdx;
}

// 移除当前点击的十字上的水果
- (bool) removeCellWillClick:(FruitCellPosition) cellIdx
{
    // 如果在处理中，驳回响应
    if(m_gameBoardState != State_Nothing){
        return false;
    }
    if(IsBlankFruitsCell(&m_FruitCells[cellIdx.m_xIdx][cellIdx.m_yIdx])){
        return false;
    }
    // 播放消除音效
	[[SimpleAudioEngine sharedEngine] playEffect:@"Shot.wav"];
    
    [self addNeedToRemoveXIdx:cellIdx.m_xIdx yIdx:cellIdx.m_yIdx];	
    
	return true;
}

// 等级确定水果种类数
-(int) CalFruitKindsWithLevel:(int) level
{
	int interval[8] = { 2,3,4,5,5,5,5,5};
	return interval[level];
}

// 通过分数计算等级
+(int) calLevelWithScores:(int) score
{
	int level = (score / 10000);
	if (level > 7)
	{
		level = 7;
	}
	return level;
}

// 判断是否点击在游戏区域内
+(BOOL) checkIsInBoard:(CGPoint) location
{
    // 点击位置再边缘外时，不响应事件
    if(location.x<8 || location.x>312){
        return NO;
    }
    if(location.y<64 || location.y>368){
        return NO;
    }
	return YES;
}

// 确定点击所在位置
+(FruitCellPosition) getCellIdx:(CGPoint) pt
{
    FruitCellPosition idx;
    // 点击的列x确定
	int xPos = pt.x - 3;
	idx.m_xIdx = xPos / 38;
    
    // 点击的列y确定
    int yPos = pt.y-64;
	idx.m_yIdx = yPos / 38;
    
	return idx;
}

// 此函数检查(xIdx, yIdx)中的格子, 进行十字线上消除
- (void) addNeedToRemoveXIdx:(int) xIdx yIdx:(int)yIdx
{
	assert(xIdx >= 0 && xIdx < kXDirCellNum);
	assert(yIdx >= 0 && yIdx < kYDirCellNum);
	
    // 取得当前水果的类型
    FruitCell* cell = &m_FruitCells[xIdx][yIdx];
    
    int fruitType = cell->m_kindIdx;
    
    
    
    // 移除x轴上所有相同水果
    for (int i = 0; i < kXDirCellNum; i++)
    {
        cell = &m_FruitCells[i][yIdx];
        if(cell->m_kindIdx == fruitType&& i!=xIdx){
            AddToArray(Pos_Make(i, yIdx), s_needRemoveArray);
  
            AddToArray(Pos_Make(i, kYDirCellNum-1), s_needaddNewArray);
            
        }
    }
    
    int addNewX = kYDirCellNum;
    // 移除y轴上所有相同水果
    for (int i = 0; i < kYDirCellNum; i++)
    {
        cell = &m_FruitCells[xIdx][i];
        if(cell->m_kindIdx == fruitType){
            AddToArray(Pos_Make(xIdx, i), s_needRemoveArray);
            
            addNewX = addNewX -1;
            AddToArray(Pos_Make(xIdx, addNewX), s_needaddNewArray);

        }
    }
    m_gameBoardState = State_Removing;
}

// 时间控制器
- (void) timeStep:(ccTime) t
{	
	m_removeTimeCounter += t;
	switch (m_gameBoardState)
	{
		case State_Nothing:
            if (s_needGameOver)
			{
				[m_gamePlayingLayer beginGameOverAnimate];
				g_gameOverXIdx = 0;
				g_gameOverYIdx = kYDirCellNum - 1;
				g_totalTime = 0;
				m_gameBoardState = State_GameOverAnimate;
				[self clearResoucre];
			}
			break;
		case State_Removing:
			if (![self removingAnimate:t])
			{
				if (!s_needRemoveArray.empty())
				{
					[[SimpleAudioEngine sharedEngine] playEffect:@"Clear.wav"];
					
					if (m_removeTimeCounter < kRemovingCounterTime)
					{
						m_chainTime++;
						m_removeTimeCounter = 0.0;
					}
					else
					{
						m_chainTime = 1;
						m_removeTimeCounter = 0.0;
					}
					[self removePositionArray];
				}
				
				m_gameBoardState = State_Nothing;
				if ([m_fallingDwonBalls count] != 0)
				{
					m_gameBoardState = State_FallingDown;
				}
			}
			break;
			
		case State_FallingDown:
			if (![self fallDownAnimate:t])
			{
				[[SimpleAudioEngine sharedEngine] playEffect:@"FallDown.wav"];
				[self clearFallingDownInfo];
				m_gameBoardState = State_addingNewFruit;
			}
			break;
        case State_addingNewFruit:
			if (![self geningNewFruitAnimate:t])
			{
                [[SimpleAudioEngine sharedEngine] playEffect:@"FallDown.wav"];
				m_gameBoardState = State_Nothing;
			}
			break;
		case State_GameOverAnimate:
			if (![self gameOverAnimate:t])
			{
				[m_gamePlayingLayer endGameOverAnimate];
			}
			break;
			
		case State_GameOver:
			break;
	}
}

// 显示得分
- (void) playScoresAnimateBaseScore:(int) score chainTime:(int)time
{
	CGPoint pos = [self calRemovingPostion];
	
	int colorIdx = 0;
	if (!s_needRemoveArray.empty())
	{
		FruitCellPosition cellPos = s_needRemoveArray[0];
		colorIdx = m_FruitCells[cellPos.m_xIdx][cellPos.m_yIdx].m_kindIdx;
		if (colorIdx < 0 || colorIdx >= kKindMaxNumber)
		{
			colorIdx = 0;
		}
	}
    
	IGGameFloatingScores* label = [IGGameFloatingScores layerWithBaseScore:score hitTime:time colorIdx:colorIdx];
	label.position = pos;
	[self addChild:label];
    
	[label setOpacity:0];
	
	[label runAction:[CCSequence actions:
					  [CCSpawn actions:[CCMoveBy actionWithDuration:0.1 position:ccp(0, 2.5)], [CCFadeIn actionWithDuration:0.1], nil],
					  [CCMoveBy actionWithDuration:0.6 position:ccp(0, 15)],
					  [CCSpawn actions:[CCMoveBy actionWithDuration:0.3 position:ccp(0, 7.5)], [CCFadeOut actionWithDuration:0.3], nil],
					  [CCCallFuncN actionWithTarget:self selector:@selector(afterScoresAnimate:)], nil]];
}

// 移除对应
- (void) removePositionArray
{	
	int addedScores = [IGScoreUtil ComputeScores:s_needRemoveArray.size()];
	[m_gamePlayingLayer accumulateScores:addedScores * m_chainTime];
	[self playScoresAnimateBaseScore:addedScores chainTime:m_chainTime];
	
	bool needToCheckFallingDown[kXDirCellNum];
	for (int i = 0; i < kXDirCellNum; i++)
	{
		needToCheckFallingDown[i] = false;
	}
	
	for (int i = 0; i < (int)s_needRemoveArray.size(); i++)
	{
		int xIdx = s_needRemoveArray[i].m_xIdx;
		int yIdx = s_needRemoveArray[i].m_yIdx;
		[self removeCellxIdx:xIdx yIdx:yIdx];
		needToCheckFallingDown[xIdx] = true;
	}
    
	s_needRemoveArray.clear();
	
	for (int i = 0; i < kXDirCellNum; i++)
	{
		if (needToCheckFallingDown[i])
		{
			[self downToTopXIdx:i];
		}
	}
}

// 移除动画
- (bool) removingAnimate:(ccTime) t
{
	if (s_needRemoveArray.empty())
	{
		return false;
	}
	
	bool result = true;
	CGFloat deltaScale = (0.05 - 1.0) / kRemovingAnimateTime;
	for (int i = 0; i < (int)s_needRemoveArray.size(); i++)
	{
		FruitCellPosition pos = s_needRemoveArray[i];
		CCSprite* sp = m_FruitCells[pos.m_xIdx][pos.m_yIdx].m_sprite;
		CGFloat scale = sp.scale;
		scale += deltaScale * t;
		sp.scale = scale;
		if (sp.scale < 0.05)
		{
			result = false;
		}
		
	}
	return result;
}

// 下落
- (bool) downToTopXIdx:(int)xIdx
{
	assert(xIdx >= 0 && xIdx < kXDirCellNum);
	
	int holeCounter = 0;
	bool result = false;
	
	s_needFallingDownArray[xIdx] = -1;
	for (int i = 0; i < kYDirCellNum; i++)
	{
		if (IsBlankFruitsCell(&m_FruitCells[xIdx][i]))
		{
			holeCounter++;
		}
		else if (holeCounter != 0)
		{
			assert(i - holeCounter >= 0);
			assert(IsBlankFruitsCell(&m_FruitCells[xIdx][i - holeCounter]));
			
			m_FruitCells[xIdx][i - holeCounter] = m_FruitCells[xIdx][i];
			CCSprite* sprite = m_FruitCells[xIdx][i - holeCounter].m_sprite;
			CGPoint lastPos = GetPostion(xIdx, i - holeCounter);
			CGPoint curPos = sprite.position;
			
			CGFloat leftDist = lastPos.y - curPos.y;
			CGFloat delta = leftDist / kFallingAnimateTime;
			
			assert(sprite.userData == nil);
			sprite.userData = (void*)New_BallFallingDownInfo(leftDist, delta);
			
			[m_fallingDwonBalls addObject:sprite];
			s_needFallingDownArray[xIdx] = i - holeCounter;
			FruitCell_Reset(&m_FruitCells[xIdx][i]);
		}
	}
	
	return result;
}

// 下落动画
- (bool) fallDownAnimate:(ccTime) t
{
	if ([m_fallingDwonBalls count] == 0)
	{
		return false;
	}
	
	bool result = true;
	for (CCSprite* sprite in m_fallingDwonBalls)
	{
		CGPoint pt = sprite.position;
		BallFallingDownInfo* info = (BallFallingDownInfo*)sprite.userData;
		
		CGFloat ypos = info->m_delta * t;
		info->m_leftDist -= ypos;
		
		sprite.position = ccp(pt.x, pt.y + ypos);
		
		if (info->m_leftDist < 0)
		{
			result = false;
		}
	}
	
	return result;
}

// 移除下落信息
- (void) clearFallingDownInfo
{
	for (CCSprite* sprite in m_fallingDwonBalls)
	{
		BallFallingDownInfo* info = (BallFallingDownInfo*)sprite.userData;
		CGPoint pt = sprite.position;
		sprite.position = ccp(pt.x, pt.y + info->m_leftDist);
		free(sprite.userData);
		sprite.userData = nil;
	}
	
	[m_fallingDwonBalls removeAllObjects];
	for (int i = 0; i < kXDirCellNum; i++)
	{
		s_needFallingDownArray[i] = -1;
	}
}

// 找到从上到下最后一个水果格子
- (int) findLastYIdxBlank:(int) xIdx
{
	assert(xIdx >= 0 && xIdx < kXDirCellNum);
	for (int idx = kYDirCellNum; idx > 0; idx--)
	{
		if (!IsBlankFruitsCell(&m_FruitCells[xIdx][idx-1]))
		{
			return idx;
		}
	}
	return 0;
}

// 在(xIdx, yIdx)坐标位置, 放置一个灰度球, 用于game over情况
- (void) addGreyCellxIdx:(int) xIdx yIdx:(int)yIdx
{
	assert(xIdx >= 0 && xIdx < kXDirCellNum);
	assert(yIdx >= 0 && yIdx < kYDirCellNum);
	
	if (!IsBlankFruitsCell(&m_FruitCells[xIdx][yIdx]))
	{
		[self removeCellxIdx:xIdx yIdx:yIdx];
	}
	
	assert(IsBlankFruitsCell(&m_FruitCells[xIdx][yIdx]));
	
	CGRect rect = CGRectMake(kFruitCell_W * 5, 0, kFruitCell_W, kFruitCell_W);
    CCSprite *sprite = [CCSprite spriteWithBatchNode:m_ballsManager rect:rect];
	[m_ballsManager addChild:sprite];
	sprite.position = GetPostion(xIdx, yIdx);
	
	FruitCell* cell = &m_FruitCells[xIdx][yIdx];
	cell->m_sprite = sprite;
	cell->m_kindIdx = 5;	
}

// 移除任意位置的小球
- (void) removeCellxIdx:(int) xIdx yIdx:(int)yIdx
{
	assert(xIdx >= 0 && xIdx < kXDirCellNum);
	assert(yIdx >= 0 && yIdx < kYDirCellNum);
	
	FruitCell* cell = &m_FruitCells[xIdx][yIdx];
	if (IsBlankFruitsCell(cell))
	{
		return;
	}
	
	[m_ballsManager removeChild:cell->m_sprite cleanup:YES];
	FruitCell_Reset(cell);
}


// 追加新水果
- (bool) geningNewFruitAnimate:(ccTime) t
{
	if (s_needaddNewArray.empty())
	{
		return false;
	}
	
    int level = [IGGameBoard calLevelWithScores:[m_gamePlayingLayer returnScore]];
    int rankind = [self CalFruitKindsWithLevel:level];
    for (int i = 0; i < (int)s_needaddNewArray.size(); i++){
        int xIdx = s_needaddNewArray[i].m_xIdx;
		int yIdx = s_needaddNewArray[i].m_yIdx;
        [self addNewCellxIdx:xIdx yIdx:yIdx kindIdx:rand() % rankind];
    }
    
    s_needaddNewArray.clear();
	return true;
}
@end
