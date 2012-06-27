//
//  IGGameStateLayer.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameStateLayer.h"
#import "IGGameUtil.h"

@implementation IGGameStateLayer

// 初始化函数
+ (id) layerWithDataManager:(IGGameDataManager*)manager
{
	return [[[self alloc] initWithDataManager:manager] autorelease];
}


- (id) initWithDataManager:(IGGameDataManager*)manager
{
	[super init];
	m_dataManager = manager;
	return self;
}


- (void) enterLayer
{
	[IGGameUtil enableMenu:self];
}


- (void) levelLayer:(IGGameDataManager*)manager
{
	[IGGameUtil disableMenu:self];
}

@end
