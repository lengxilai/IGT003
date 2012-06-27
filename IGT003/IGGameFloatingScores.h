//
//  IGGameFloatingScores.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface IGGameFloatingScores : CCLayer<CCRGBAProtocol> 
{
	CCSpriteBatchNode*		m_spManager;
}

- (id) initWithBaseScore:(int)score hitTime:(int)time colorIdx:(int)idx;
+ (id) layerWithBaseScore:(int)score hitTime:(int)time colorIdx:(int)idx;

-(void) setColor:(ccColor3B)color;
-(ccColor3B) color;
-(GLubyte) opacity;
-(void) setOpacity: (GLubyte) opacity;

@end
