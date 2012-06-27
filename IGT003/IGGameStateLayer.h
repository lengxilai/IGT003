//
//  IGGameStateLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameDataManager.h"


@interface IGGameStateLayer : CCLayer 
{
	IGGameDataManager*	m_dataManager;
}
// 页面初始化
+ (id) layerWithDataManager:(IGGameDataManager*)manager;
- (id) initWithDataManager:(IGGameDataManager*)manager;
- (void) enterLayer;
- (void) levelLayer:(IGGameDataManager*)manager;

@end
