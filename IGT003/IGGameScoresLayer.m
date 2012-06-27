//
//  IGGameScoresLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameScoresLayer.h"
#import "IGGameMenu.h"
#import "IGGameScoresCell.h"
#import "AppDelegate.h"
#import "IGGameUtil.h"


@implementation IGGameScoresLayer

- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
		
	// 返回菜单页面
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"go back" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi0 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(returnMenu:)];
    
    IGGameMenu* menu = [IGGameMenu menuWithItems:mi0,nil];
    
	menu.position = ccp(self.contentSize.width * 0.5, 40);
	[self addChild:menu];

    CCSprite* frame = [CCSprite spriteWithFile:@"GameScoresFrame.png"];
	frame.position = ccp(160, 275);
	[self addChild:frame];
    
	
	CGFloat ypos = (self.contentSize.height - 275) - 370 * 0.5;
	const int adjust = 70;
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, ypos + adjust, 300, 370 - adjust)];
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


- (void)hideAnimateEnd:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	m_tableView.userInteractionEnabled = TRUE;
	[IGGameUtil enableMenu:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return 35;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* identifier = @"GameScoresCellIdentifier";
	IGGameScoresCell* tableViewCell = (IGGameScoresCell*)[m_tableView dequeueReusableCellWithIdentifier:identifier];
	if (tableViewCell == nil)
	{ 
		tableViewCell = [[IGGameScoresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSArray* scoreList = m_dataManager.scoreListNormal;
	NSArray* playerNameList =m_dataManager.playerNameListNormal;
	
	tableViewCell.userInteractionEnabled = NO;
	tableViewCell.m_name.backgroundColor = [UIColor clearColor];
	tableViewCell.m_score.backgroundColor = [UIColor clearColor];
	
	NSInteger idx = [indexPath row];
	NSString* name = [playerNameList objectAtIndex:idx];
	NSString* nameText = [NSString stringWithFormat:@"%d. %@", idx+1, name];
	tableViewCell.m_name.text = nameText;
	
	NSNumber* scoreNum = [scoreList objectAtIndex:idx];
	NSString* score = [NSString stringWithFormat:@"%d", [scoreNum intValue]];
	tableViewCell.m_score.text = score;
	
	return tableViewCell;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	NSArray* array1 =  m_dataManager.scoreListNormal;
	NSArray* array2 =  m_dataManager.playerNameListNormal;
	
	int counter1 = [array1 count];
	int counter2 = [array2 count];
	
	return counter1 < counter2 ? counter1 : counter2;
}


- (void) dealloc
{
	[m_tableView release];
	[super dealloc];
}



@end
