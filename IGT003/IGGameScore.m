//
//  GameScore.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGGameScore.h"
#import "IGCommonDefine.h"

#define k88888Sprite1Tag	1001


@implementation IGGameScore

@synthesize score = m_score;

- (void) showScore:(int) num
{
	[m_manager removeAllChildrenWithCleanup:YES];
	[self removeChild:[self getChildByTag:k88888Sprite1Tag] cleanup:YES];
	
	char	strNum[64];
	sprintf(strNum, "%d", num);
	
	int len = strlen(strNum);
    
    int ypos = 5 ;
    int xpos = 5 + kNumberSpriteWidth * 4;
    
    for (int idx = len - 1; idx >= 0; idx--)
    {
        CGRect rect = CGRectMake((strNum[idx] - '0') * kNumberSpriteWidth, 0, kNumberSpriteWidth, kNumberSpriteHeight);
        CCSprite* sp = [CCSprite spriteWithBatchNode:m_manager rect:rect];
        sp.position = ccp(xpos, ypos);
        sp.anchorPoint = ccp(0, 0);
        [m_manager addChild:sp];
        xpos -= kNumberSpriteWidth;
    }	
}

- (id) initWithScore:(int)score
{
	[super init];
    
    m_manager = [CCSpriteBatchNode batchNodeWithFile:@"MergeNumbers.png"];
	[self addChild:m_manager z:1];
	
	m_score = score;
	[self showScore:score];
	
	return self;
}


- (void) setScore:(int) score
{
	m_score = score;
	[self showScore:m_score];
}


@end
