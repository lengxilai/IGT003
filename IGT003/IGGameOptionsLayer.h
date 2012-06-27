//
//  IGGameOptionsLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameSettingLayer.h"


@interface IGGameOptionsLayer : IGGameSettingLayer
{
    // 音效开启
	bool	m_isSoundOn;
	// 音乐开启
    bool	m_isMusicOn;
	// 音效音量
    int		m_soundVolume;
	// 音效音量
    int		m_musicVolume;
}

// 设定页面
- (id) initWithDataManager:(IGGameDataManager*)manager;
// 返回菜单页面
- (void) returnMenu:(id)sender;
// 重置初始值
- (void) startReset:(id)sender;

@end
