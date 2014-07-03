//
//  MyScene.m
//  UberJump
//
//  Created by Jesus Magana on 7/2/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "MyScene.h"
#import "StarNode.h"
#import "PlatformNode.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryPlayer   = 0x1 << 0,
    CollisionCategoryStar     = 0x1 << 1,
    CollisionCategoryPlatform = 0x1 << 2,
};

@interface MyScene () <SKPhysicsContactDelegate>
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
    
    // Height at which level ends
    int _endLevelY;
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
        
        // Load the level
        NSString *levelPlist = [[NSBundle mainBundle] pathForResource: @"Level01" ofType: @"plist"];
        NSDictionary *levelData = [NSDictionary dictionaryWithContentsOfFile:levelPlist];
        
        // Height at which the player ends the level
        _endLevelY = [levelData[@"EndY"] intValue];
        
            // Add a platform
            //PlatformNode *platform = [self createPlatformAtPosition:CGPointMake(160, 320) ofType:PLATFORM_NORMAL];
            //[_foregroundNode addChild:platform];
        // Add the platforms
        NSDictionary *platforms = levelData[@"Platforms"];
        NSDictionary *platformPatterns = platforms[@"Patterns"];
        NSArray *platformPositions = platforms[@"Positions"];
        for (NSDictionary *platformPosition in platformPositions) {
            CGFloat patternX = [platformPosition[@"x"] floatValue];
            CGFloat patternY = [platformPosition[@"y"] floatValue];
            NSString *pattern = platformPosition[@"pattern"];
            
            // Look up the pattern
            NSArray *platformPattern = platformPatterns[pattern];
            for (NSDictionary *platformPoint in platformPattern) {
                CGFloat x = [platformPoint[@"x"] floatValue];
                CGFloat y = [platformPoint[@"y"] floatValue];
                PlatformType type = [platformPoint[@"type"] intValue];
                
                PlatformNode *platformNode = [self createPlatformAtPosition:CGPointMake(x + patternX, y + patternY)
                                                                     ofType:type];
                [_foregroundNode addChild:platformNode];
            }
        }
        
            // Add a star
            //StarNode *star = [self createStarAtPosition:CGPointMake(160, 220) ofType:STAR_SPECIAL];
            //[_foregroundNode addChild:star];
        // Add the stars
        NSDictionary *stars = levelData[@"Stars"];
        NSDictionary *starPatterns = stars[@"Patterns"];
        NSArray *starPositions = stars[@"Positions"];
        for (NSDictionary *starPosition in starPositions) {
            CGFloat patternX = [starPosition[@"x"] floatValue];
            CGFloat patternY = [starPosition[@"y"] floatValue];
            NSString *pattern = starPosition[@"pattern"];
            
            // Look up the pattern
            NSArray *starPattern = starPatterns[pattern];
            for (NSDictionary *starPoint in starPattern) {
                CGFloat x = [starPoint[@"x"] floatValue];
                CGFloat y = [starPoint[@"y"] floatValue];
                StarType type = [starPoint[@"type"] intValue];
                
                StarNode *starNode = [self createStarAtPosition:CGPointMake(x + patternX, y + patternY) ofType:type];
                [_foregroundNode addChild:starNode];
            }
        }
        
        // Add the player
        _player = [self createPlayer];
        [_foregroundNode addChild:_player];
        
        // Add some gravity
        self.physicsWorld.gravity = CGVectorMake(0.0f, -2.0f);
        
        // Set contact delegate
        self.physicsWorld.contactDelegate = self;
        
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
    
    // 1
    playerNode.physicsBody.usesPreciseCollisionDetection = YES;
    // 2
    playerNode.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    // 3
    playerNode.physicsBody.collisionBitMask = 0;
    // 4
    playerNode.physicsBody.contactTestBitMask = CollisionCategoryStar | CollisionCategoryPlatform;
    
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

- (StarNode *) createStarAtPosition:(CGPoint)position ofType:(StarType)type
{
    // 1
    StarNode *node = [StarNode node];
    [node setPosition:position];
    [node setName:@"NODE_STAR"];
    
    // 2
    /*SKSpriteNode *sprite;
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
    [node addChild:sprite];*/
    
    [node setStarType:type];
    SKSpriteNode *sprite;
    if (type == STAR_SPECIAL) {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"StarSpecial"];
    } else {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
    }
    [node addChild:sprite];
    
    // 3
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    
    // 4
    node.physicsBody.dynamic = NO;
    
    node.physicsBody.categoryBitMask = CollisionCategoryStar;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

- (PlatformNode *) createPlatformAtPosition:(CGPoint)position ofType:(PlatformType)type
{
    // 1
    PlatformNode *node = [PlatformNode node];
    [node setPosition:position];
    [node setName:@"NODE_PLATFORM"];
    [node setPlatformType:type];
    
    // 2
    SKSpriteNode *sprite;
    if (type == PLATFORM_BREAK) {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"PlatformBreak"];
    } else {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Platform"];
    }
    [node addChild:sprite];
    
    // 3
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    node.physicsBody.dynamic = NO;
    node.physicsBody.categoryBitMask = CollisionCategoryPlatform;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    BOOL updateHUD = NO;
    
    // 2
    SKNode *other = (contact.bodyA.node != _player) ? contact.bodyA.node : contact.bodyB.node;
    
    // 3
    updateHUD = [(GameObjectNode *)other collisionWithPlayer:_player];
    
    // Update the HUD if necessary
    if (updateHUD) {
        // 4 TODO: Update HUD in Part 2
    }
}


@end