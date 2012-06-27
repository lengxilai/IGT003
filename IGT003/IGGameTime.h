//
//  IGGameTime.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "IGCommonDefine.h"
#import "IGGameBoard.h"

@interface IGGameTime : CCLayer 
{
	CCSpriteBatchNode*	m_manager;
    IGGameBoard      *  m_board;
	int					m_time;
}

@property (nonatomic, assign)	int	time;
@property (nonatomic, retain)	IGGameBoard* m_board;

- (id) initWithTime:(int)time;
+ (id) layerWithTime:(int)time;
- (void) stopTimer;
- (void) startTimer;
@end
