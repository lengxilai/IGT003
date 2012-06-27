//
//  IGGameOptionsLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameOptionsLayer.h"
#import "IGGameMenu.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "IGGameDataManager.h"


@implementation IGGameOptionsLayer

// 初始页面
- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
	
    // 重置数据按钮
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"reset" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi0 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(startReset:)];
    
    // 返回菜单页面
    CCLabelBMFont *label1 = [CCLabelBMFont labelWithString:@"go back" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(returnMenu:)];
    
    IGGameMenu* menu = [IGGameMenu menuWithItems:mi0,mi1,nil];
    
	menu.position = ccp(self.contentSize.width * 0.5, 80);
    [menu alignItemsVerticallyWithPadding:20];
	[self addChild:menu];
    
	
    // 初始值设置
	m_isSoundOn = m_dataManager.isSoundOn;
	m_isMusicOn = m_dataManager.isMusicOn;
	m_soundVolume = m_dataManager.soundVolume;
	m_musicVolume = m_dataManager.musicVolume;
	
	return self;
}

// 回到菜单页面
- (void) returnMenu:(id)sender
{
	[[AppDelegate instance] startMainMenu:true];
}

// 返回初始值
- (void) startReset:(id)sender
{
	m_dataManager.isSoundOn = m_isSoundOn;
	m_dataManager.isMusicOn = m_isMusicOn;
	m_dataManager.soundVolume = m_soundVolume;
	m_dataManager.musicVolume = m_musicVolume;
	
	SimpleAudioEngine* engin = [SimpleAudioEngine sharedEngine];
	engin.backgroundMusicVolume = [m_dataManager realMusicVolume];
	engin.effectsVolume = [m_dataManager realSoundVolume];
	
	m_musicLayer.grade = m_musicVolume;
	m_soundLayer.grade = m_soundVolume;
	m_musicLayer.selectedIndex = m_isSoundOn ? 0 : 1;
	m_soundLayer.selectedIndex = m_isMusicOn ? 0 : 1;
}

@end
