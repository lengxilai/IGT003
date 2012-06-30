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

// 消除时候的动画效果持续时间
#define kRemovingAnimateTime		1
// 下落和新追加水果时候的动画持续时间
#define kFallingAnimateTime			1


// 移动水果的的目标位置信息
typedef struct BallFallingDownInfo_tag
	{
        // x轴坐标
		CGFloat	m_movetox;
		// y轴坐标
        CGFloat m_movetoy;
	} BallFallingDownInfo;

// 新生成一个下落球的移动信息，
inline static BallFallingDownInfo* New_BallFallingDownInfo(CGFloat moveToX, CGFloat moveToY)
{
	BallFallingDownInfo* info = (BallFallingDownInfo*)malloc(sizeof(BallFallingDownInfo));
	info->m_movetox = moveToX;
	info->m_movetoy = moveToY;
	return info;
}


typedef std::vector<FruitCellPosition>	CellPositionArray;
// 需要移除的水果位置信息
static CellPositionArray	s_needRemoveArray;
// 需要添加新水果的位置信息
static CellPositionArray	s_needaddNewArray;
// 需要下落的水果列
static int					s_needFallingDownArray[kXDirCellNum];


// x轴位置获取
static inline CGFloat GetXPos(int xIdx)
{
	return (xIdx + 0.5)* kFruitCellW;
}
// y轴位置获取
static inline CGFloat GetYPos(int yIdx)
{
	return  (yIdx + 0.5) * kFruitCellH;
}
// 水果位置确定
static inline CGPoint GetPostion(int xIdx, int yIdx)
{
	return ccp(GetXPos(xIdx), GetYPos(yIdx));
}

// 添加arraylist信息
static inline bool AddToArray(FruitCellPosition pos, CellPositionArray& array)
{
    // 避免重复追加同一个水果
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

#pragma mark 初始化函数
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
	
	// 各种临时用变量的初始化
	for (int i = 0; i < kXDirCellNum; i++)
	{
		s_needFallingDownArray[i] = -1;
	}
	s_needGameOver = false;
	m_fallingDwonFruits = [[NSMutableArray alloc] init];
	m_gameBoardState = State_Nothing;
	m_gamePlayingLayer = nil;
	return self;
}
#pragma mark 在指定位置追加指定种类的水果
// 追加新的水果
- (void) addNewCellxIdx:(int) xIdx yIdx:(int)yIdx kindIdx:(int)kindIdx
{
	CGRect rect = CGRectMake(kFruitCell_W * kindIdx, 0, kFruitCell_W, kFruitCell_W);
    CCSprite *sprite = [CCSprite spriteWithBatchNode:m_ballsManager rect:rect];
	[m_ballsManager addChild:sprite];
	// 将水果放到最上边，在移动到指定位置
    sprite.position = GetPostion(xIdx, 8);
	// 指定位置移动
    [sprite runAction:[CCMoveTo actionWithDuration: kFallingAnimateTime position:GetPostion(xIdx,yIdx)]];
    // 更新水果信息
	FruitCell* cell = &m_FruitCells[xIdx][yIdx];
	cell->m_sprite = sprite;
	cell->m_kindIdx = kindIdx;
}

#pragma mark 资源释放
// 资源释放
- (void) dealloc
{
	[self clearResoucre];
	[m_fallingDwonFruits release];
	[m_ballsManager release];
	[super dealloc];
}
#pragma mark 时间器相关函数
// 停止时间器
- (void) stopTimer
{
	[self unschedule:@selector(timeStep:)];
}

// 启动时间器
- (void) startTimer
{
	[self schedule:@selector(timeStep:)];
}

