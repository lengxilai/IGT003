//
//  IGGameNumberLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameNumberLayer.h"
#import "IGCommonDefine.h"


@implementation IGGameNumberLayer


// 取得图形文字
- (id) initWithNumber:(int)number
{
	[super init];
	
	char buf[24];
	sprintf(buf, "%d", number);
	
	int len = strlen(buf);
	CGSize layerSize = CGSizeMake(kNumberSpriteWidth * len, kNumberSpriteHeight);
	self.contentSize = layerSize;
    CCSpriteBatchNode* spriteManager = [CCSpriteBatchNode batchNodeWithFile:@"MergeNumbers.png"];

	[self addChild:spriteManager];
	
	for (int i = 0; i < len; i++)
	{
		CGRect rect = CGRectMake((buf[i] - '0') * kNumberSpriteWidth, 0, kNumberSpriteWidth, kNumberSpriteHeight);
        CCSprite* sp = [CCSprite spriteWithBatchNode:spriteManager rect:rect];
		sp.anchorPoint = ccp(0, 0);
		sp.position = ccp(i * kNumberSpriteWidth, 0);
		[spriteManager addChild:sp];
	}
	
	return self;
}


+ (id) layerWithNumber:(int)number
{
	return [[[self alloc] initWithNumber:number] autorelease];
}

@end
