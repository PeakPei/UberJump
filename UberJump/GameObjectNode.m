//
//  GameObjectNode.m
//  UberJump
//
//  Created by Jesus Magana on 7/3/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "GameObjectNode.h"

@implementation GameObjectNode

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    return NO;
}

- (void) checkNodeRemoval:(CGFloat)playerY
{
    if (playerY > self.position.y + 300.0f) {
        [self removeFromParent];
    }
}

@end
