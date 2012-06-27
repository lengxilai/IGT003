//
//  IGGameOverLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameStateLayer.h"


@interface IGGameOverLayer : IGGameStateLayer {

}


- (id) initWithDataManager:(IGGameDataManager*)manager;


- (void) returnMenu:(id)sender;
- (void) startRetry:(id)sender;

@end
