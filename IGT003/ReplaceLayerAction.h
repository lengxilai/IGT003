//
//  ReplaceLayerAction.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameStateLayer.h"




@interface ReplaceLayerAction : CCActionInterval {
	CCScene *scene;
	IGGameStateLayer* layer;
	IGGameStateLayer *replaceLayer;
	bool reverse;
}

@property (nonatomic) bool reverse;

-(id) initWithScene:(CCScene*)_scene layer:(IGGameStateLayer*)_layer replaceLayer:(IGGameStateLayer*)_replaceLayer;

@end
