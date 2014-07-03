//
//  StarNode.m
//  UberJump
//
//  Created by Jesus Magana on 7/3/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

@import AVFoundation;
#import "StarNode.h"

@interface StarNode ()
{
    SKAction *_starSound;
}
@end

@implementation StarNode

- (id) init
{
    if (self = [super init]) {
        // Sound for when a star is collected
        _starSound = [SKAction playSoundFileNamed:@"StarPing.wav" waitForCompletion:NO];
    }
    
    return self;
}

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    // Boost the player up
    player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 400.0f);
    
    // Play sound
    [self.parent runAction:_starSound];
    
    // Remove this star
    [self removeFromParent];
    
    // Award score
    [GameState sharedInstance].score += (_starType == STAR_NORMAL ? 20 : 100);
    
    // Award stars
    [GameState sharedInstance].stars += (_starType == STAR_NORMAL ? 1 : 5);
    
    // The HUD needs updating to show the new stars and score
    return YES;
}

@end
