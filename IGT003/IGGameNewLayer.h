//
//  IGGameNewLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "IGGameStateLayer.h"
#import "IGGameGradeLayer.h"



@interface IGGameNewLayer : IGGameStateLayer<UITextFieldDelegate>
{
	UITextField*		m_nameField;
}

- (id) initWithDataManager:(IGGameDataManager*)manager;

- (void) startCancel:(id)sender;
- (void) startStart:(id)sender;

@end
