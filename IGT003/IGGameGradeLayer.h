//
//  IGGameGradeLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"


@class IGGameGradeLayer;

// 更新协议
@protocol IGGameGradeDelegate
- (void) changeLayer:(IGGameGradeLayer*)layer grade:(int)grade;
- (void) changeLayer:(IGGameGradeLayer*)layer selectIdx:(int)idx;
@end




@class	IGGameGradeSubLayer;
@interface IGGameGradeLayer : CCLayer
{
	CCSpriteBatchNode*		m_numberManager;
	IGGameGradeSubLayer*		m_gradeLayer;
	id<IGGameGradeDelegate>	m_delegate;
	CCMenuItemToggle*			m_menuItemToggle;
}

- (id) initWithLabelName:(NSString*) labelName toggle0:(NSString*)t0 toggle1:(NSString*)t1 delegate:(id<IGGameGradeDelegate>) delegate;
+ (id) layerWithLabelName:(NSString*) labelName toggle0:(NSString*)t0 toggle1:(NSString*)t1 delegate:(id<IGGameGradeDelegate>) delegate;

- (void) startAddButton:(id)sender;
- (void) startMinusButton:(id)sender;
- (void) startSelected:(id)sender;

- (void) enableMenu;
- (void) disableMenu;

@property (nonatomic, assign)   int	grade;
@property (nonatomic, assign)	int selectedIndex;

@end

