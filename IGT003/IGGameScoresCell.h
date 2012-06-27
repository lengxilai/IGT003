//
//  IGGameScoresCell.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IGGameScoresCell : UITableViewCell 
{
	IBOutlet	UILabel*	m_name;
	IBOutlet	UILabel*	m_score;
}

@property (nonatomic, retain)	UILabel*	m_name;
@property (nonatomic, retain)	UILabel*	m_score;

@end
