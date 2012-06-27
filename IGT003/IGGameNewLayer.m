//
//  IGGameNewLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameNewLayer.h"
#import "AppDelegate.h"
#import "IGGameGradeLayer.h"
#import "IGGameMenu.h"


#define kLevelLabelTag	1000


@implementation IGGameNewLayer


- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super initWithDataManager:manager];
	CGSize contentSize = self.contentSize;
	// 开始
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"start" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi0 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(startStart:)];
    
    // 返回菜单页面
    CCLabelBMFont *label1 = [CCLabelBMFont labelWithString:@"cancel" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(startCancel:)];
    
    IGGameMenu* menu = [IGGameMenu menuWithItems:mi0,mi1,nil];
    
	menu.position = ccp(self.contentSize.width * 0.5, 200);
    [menu alignItemsVerticallyWithPadding:20];
	[self addChild:menu];
	
    // 如果有保存中的游戏，提示信息
	if (manager.hasDataSaved)
	{
        CCLabelBMFont *noteSp= [CCLabelBMFont labelWithString:@"Click [START] will lose your saved game." fntFile:@"arial16.fnt"];
		[self addChild:noteSp];
		noteSp.position = ccp(contentSize.width * 0.5, 260);
	}
	// 玩家名字
    CCLabelBMFont *nameLabel = [CCLabelBMFont labelWithString:@"name" fntFile:@"bitmapFont.fnt"];
	nameLabel.anchorPoint = ccp(0, 0);
	nameLabel.position = ccp(0, contentSize.height - 65);
	[self addChild:nameLabel];
	
	CCSprite* inputNameFrame = [CCSprite spriteWithFile:@"InputNameFrame.png"];
	inputNameFrame.anchorPoint = ccp(0, 1);
	inputNameFrame.position = ccp(0, contentSize.height - 65);
	[self addChild:inputNameFrame];

	m_nameField = [[UITextField alloc] initWithFrame:CGRectMake(14, 75, 295, 60)];
	m_nameField.backgroundColor = [UIColor clearColor];
	m_nameField.font = [UIFont fontWithName:@"Marker Felt" size:30];
	m_nameField.returnKeyType = UIReturnKeyDone;
	m_nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	m_nameField.autocorrectionType = UITextAutocorrectionTypeNo;
	m_nameField.keyboardType = UIKeyboardTypeAlphabet;
	m_nameField.textColor = [UIColor whiteColor];
	m_nameField.delegate = self;
	
	m_nameField.text = manager.playerName;

	return self;
}


- (void) enterLayer
{
	[super enterLayer];
	self.isTouchEnabled = YES;
	[m_dataManager.mainWindow addSubview:m_nameField];
}


- (void) levelLayer:(IGGameDataManager*)manager
{
	[super levelLayer:manager];
	[m_nameField resignFirstResponder];
	[m_nameField removeFromSuperview];
	self.isTouchEnabled = NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	[m_nameField resignFirstResponder];
	NSString* name = [[m_nameField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([name length] == 0) 
	{
		m_nameField.text = m_dataManager.playerName;
	} 
	return YES;
}


- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[m_nameField resignFirstResponder];
	return YES;
}


- (void) startCancel:(id)sender
{
	[m_nameField resignFirstResponder];
	[m_nameField removeFromSuperview];
	[[AppDelegate instance] startMainMenu:true];
}


- (void) startStart:(id)sender
{
	[m_nameField resignFirstResponder];
	[m_nameField removeFromSuperview];
	m_dataManager.hasDataSaved = false;
	m_dataManager.playerName = m_nameField.text;
	m_dataManager.score = 0;
	[[AppDelegate instance] startStartNewGame:false];
}


- (void) dealloc
{
	[m_nameField release];
	[super dealloc];
}


@end
