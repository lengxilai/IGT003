//
//  IGGameHelpInfoCell.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IGGameHelpInfoCell : UITableViewCell 
{
    // 帮助信息
    IBOutlet UILabel *m_info;
}

@property (nonatomic, retain)	UILabel*	m_info;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
