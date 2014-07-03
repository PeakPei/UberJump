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

@end