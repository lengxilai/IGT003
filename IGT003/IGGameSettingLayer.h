//
//  IGGameSettingLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameStateLayer.h"
#import "IGGameGradeLayer.h"


@interface IGGameSettingLayer : IGGameStateLayer<IGGameGradeDelegate>
{
    // 音效区
	IGGameGradeLayer*	m_soundLayer;
	// 背景音乐区
    IGGameGradeLayer*	m_musicLayer;
}
// 初始化
- (id) initWithDataManager:(IGGameDataManager*)manager;

@end