// 时间控制器，用来控制游状态
- (void) timeStep:(ccTime) t
{	
	switch (m_gameBoardState)
	{
        // 无状态时候，检查游戏是否是需要结束
		case State_Nothing:
            if (s_needGameOver)
			{
				[self dealWithGameOver];
			}
			break;
        // 游戏处于消除状态
		case State_Removing:
            // 进行消除
			if (![self removingAnimate:t])
			{
                // 如果需要消除的水果不为空，基本上不可能发生
				if (!s_needRemoveArray.empty())
				{
                    // 播放消除音乐
					[[SimpleAudioEngine sharedEngine] playEffect:@"Clear.wav"];
					[self removePositionArray];
				}
				// 设置游戏状态，如果需要下落的水果不为空的话，进行下落状态，否则，进入填充状态
				m_gameBoardState = State_Nothing;
				if ([m_fallingDwonFruits count] != 0)
				{
					m_gameBoardState = State_FallingDown;
				}else {
                    m_gameBoardState = State_addingNewFruit;
                }
			}
			break;
		// 下落状态	
		case State_FallingDown:
            // 进行下落动画
			if (![self fallDownAnimate])
			{   // 播放下落音乐
				[[SimpleAudioEngine sharedEngine] playEffect:@"FallDown.wav"];
				// 清除下落中使用的信息
                [self clearFallingDownInfo];
				// 将游戏状态改为填充
                m_gameBoardState = State_addingNewFruit;
			}
			break;
        // 填充状态
        case State_addingNewFruit:
            // 填充水果
			if (![self geningNewFruitAnimate:t])
			{
                // 播放音乐
                [[SimpleAudioEngine sharedEngine] playEffect:@"FallDown.wav"];
				// 将游戏设置为无状态，消除到此结束
                m_gameBoardState = State_Nothing;
			}
			break;
        // 游戏结束状态
		case State_GameOverAnimate:
            // 播放结束动画
			if (![self gameOverAnimate:t])
			{
				[m_gamePlayingLayer endGameOverAnimate];
			}
			break;
		case State_GameOver:
			break;
	}
}
#pragma mark 点击后启动的第一个函数，消除开始

// 移除当前点击的十字上的水果
- (bool) removeCellWillClick:(FruitCellPosition) cellIdx
{
    // 如果在处理中，驳回响应
    if(m_gameBoardState != State_Nothing){
        return false;
    }
    // 判断是否是空水果格子
    if(IsBlankFruitsCell(&m_FruitCells[cellIdx.m_xIdx][cellIdx.m_yIdx])){
        return false;
    }
    // 播放点击音效
	[[SimpleAudioEngine sharedEngine] playEffect:@"Shot.wav"];
    
    [self addNeedToRemoveXIdx:cellIdx.m_xIdx yIdx:cellIdx.m_yIdx];	
    
	return true;
}

#pragma mark 点击后启动的第二个函数，消除对象确定
// 此函数检查点击的格子, 进行十字线上消除
- (void) addNeedToRemoveXIdx:(int) xIdx yIdx:(int)yIdx
{
	assert(xIdx >= 0 && xIdx < kXDirCellNum);
	assert(yIdx >= 0 && yIdx < kYDirCellNum);
	
    // 取得当前水果的类型
    FruitCell* cell = &m_FruitCells[xIdx][yIdx];
    
    m_activeFruit = m_FruitCells[xIdx][yIdx];
    
    int fruitType = cell->m_kindIdx;
    
    // 移除x轴上所有相同水果
    for (int i = 0; i < kXDirCellNum; i++)
    {
        cell = &m_FruitCells[i][yIdx];
        if(cell->m_kindIdx == fruitType&& i!=xIdx){
            // 添加到需要移除得列表
            AddToArray(Pos_Make(i, yIdx), s_needRemoveArray);
            // 取该列最上面得格子添加到需要追加新得列表种
            AddToArray(Pos_Make(i, kYDirCellNum-1), s_needaddNewArray);
            
        }
    }

    int addNewCout = kYDirCellNum;
    // 移除y轴上所有相同水果
    for (int i = 0; i < kYDirCellNum; i++)
    {
        cell = &m_FruitCells[xIdx][i];
        if(cell->m_kindIdx == fruitType){
            // 添加到需要移除得列表
            AddToArray(Pos_Make(xIdx, i), s_needRemoveArray);
            // 按照移除的个数，从上至下追加到需要添加新列表种
            addNewCout = addNewCout-1;
            AddToArray(Pos_Make(xIdx, addNewCout), s_needaddNewArray);
        }
    }
    // 把游戏设置为移除动画种
    m_gameBoardState = State_Removing;
}

