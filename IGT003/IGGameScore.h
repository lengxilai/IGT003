//
//  IGGameScore.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface IGGameScore : CCLayer 
{
	CCSpriteBatchNode*	m_manager;
	int					m_score;
}


@property (nonatomic, assign) int	score;

- (id) initWithScore:(int)score;


@end
