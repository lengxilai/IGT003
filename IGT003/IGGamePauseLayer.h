//
//  IGGamePauseLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameSettingLayer.h"


@interface IGGamePauseLayer : IGGameSettingLayer
{
}

- (id) initWithDataManager:(IGGameDataManager*)manager;

- (void) startMenu:(id)sender;
- (void) startResume:(id)sender;

@end
