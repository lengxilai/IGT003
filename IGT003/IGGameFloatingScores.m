//
//  IGGameFloatingScores.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGGameFloatingScores.h"


#define kFloatingNumberHeight	20

static int s_numbersWidth[11] =    { 14, 7, 14, 15, 15, 14, 14, 15, 14,  14,  19 };
static int s_numbersBeginPos[11] = { 0, 14, 21, 35, 50, 65, 79, 93, 108, 122, 136 };

@implementation IGGameFloatingScores

- (id) initWithBaseScore:(int)score hitTime:(int)time colorIdx:(int)idx
{
	[super init];
    m_spManager = [CCSpriteBatchNode batchNodeWithFile:@"HitNumbers.png"];
	[self addChild:m_spManager];
	
	unsigned char numIdxes[64];
	char buf[32];
	sprintf(buf, "%d", score);
	int len = strlen(buf);
	int totalNumIdx = 0;
	
	for (int i = 0; i < len; i++)
	{
		numIdxes[totalNumIdx++] = buf[i] - '0';
	}
	
	numIdxes[totalNumIdx++] = 10;
	sprintf(buf, "%d", time);
	len = strlen(buf);
	
	for (int i = 0; i < len; i++)
	{
		numIdxes[totalNumIdx++] = buf[i] - '0';
	}
	
	int totalWidth = 0;
	for (int i = 0; i < totalNumIdx; i++)
	{
		int numIdx = numIdxes[i];
		int xpos = s_numbersBeginPos[numIdx];
		
		CGRect rect = CGRectMake(xpos, kFloatingNumberHeight * idx, s_numbersWidth[numIdx], kFloatingNumberHeight);
        CCSprite* sp = [CCSprite spriteWithBatchNode:m_spManager rect:rect];
		sp.anchorPoint = ccp(0, 0);
		sp.position = ccp(totalWidth, 0);
		[m_spManager addChild:sp];
		
		totalWidth += s_numbersWidth[numIdx];
	}

	self.contentSize = CGSizeMake(totalWidth, kFloatingNumberHeight);
	
	return self;
}


+ (id) layerWithBaseScore:(int)score hitTime:(int)time colorIdx:(int)idx
{
	return [[[self alloc] initWithBaseScore:score hitTime:time colorIdx:idx] autorelease];
}


-(void) setColor:(ccColor3B)color
{
}

-(ccColor3B) color
{
	return ccc3(255, 255, 255);
}


-(GLubyte) opacity
{
	return 255;
}

-(void) setOpacity: (GLubyte) opacity
{
	CCArray* array = [m_spManager children];
	for (CCNode* node in array)
	{
		CCSprite* sp = (CCSprite*)node;
		[sp setOpacity:opacity];
	}
}

@end
