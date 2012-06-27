//
//  IGGameHelpLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "IGGameStateLayer.h"


@interface IGGameHelpLayer : IGGameStateLayer<UITableViewDataSource, UITableViewDelegate> 
{
	UITableView*			m_tableView;
	NSArray*				m_infoArray;
}

// 页面初始化
- (id) initWithDataManager:(IGGameDataManager*)manager;
// 返回
- (void) returnMenu:(id)sender;


@end
