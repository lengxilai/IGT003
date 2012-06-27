//
//  IGGameHelpLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameHelpLayer.h"
#import "IGGameMenu.h"
#import "AppDelegate.h"
#import "IGGameHelpInfoCell.h"


@implementation IGGameHelpLayer

// 页面初始化
- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
	
    // 取得页面大小
	CGSize contentSize = [self contentSize];
    
    // 标题
    CCLabelBMFont *title= [CCLabelBMFont labelWithString:@"ABOUT US" fntFile:@"konqa32.fnt"];
	title.position = ccp(contentSize.width * 0.5, contentSize.height - 50);
	[self addChild:title];
    
    // 背景
	CCSprite* bg = [CCSprite spriteWithFile:@"AboutBg.png"];
	bg.anchorPoint = ccp(0, 0);
	[self addChild:bg];
    
    // 返回菜单页面
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"go back" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi0 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(returnMenu:)];
    
    IGGameMenu* menu = [IGGameMenu menuWithItems:mi0,nil];
    
	menu.position = ccp(self.contentSize.width * 0.5, 40);
	[self addChild:menu];
	
    // 显示信息
	m_infoArray = [[NSArray alloc] initWithObjects:
				   NSLocalizedString(@"Powered by Cocos2d.", @"Powered by Cocos2d."), 
				   nil];
	
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 86, 300, 304)];
	m_tableView.backgroundColor = [UIColor clearColor];
	m_tableView.delegate = self;
	m_tableView.dataSource = self;
	m_tableView.separatorColor = [UIColor clearColor];
	
	return self;
}


- (void) levelLayer:(IGGameDataManager*)manager
{
	[super levelLayer:manager];
	[m_tableView removeFromSuperview];
}


- (void) enterLayer
{
	[super enterLayer];
	[m_dataManager.mainWindow addSubview:m_tableView];
}


- (void) returnMenu:(id)sender
{
	[[AppDelegate instance] startMainMenu:true];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return 35;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* identifier = @"GameInfoCellIdentifier";
	IGGameHelpInfoCell* tableViewCell = (IGGameHelpInfoCell*)[m_tableView dequeueReusableCellWithIdentifier:identifier];
	if (tableViewCell == nil)
	{ 
        tableViewCell = [[IGGameHelpInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	tableViewCell.userInteractionEnabled = NO;
	tableViewCell.m_info.backgroundColor = [UIColor clearColor];
	
	tableViewCell.m_info.text = [m_infoArray objectAtIndex:[indexPath row]];
	
	return tableViewCell;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [m_infoArray count];
}


- (void) dealloc
{
	[m_infoArray release];
	[m_tableView release];
	[super dealloc];
}

@end
