//
//  IGGameTime.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGGameTime.h"
#import "GameConfig.h"


@implementation IGGameTime


@synthesize time = m_time;
@synthesize m_board;

- (void) showTime:(int) time 
{
	[m_manager removeAllChildrenWithCleanup:YES];
	
	char	strNum[64];
	sprintf(strNum, "%d", time);
	
	int len = strlen(strNum);
	len = len < 5 ? len : 5;
	int xpos = 5 + (5 - len) * kNumberSpriteWidth;
	
	for (int i = 0; i < len; i++)
	{
		CGRect rect = CGRectMake((strNum[i] - '0') * kNumberSpriteWidth, 0, kNumberSpriteWidth, kNumberSpriteHeight);
        CCSprite* sp = [CCSprite spriteWithBatchNode:m_manager rect:rect];
		sp.position = ccp(xpos, 5);
		sp.anchorPoint = ccp(0, 0);
		[m_manager addChild:sp];
		xpos += kNumberSpriteWidth;
	}
}



- (id) initWithTime:(int)time
{
	[super init];

    m_manager = [CCSpriteBatchNode batchNodeWithFile:@"MergeNumbers.png"];
	[self addChild:m_manager];
	
	m_time = time;
	[self showTime:m_time];
	
	return self;
}


- (void) setTime:(ccTime) t
{
    if(m_time <= 0){
        [self stopTimer];
        m_board.s_needGameOver = true;
        return;
    }
	m_time = m_time--;
	[self showTime:m_time];
}


+ (id) layerWithTime:(int)time
{
	return [[[IGGameTime alloc] initWithTime:time] autorelease];
}

- (void) stopTimer
{
	[self unschedule:@selector(setTime:)];
}

- (void) startTimer
{
	[self schedule:@selector(setTime:) interval:1.0];
}

@end
