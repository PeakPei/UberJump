//
//  StarNode.m
//  UberJump
//
//  Created by Jesus Magana on 7/3/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "StarNode.h"

@implementation StarNode

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    // Boost the player up
    player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 400.0f);
    
    // Remove this star
    [self removeFromParent];
    
    // The HUD needs updating to show the new stars and score
    return YES;
}

@end
