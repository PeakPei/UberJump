//
//  MyScene.m
//  UberJump
//
//  Created by Jesus Magana on 7/2/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()
{
    // Layered Nodes
    SKNode *_backgroundNode;
    SKNode *_midgroundNode;
    SKNode *_foregroundNode;
    SKNode *_hudNode;
    // Player
    SKNode *_player;
    // Tap To Start node
    SKSpriteNode *_tapToStartNode;
}
@end

@implementation MyScene

- (id) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        // Create the game nodes
        // Background
        _backgroundNode = [self createBackgroundNode];
        [self addChild:_backgroundNode];
        // Foreground
        _foregroundNode = [SKNode node];
        [self addChild:_foregroundNode];
        // Add the player
        _player = [self createPlayer];
        [_foregroundNode addChild:_player];
        // Add some gravity
        self.physicsWorld.gravity = CGVectorMake(0.0f, -2.0f);
        // HUD
        _hudNode = [SKNode node];
        [self addChild:_hudNode];
        // Tap to Start
        _tapToStartNode = [SKSpriteNode spriteNodeWithImageNamed:@"TapToStart"];
        _tapToStartNode.position = CGPointMake(160, 180.0f);
        [_hudNode addChild:_tapToStartNode];
        
    }
    return self;
}

- (SKNode *) createBackgroundNode
{
    // 1
    // Create the node
    SKNode *backgroundNode = [SKNode node];
    
    // 2
    // Go through images until the entire background is built
    for (int nodeCount = 0; nodeCount < 20; nodeCount++) {
        // 3
        NSString *backgroundImageName = [NSString stringWithFormat:@"Background%02d", nodeCount+1];
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:backgroundImageName];
        // 4
        node.anchorPoint = CGPointMake(0.5f, 0.0f);
        node.position = CGPointMake(160.0f, nodeCount*64.0f);
        // 5
        [backgroundNode addChild:node];
    }
    
    // 6
    // Return the completed background node
    return backgroundNode;
}

- (SKNode *) createPlayer
{
    SKNode *playerNode = [SKNode node];
    [playerNode setPosition:CGPointMake(160.0f, 80.0f)];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Player"];
    [playerNode addChild:sprite];
    
    // 1
    playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    // 2
    playerNode.physicsBody.dynamic = NO;
    // 3
    playerNode.physicsBody.allowsRotation = NO;
    // 4
    playerNode.physicsBody.restitution = 1.0f;
    playerNode.physicsBody.friction = 0.0f;
    playerNode.physicsBody.angularDamping = 0.0f;
    playerNode.physicsBody.linearDamping = 0.0f;
    
    return playerNode;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1
    // If we're already playing, ignore touches
    if (_player.physicsBody.dynamic) return;
    
    // 2
    // Remove the Tap to Start node
    [_tapToStartNode removeFromParent];
    
    // 3
    // Start the player by putting them into the physics simulation
    _player.physicsBody.dynamic = YES;
    // 4
    [_player.physicsBody applyImpulse:CGVectorMake(0.0f, 20.0f)];
}


@end