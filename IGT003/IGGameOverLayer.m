//
//  IGGameOverLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameOverLayer.h"
#import "AppDelegate.h"
#import "IGGameMenu.h"
#import "IGGameNumberLayer.h"


@implementation IGGameOverLayer


- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
	
	CGSize contentSize = self.contentSize;
	
    CCLabelBMFont *gameoverSp= [CCLabelBMFont labelWithString:@"GAME OVER" fntFile:@"konqa32.fnt"];
	gameoverSp.position = ccp(160, contentSize.height - 40);
	[self addChild:gameoverSp];
	
	
	CCSprite* gameOverFrame = [CCSprite spriteWithFile:@"GameOverFrame.png"];
	gameOverFrame.anchorPoint = ccp(0.5, 0.5);
	gameOverFrame.position = ccp(160, contentSize.height - 190);
	[self addChild:gameOverFrame];
	
	int ypos = contentSize.height - 120;
    CCLabelBMFont *helloSp= [CCLabelBMFont labelWithString:@"HELLO" fntFile:@"konqa32.fnt"];
    
	helloSp.position = ccp(160, ypos);
	[self addChild:helloSp];
	
	ypos -= 50;
	CCLabelTTF* nameLabel = [CCLabelTTF labelWithString:manager.playerName fontName:@"Marker Felt" fontSize:30];
	nameLabel.position = ccp(160, ypos);
	nameLabel.color = ccRED;
	[self addChild:nameLabel];
	
	ypos -= 50;
    CCLabelBMFont *youScoreSp= [CCLabelBMFont labelWithString:@"YOUR SCORE IS" fntFile:@"konqa32.fnt"];
	youScoreSp.position = ccp(160, ypos);
	[self addChild:youScoreSp];
	
	ypos -= 50;
	IGGameNumberLayer* numberLayer = [IGGameNumberLayer layerWithNumber:m_dataManager.score];
	numberLayer.anchorPoint = ccp(0.5, 0.5);
	numberLayer.position = ccp(160, ypos);
	[self addChild:numberLayer];
	
    // 开始
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"Retry" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi0 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(startRetry:)];
    
    // 返回菜单页面
    CCLabelBMFont *label1 = [CCLabelBMFont labelWithString:@"menu" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(returnMenu:)];
    
    IGGameMenu* menu = [IGGameMenu menuWithItems:mi0,mi1,nil];
    
	menu.position = ccp(self.contentSize.width * 0.5, 60);
    [menu alignItemsVerticallyWithPadding:20];
	[self addChild:menu];
	
	return self;
}


- (void) returnMenu:(id)sender
{
	[[AppDelegate instance] startMainMenu:true];
}

- (void) startRetry:(id)sender
{
	m_dataManager.score = 0;
	m_dataManager.hasDataSaved = false;
	[[AppDelegate instance] startStartNewGame:false];
}


@end
