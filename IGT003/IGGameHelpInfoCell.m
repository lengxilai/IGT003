//
//  IGGameHelpInfoCell.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGGameHelpInfoCell.h"


@implementation IGGameHelpInfoCell


@synthesize m_info;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // cell的背景颜色设定
        self.contentView.backgroundColor  = [UIColor clearColor];
        
        // 信息显示        
        m_info = [[UILabel alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:m_info];
    }
    return self;
}

- (void) dealloc
{
	[m_info release];
	[super dealloc];
}

@end
