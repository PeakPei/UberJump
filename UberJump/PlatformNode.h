//
//  PlatformNode.h
//  UberJump
//
//  Created by Jesus Magana on 7/3/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "GameObjectNode.h"

typedef NS_ENUM(int, PlatformType) {
    PLATFORM_NORMAL,
    PLATFORM_BREAK,
};

@interface PlatformNode : GameObjectNode

@property (nonatomic, assign) PlatformType platformType;

@end
