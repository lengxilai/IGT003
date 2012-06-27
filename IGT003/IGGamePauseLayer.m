//
//  GamePauseLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGamePauseLayer.h"
#import "IGGameMenu.h"
#import "AppDelegate.h"
#import "IGGameGradeLayer.h"
#import "SimpleAudioEngine.h"


@implementation IGGamePauseLayer



- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
	
    
    // 开始
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"Resume" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi0 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(startResume:)];
    
    // 返回菜单页面
    CCLabelBMFont *label1 = [CCLabelBMFont labelWithString:@"menu" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(startMenu:)];
    
    IGGameMenu* menu = [IGGameMenu menuWithItems:mi0,mi1,nil];
    
	menu.position = ccp(self.contentSize.width * 0.5, 80);
    [menu alignItemsVerticallyWithPadding:20];
	[self addChild:menu];
		
	return self;
}


- (void) startMenu:(id)sender
{
	[[AppDelegate instance] startMainMenu:true];
}


- (void) startResume:(id)sender
{
	[[AppDelegate instance] startStartNewGame:true];
}

@end
