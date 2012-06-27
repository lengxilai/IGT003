//
//  IGGameMenu.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IGGameMenu.h"
#import "SimpleAudioEngine.h"


@implementation IGGameMenu

// 播放按钮点击音乐
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	BOOL res = [super ccTouchBegan:touch withEvent:event];
	if (state_ == kCCMenuStateTrackingTouch)
	{
		[[SimpleAudioEngine sharedEngine] playEffect:@"ButtonClick.wav"];
	}
	return res;
}

@end