#pragma mark 点击后启动的第三个函数，进行消除动画
// 消除动画，渐渐缩小动画
- (bool) removingAnimate:(ccTime) t
{
    // 如果没有需要消除的，直接返回，基本不可能发生
	if (s_needRemoveArray.empty())
	{
		return false;
	}
	
	bool result = true;
	CGFloat deltaScale = -1.0 / kRemovingAnimateTime;
	// 循环缩小水果的显示倍率，直到消失
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
#pragma mark 点击后启动的第四个函数，进行实际的消除数据，显示分数，并且取得所有需要下落的水果
// 显示分数，并且移除需要移除的，并且取得所有需要下落的水果
- (void) removePositionArray
{	
    // 计算得分
	int addedScores = [IGScoreUtil ComputeScores:s_needRemoveArray.size()];
	// 更新得分信息
    [m_gamePlayingLayer accumulateScores:addedScores];
	[self playScoresAnimateBaseScore:addedScores];
	// 初始化需要下落水果信息，false是不需要下落，true是需要下落
	bool needToCheckFallingDown[kXDirCellNum];
	for (int i = 0; i < kXDirCellNum; i++)
	{
		needToCheckFallingDown[i] = false;
	}
	// 循环需要消除的水果位置信息，消除的同时，将该小球的列号纪录为需要下落
	for (int i = 0; i < (int)s_needRemoveArray.size(); i++)
	{
		int xIdx = s_needRemoveArray[i].m_xIdx;
		int yIdx = s_needRemoveArray[i].m_yIdx;
		[self removeCellxIdx:xIdx yIdx:yIdx];
		needToCheckFallingDown[xIdx] = true;
	}
    // 清除消除列表
	s_needRemoveArray.clear();
	// 循环列，找到所有需要下落的水果信息
	for (int i = 0; i < kXDirCellNum; i++)
	{
		if (needToCheckFallingDown[i])
		{
			[self downToTopXIdx:i];
		}
	}
}

// 移除任意位置的小球，消除用共通
- (void) removeCellxIdx:(int) xIdx yIdx:(int)yIdx
{
	FruitCell* cell = &m_FruitCells[xIdx][yIdx];
	if (IsBlankFruitsCell(cell))
	{
		return;
	}
	
	[m_ballsManager removeChild:cell->m_sprite cleanup:YES];
	FruitCell_Reset(cell);
}

#pragma mark 点击后启动的第五个函数，找到所有需要下落水果的信息
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
			// 更新水果列表信息
			m_FruitCells[xIdx][i - holeCounter] = m_FruitCells[xIdx][i];
			CCSprite* sprite = m_FruitCells[xIdx][i - holeCounter].m_sprite;
			// 找到下落目标位置
            CGPoint lastPos = GetPostion(xIdx, i - holeCounter);
			CGFloat moveToX = lastPos.x;
			CGFloat moveToY = lastPos.y;
			assert(sprite.userData == nil);
            // 生成下落目标信息
			sprite.userData = (void*)New_BallFallingDownInfo(moveToX, moveToY);
            // 添加到需要下落的说过列表信息
			[m_fallingDwonFruits addObject:sprite];
			s_needFallingDownArray[xIdx] = i - holeCounter;
			FruitCell_Reset(&m_FruitCells[xIdx][i]);
		}
	}
	
	return result;
}

#pragma mark 点击后启动的第六个函数，进行下落动画
// 下落动画
- (bool) fallDownAnimate
{
    // 如果没有需要下落的数据，直接返回
	if ([m_fallingDwonFruits count] == 0)
	{
		return false;
	}
    // 循环将水果移动到目标位置
	for (CCSprite* sprite in m_fallingDwonFruits)
	{
		BallFallingDownInfo* info = (BallFallingDownInfo*)sprite.userData;
        [sprite runAction:[CCMoveTo actionWithDuration: kFallingAnimateTime position:ccp(info->m_movetox, info->m_movetoy)]];
	}
	return false;
}

#pragma mark 点击后启动的第七个函数，清除下落中使用的临时信息
// 移除下落信息
- (void) clearFallingDownInfo
{
	for (CCSprite* sprite in m_fallingDwonFruits)
	{
		free(sprite.userData);
		sprite.userData = nil;
	}
	
	[m_fallingDwonFruits removeAllObjects];
	for (int i = 0; i < kXDirCellNum; i++)
	{
		s_needFallingDownArray[i] = -1;
	}
}

