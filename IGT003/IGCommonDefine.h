//
//  IGCommonDefine.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// 水果总种类
#define kFruitKinds  	6
// 水果横轴最大水果数
#define kXDirCellNum	8
// 水果纵轴最大水果数
#define kYDirCellNum	8
// 空水果格子的类型
#define kKindBlankIndex	-1
// 每个水果格子的宽度
#define kFruitCell_W		35
// 最大水果类型
#define kKindMaxNumber	6
// 文字宽度
#define kNumberSpriteWidth	18
// 文字高度
#define kNumberSpriteHeight	45
// 名字输入区域宽度
#define kTextLabelSpriteWidth	119
// 名字输入区域高度
#define kTextLabelSpriteHeight	34


// 重新开始按钮的tag值
#define kResumeButtonTag	1000

// 水果格信息
typedef struct
{
    // 水果种类
	int				m_kindIdx;
	// 水果精灵
    CCSprite*	    m_sprite;
} FruitCell;

// 水果位置信息
typedef struct
{
	int		m_xIdx;
	int		m_yIdx;
} FruitCellPosition;

// 游戏状态
typedef enum
{
    // 移除中
    State_Removing,
    // 下落中
    State_FallingDown,
    // 填充中
    State_addingNewFruit,
    // 播放结束动画中
    State_GameOverAnimate,
    // 无状态
    State_Nothing,
    // 游戏结束
    State_GameOver,
} Game_State;

@interface IGCommonDefine : NSObject

@end
