//
//  IGGameNumberLayer.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"


@interface IGGameNumberLayer : CCLayer {
}

- (id) initWithNumber:(int)number;
+ (id) layerWithNumber:(int)number;

@end