#pragma mark 点击后启动的第八个个函数，填充被清除掉的水果
// 追加新水果
- (bool) geningNewFruitAnimate:(ccTime) t
{
    // 如果没有需要填充的，直接返回
	if (s_needaddNewArray.empty())
	{
		return false;
	}
	// 取得当前得分
    int level = [IGGameBoard calLevelWithScores:[m_gamePlayingLayer returnScore]];
    // 更具等级取得添加水果的种类
    int rankind = (int)[self CalFruitKindsWithLevel:level];
    for (int i = 0; i < (int)s_needaddNewArray.size(); i++){
        int xIdx = s_needaddNewArray[i].m_xIdx;
		int yIdx = s_needaddNewArray[i].m_yIdx;
        [self addNewCellxIdx:xIdx yIdx:yIdx kindIdx:rand() % rankind];
    }
    s_needaddNewArray.clear();
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


#pragma mark 显示得分用得函数

// 显示得分用动画
- (void) playScoresAnimateBaseScore:(int) score
{
    // 确定得分显示位置
	CGPoint pos = CGPointMake(0, 0);;
	
    // 确定得分显示颜色，如果取不到，默认显示第一种颜色，不过基本上不可能发生
	int colorIdx = 0;
	if (!s_needRemoveArray.empty())
	{
		FruitCellPosition cellPos = s_needRemoveArray[0];
		colorIdx = m_FruitCells[cellPos.m_xIdx][cellPos.m_yIdx].m_kindIdx;
		pos = m_activeFruit.m_sprite.position;
        if (colorIdx < 0 || colorIdx >= kKindMaxNumber)
		{
			colorIdx = 0;
		}
	}
    // 得分初始化
	IGGameFloatingScores* label = [IGGameFloatingScores layerWithBaseScore:score colorIdx:colorIdx];
	label.position = pos;
	[self addChild:label];
	[label setOpacity:0];
	
	[label runAction:[CCSequence actions:
					  [CCSpawn actions:[CCMoveBy actionWithDuration:0.1 position:ccp(0, 2.5)], [CCFadeIn actionWithDuration:0.1], nil],
					  [CCMoveBy actionWithDuration:0.6 position:ccp(0, 15)],
					  [CCSpawn actions:[CCMoveBy actionWithDuration:0.3 position:ccp(0, 7.5)], [CCFadeOut actionWithDuration:0.3], nil],
					  [CCCallFuncN actionWithTarget:self selector:@selector(afterScoresAnimate:)], nil]];
}
// 显示得分后移除对象
- (void) afterScoresAnimate:(CCNode*)node
{
	[self removeChild:node cleanup:YES];
}

#pragma mark 游戏结束用函数

// 游戏结束是动画用定数
static int		g_gameOverXIdx = 0;
static int		g_gameOverYIdx = kYDirCellNum - 1;
static CGFloat	g_totalTime	= 0;

// 设置游戏结束状态
- (void) dealWithGameOver
{
    [m_gamePlayingLayer beginGameOverAnimate];
    // 播放游戏结束音乐
	[[SimpleAudioEngine sharedEngine] playEffect:@"GameOver.wav"];
	// 结束用参数初始化
    g_gameOverXIdx = 0;
	g_gameOverYIdx = kYDirCellNum - 1;
	g_totalTime = 0;
	// 设置游戏为结束动画状态
    m_gameBoardState = State_GameOverAnimate;
	// 清除资源
    [self clearResoucre];
}

// 游戏结束的时候调用
- (bool) gameOverAnimate:(ccTime) t
{
    if (g_gameOverYIdx < 0)
	{
		return false;
	}
	g_totalTime += t;
    // 结束动画速度，0,07
	if (g_totalTime > 0.07)
	{
        // 从上到下放置结束用水果
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

// 在(xIdx, yIdx)坐标位置, 放置一个结束图片, 用于game over情况
- (void) addGreyCellxIdx:(int) xIdx yIdx:(int)yIdx
{	
    NSLog(@"%d,%d",xIdx,yIdx);
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

// 释放资源
- (void) clearResoucre
{
	for (CCSprite* sp in m_fallingDwonFruits)
	{
		free(sp.userData);
		sp.userData = nil;
	}
	[m_fallingDwonFruits removeAllObjects];
}

#pragma mark 游戏用其他共通函数
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
	idx.m_xIdx = xPos / kFruitCellW;
    
    // 点击的列y确定
    int yPos = pt.y-64;
	idx.m_yIdx = yPos / kFruitCellH;
    
	return idx;
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
@end
