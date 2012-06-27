//
//  IGGameUtil.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGGameUtil.h"
#import "AppDelegate.h"
#import "IGGamePlayingLayer.h"
#import "SimpleAudioEngine.h"

@implementation IGGameUtil

+ (void) enableMenu:(CCLayer*) layer
{
	CCArray* children = [layer children];
	for (CCNode* node in children)
	{
		if ([node isKindOfClass:[CCMenu class]])
		{
			((CCMenu*)node).isTouchEnabled = YES;
		}
	}
}


+ (void) disableMenu:(CCLayer*) layer
{
	CCArray* children = [layer children];
	for (CCNode* node in children)
	{
		if ([node isKindOfClass:[CCMenu class]])
		{
			((CCMenu*)node).isTouchEnabled = NO;
		}
	}
}


static NSString* lastBkMusicName = nil;

+ (void) playerBKMusic:(NSString*)fileName volume:(CGFloat)volume
{
	if (fileName == nil)
	{
		[lastBkMusicName release];
		lastBkMusicName = nil;
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
	else
	{
		SimpleAudioEngine* engin = [SimpleAudioEngine sharedEngine];
		if (lastBkMusicName == nil)
		{
			[engin preloadBackgroundMusic:fileName];
			engin.backgroundMusicVolume = volume;
			[engin playBackgroundMusic:fileName];
		}
		else if (![lastBkMusicName isEqualToString:fileName])
		{
			[engin preloadBackgroundMusic:fileName];
			engin.backgroundMusicVolume = volume;
			[engin playBackgroundMusic:fileName];			
		}
		
		[lastBkMusicName release];
		lastBkMusicName = [[NSString alloc] initWithString:fileName];
	}
}


@end
