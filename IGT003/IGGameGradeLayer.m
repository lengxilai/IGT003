//
//  IGGameGradeLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameGradeLayer.h"
#import "IGGameMenu.h"
#import "IGCommonDefine.h"
#import "IGGameUtil.h"


#define kGradeColorWidth		214
#define kGradeColorHeight		31
#define kGradeColorSpriteTag	1000
#define kNumberSpriteTag		1001


@interface IGGameGradeSubLayer : CCLayer 
{
	CCSpriteBatchNode*		m_spriteManager;
	int						m_grade;
}

@property (nonatomic, assign)	int	grade;

- (id) initWithMenuTargetr:(id)menuTarget;

@end




@implementation IGGameGradeSubLayer

@synthesize grade = m_grade;


- (id) initWithMenuTargetr:(id)menuTarget
{
	[super init];
	
	CCSprite* gradeFrame = [CCSprite spriteWithFile:@"GradeFrame.png"];
	[self addChild:gradeFrame];
	
	CCMenuItemImage* mi0 = [CCMenuItemImage itemFromNormalImage:@"AddButton.png" 
											  selectedImage:@"AddButton_p.png" 
													 target:menuTarget 
												   selector:@selector(startAddButton:)];
	IGGameMenu* menu0 = [IGGameMenu menuWithItems:mi0, nil];
	[self addChild:menu0];
	
	CCMenuItemImage* mi1 = [CCMenuItemImage itemFromNormalImage:@"MinusButton.png" 
											  selectedImage:@"MinusButton_p.png" 
													 target:menuTarget 
												   selector:@selector(startMinusButton:)];
	IGGameMenu* menu1 = [IGGameMenu menuWithItems:mi1, nil];
	[self addChild:menu1];
	
	CGFloat height = gradeFrame.contentSize.height;
	height = height > mi0.contentSize.height ? height : mi0.contentSize.height;
	height = height > mi1.contentSize.height ? height : mi1.contentSize.height;
	
	self.contentSize = CGSizeMake(320, height);
	
	gradeFrame.position = ccp(160, self.contentSize.height * 0.5);
	menu0.position = ccp(self.contentSize.width - mi0.contentSize.width * 0.5 - 2, self.contentSize.height * 0.5);
	menu1.position = ccp(mi1.contentSize.height * 0.5 + 2, self.contentSize.height * 0.5 - 6);
		
    m_spriteManager = [CCSpriteBatchNode batchNodeWithFile:@"GradeColor.png"];
	[self addChild:m_spriteManager];
	
	m_grade = 9;
	self.grade = m_grade;
	
	return self;
}


- (CGRect) colorRectWidthGrade:(int)grade
{
	const CGFloat eachWidth = kGradeColorWidth / 9.0;
	return CGRectMake(0, 0, grade * eachWidth, kGradeColorHeight);
}


- (void) setGrade:(int)grade
{
	assert(grade >= 0 && grade <= 9);
	[m_spriteManager removeChildByTag:kGradeColorSpriteTag cleanup:YES];	
	m_grade = grade;
	
	if (grade != 0)
	{
		CGRect rect = [self colorRectWidthGrade:m_grade];
        CCSprite* sp = [CCSprite spriteWithBatchNode:m_spriteManager rect:rect];
		
		sp.anchorPoint = ccp(0, 0);
		sp.position = ccp(160 - kGradeColorWidth * 0.5, self.contentSize.height * 0.5 - kGradeColorHeight * 0.5);
		
		[m_spriteManager addChild:sp z:0 tag:kGradeColorSpriteTag];
	}
}

@end



@implementation IGGameGradeLayer

//@synthesize grade;

- (int) grade
{
	return m_gradeLayer.grade;
}


