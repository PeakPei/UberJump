//
//  StarNode.h
//  UberJump
//
//  Created by Jesus Magana on 7/3/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "GameObjectNode.h"

typedef NS_ENUM(int, StarType) {
    STAR_NORMAL,
    STAR_SPECIAL,
};

@interface StarNode : GameObjectNode
@property (nonatomic, assign) StarType starType;

@end
