//
//  IGScoreUtil.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGScoreUtil.h"

@implementation IGScoreUtil
// 计算得分
+(int) ComputeScores:(int) num;
{
	//assert(num >= 3);
	return 50 * num;
	int score = 150;
	num -= 3;
	
	int tmp = 50;
	for (int i = 0; i < num; i++)
	{
		score += tmp;
		tmp += 50;
	}
	
	return score;
}
@end
