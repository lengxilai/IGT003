//
//  GameMenuLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameMenuLayer.h"
#import	"AppDelegate.h"
#import "IGGameMenu.h"
#import "IGGameUtil.h"
#import "IGCommonDefine.h"


@implementation IGGameMenuLayer


// 动画效果出按钮
- (id) initWithDataManagerWithAnimate:(IGGameDataManager*)manager
{
	[self initWithDataManager:manager];
    
    CCArray* array = [self children];
    // elastic effect
    for( CCNode *child in array ) {
        
        if (![child isKindOfClass:[CCMenu class]]){
            continue;
        }
        
        CCArray* arrayMenuItems = [child children];
        CGSize s = [[CCDirector sharedDirector] winSize];
        int i=0;
        for( CCNode *menu in arrayMenuItems) {
            CGPoint dstPoint = menu.position;
            int offset = s.width/2 + 50;
            if( i % 2 == 0)
                offset = -offset;
            menu.position = ccp( dstPoint.x + offset, dstPoint.y);
            [menu runAction: 
             [CCEaseElasticOut actionWithAction:
              [CCMoveBy actionWithDuration:2 position:ccp(dstPoint.x - offset,0)]
                                         period: 0.35f]
             ];
            i++;
        }

    }
    return self;	
}

// 菜单页面初始化
- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
	
    // 取得页面大小
	CGSize contentSize = [self contentSize];
	
	// 水果爆爆logo
    CCLabelBMFont *logo= [CCLabelBMFont labelWithString:@"Fruit BB" fntFile:@"konqa32-hd.fnt"];
	logo.position = ccp(contentSize.width * 0.5, contentSize.height - 50);
	[self addChild:logo];
    
    /// 新游戏按钮 
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"New Game" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi0 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(startNew:)];
    
    // 重新开始
    CCLabelBMFont *label1 = [CCLabelBMFont labelWithString:@"Resume" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(startResume:)];
    
    mi1.tag = kResumeButtonTag;
    // 如果没有进行中的游戏，按钮不可点击
	if (!m_dataManager.hasDataSaved)
	{
		mi1.isEnabled = NO;
	}
    
    // 设置页面按钮
    CCLabelBMFont *label2= [CCLabelBMFont labelWithString:@"Setting" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(startOptions:)];
    
    // 排行榜
    CCLabelBMFont *label3 = [CCLabelBMFont labelWithString:@"Scores" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(startScores:)];
    
    // 帮助页面按钮
    CCLabelBMFont *label4 = [CCLabelBMFont labelWithString:@"About" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(startHelp:)];
    
    IGGameMenu* menu = [IGGameMenu menuWithItems:mi0,mi1,mi2,mi3,mi4,nil];
    
    [menu alignItemsVerticallyWithPadding:30];
    
	[self addChild:menu];
	
	// 菜单页面背景音乐
	[IGGameUtil playerBKMusic:@"MenuBkMusic.caf" volume:[m_dataManager realMusicVolume]];
	return self;
}

// 设置重新开始按钮可否点击
- (void) enterLayer
{
	[super enterLayer];
	CCMenuItemLabel* m = (CCMenuItemLabel*)[self getChildByTag:kResumeButtonTag];
	if (!m_dataManager.hasDataSaved)
	{
		m.isEnabled = NO;
	}
}

// 启动新游戏
- (void) startNew:(id) sender
{
	[[AppDelegate instance] startGameNew:false];
}
// 重新开始
- (void) startResume:(id) sender
{
	[[AppDelegate instance] startStartNewGame:false];
}
// 设置页面
- (void) startOptions:(id) sender
{
	[[AppDelegate instance] startGameOptions:false];
}
// 分数排行榜
- (void) startScores:(id) sender
{
	[[AppDelegate instance] startGameScores:false];
}
// 帮助页面
- (void) startHelp:(id) sender
{
	[[AppDelegate instance] startGameHelp:false];
}

@end
