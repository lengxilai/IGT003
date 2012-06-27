//
//  IGGameSettingLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameSettingLayer.h"
#import "IGGameMenu.h"
#import "AppDelegate.h"
#import "IGGameGradeLayer.h"
#import "SimpleAudioEngine.h"


@implementation IGGameSettingLayer


- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
	CGSize contentSize = self.contentSize;
	// 音效	
	m_soundLayer = [[IGGameGradeLayer alloc] initWithLabelName:@"SOUND:" 
													 toggle0:@"On"
													 toggle1:@"Off"
													delegate:self];
	m_soundLayer.anchorPoint = ccp(0.5, 0.5);
	m_soundLayer.position = ccp(0, contentSize.height - 150);
	[self addChild:m_soundLayer];
	[m_soundLayer disableMenu];
	m_soundLayer.grade = m_dataManager.soundVolume;
	m_soundLayer.selectedIndex = m_dataManager.isSoundOn ? 0 : 1;
	
    // 背景音乐
	m_musicLayer = [[IGGameGradeLayer alloc] initWithLabelName:@"MUSIC:" 
													 toggle0:@"On"
													 toggle1:@"Off"
													delegate:self];
	m_musicLayer.anchorPoint = ccp(0.5, 0.5);
	m_musicLayer.position = ccp(0, contentSize.height - 275);
	[self addChild:m_musicLayer];
	[m_musicLayer disableMenu];
	m_musicLayer.grade = m_dataManager.musicVolume;
	m_musicLayer.selectedIndex = m_dataManager.isMusicOn ? 0 : 1;
	
	return self;
}


- (void) enterLayer
{
	[super enterLayer];
	[m_soundLayer enableMenu];
	[m_musicLayer enableMenu];
}


- (void) levelLayer:(IGGameDataManager*)manager
{
	[super levelLayer:manager];
	[m_soundLayer disableMenu];
	[m_musicLayer disableMenu];
}

// 音量大小调节
- (void) changeLayer:(IGGameGradeLayer*)layer grade:(int)grade
{
	SimpleAudioEngine* engin = [SimpleAudioEngine sharedEngine];
	
	if (layer == m_soundLayer)
	{
		m_dataManager.soundVolume = grade;
		engin.effectsVolume = [m_dataManager realSoundVolume];		
	}
	else if (layer == m_musicLayer)
	{
		m_dataManager.musicVolume = grade;
		engin.backgroundMusicVolume = [m_dataManager realMusicVolume];
	}
}

// 音效和音乐开关
- (void) changeLayer:(IGGameGradeLayer*)layer selectIdx:(int)idx
{
	SimpleAudioEngine* engin = [SimpleAudioEngine sharedEngine];
	if (layer == m_soundLayer)
	{
		m_dataManager.isSoundOn = (idx == 0);
		engin.effectsVolume = [m_dataManager realSoundVolume];
	}
	else if (layer == m_musicLayer)
	{
		m_dataManager.isMusicOn = (idx == 0);
		engin.backgroundMusicVolume = [m_dataManager realMusicVolume];
	}
}


- (void) dealloc
{
	[m_soundLayer release];
	[m_musicLayer release];
	[super dealloc];
}

@end