- (void) setGrade:(int)grade
{
	m_gradeLayer.grade = grade;
	
	[m_numberManager removeChild:(CCSprite*)[m_numberManager getChildByTag:kNumberSpriteTag] cleanup:YES];
	
	CGRect rect = CGRectMake(kNumberSpriteWidth * grade, 0, kNumberSpriteWidth, kNumberSpriteHeight);
    CCSprite* sp = [CCSprite spriteWithBatchNode:m_numberManager rect:rect];
	sp.anchorPoint = ccp(0, 0.5);
	sp.position = ccp(kTextLabelSpriteWidth + 15, self.contentSize.height - kTextLabelSpriteHeight * 0.5 - 5);
	
	[m_numberManager addChild:sp z:0 tag:kNumberSpriteTag];
}


- (int) selectedIndex
{
	return m_menuItemToggle.selectedIndex;
}

- (void) setSelectedIndex:(int)idx
{
	m_menuItemToggle.selectedIndex = idx;
}

+ (id) layerWithLabelName:(NSString*) labelName toggle0:(NSString*)t0 toggle1:(NSString*)t1 
				 delegate:(id<IGGameGradeDelegate>) delegate
{
	return [[[self alloc] initWithLabelName:labelName toggle0:t0 toggle1:t1 delegate:delegate] autorelease];
}


- (id) initWithLabelName:(NSString*) labelName toggle0:(NSString*)t0 toggle1:(NSString*)t1
				delegate:(id<IGGameGradeDelegate>) delegate
{
	[super init];
	
	m_delegate = delegate;
	
    
	//CCSprite* levelLabel = [CCSprite spriteWithFile:labelName];	
    CCLabelBMFont *levelLabel= [CCLabelBMFont labelWithString:labelName fntFile:@"konqa32.fnt"];
	IGGameGradeSubLayer* layer = [[[IGGameGradeSubLayer alloc] initWithMenuTargetr:self] autorelease];
	m_gradeLayer = layer;
	
	CGFloat height = levelLabel.contentSize.height + layer.contentSize.height;
	self.contentSize = CGSizeMake(layer.contentSize.width, height);
	
	layer.anchorPoint = ccp(0, 0);
	
	levelLabel.anchorPoint = ccp(0, 1);
	levelLabel.position = ccp(0, height - 5);
	
	[CCMenuItemFont setFontName: @"Marker Felt"];
	[CCMenuItemFont setFontSize:30];
	m_menuItemToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(startSelected:) items:
						   [CCMenuItemFont itemFromString:t0],
						   [CCMenuItemFont itemFromString:t1],
						   nil];
	IGGameMenu* menu2 = [IGGameMenu menuWithItems:m_menuItemToggle, nil];
	[self addChild:menu2];
	menu2.color = ccc3(255, 255, 0);
	menu2.position = ccp(220, 61);
	
	[self addChild:layer];
	[self addChild:levelLabel];
    
    m_numberManager = [CCSpriteBatchNode batchNodeWithFile:@"MergeNumbers.png"];
	[self addChild:m_numberManager];
	
	self.grade = 9;
	
	return self;
}



- (void) startSelected:(id)sender
{
	CCMenuItemToggle* menuItem = (CCMenuItemToggle*)sender;
	if (m_delegate)
	{
		[m_delegate changeLayer:self selectIdx:menuItem.selectedIndex];
	}
}



- (void) startAddButton:(id)sender
{
	int grade = m_gradeLayer.grade;
	if (grade < 9)
	{
		grade++;
		self.grade = grade;
		
		if (m_delegate)
		{
			[m_delegate changeLayer:self grade:grade];
		}
	}
}


- (void) startMinusButton:(id)sender
{
	int grade = m_gradeLayer.grade;
	if (grade > 0)
	{
		grade--;
		self.grade = grade;
		
		if (m_delegate)
		{
			[m_delegate changeLayer:self grade:grade];
		}
	}
}


- (void) enableMenu
{
	[IGGameUtil enableMenu:m_gradeLayer];
	[IGGameUtil enableMenu:self];
}


- (void) disableMenu
{
	[IGGameUtil disableMenu:m_gradeLayer];
	[IGGameUtil disableMenu:self];
}


@end
