//
//  GameScoresCell.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGGameScoresCell.h"


@implementation IGGameScoresCell


@synthesize m_name;
@synthesize m_score;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // cell的背景颜色设定
        self.contentView.backgroundColor  = [UIColor clearColor];
        
        // 名字显示        
        m_name = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width*0.5, self.contentView.frame.size.height)];
        m_name.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:m_name];
        
        // 名字显示        
        m_score = [[UILabel alloc] initWithFrame:CGRectMake(m_name.frame.size.width, self.contentView.frame.origin.y, self.contentView.frame.size.width*0.5, self.contentView.frame.size.height)];
        m_score.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:m_score];
    }
    return self;
}

- (void) dealloc
{
	[m_name release];
	[m_score release];
	[super dealloc];
}

@end
