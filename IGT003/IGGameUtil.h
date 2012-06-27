//
//  IGGameUtil.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface IGGameUtil : NSObject {
    
}
+ (void) enableMenu:(CCLayer*) layer;
+ (void) disableMenu:(CCLayer*) layer;
+ (void) playerBKMusic:(NSString*)fileName volume:(CGFloat)volume;
@end
