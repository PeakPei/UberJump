//
//  GameState.h
//  UberJump
//
//  Created by Jesus Magana on 7/3/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;
@property (nonatomic, assign) int stars;

+ (instancetype)sharedInstance;

- (void) saveState;

@end
