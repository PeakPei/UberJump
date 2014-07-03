//
//  GameState.m
//  UberJump
//
//  Created by Jesus Magana on 7/3/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "GameState.h"

@implementation GameState

- (id) init
{
    if (self = [super init]) {
        // Init
        _score = 0;
        _highScore = 0;
        _stars = 0;
        
        // Load game state
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id highScore = [defaults objectForKey:@"highScore"];
        if (highScore) {
            _highScore = [highScore intValue];
        }
        id stars = [defaults objectForKey:@"stars"];
        if (stars) {
            _stars = [stars intValue];
        }
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static GameState *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[super alloc] init];
    });
    return _sharedInstance;
}

- (void) saveState
{
    // Update highScore if the current score is greater
    _highScore = MAX(_score, _highScore);
    
    // Store in user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_highScore] forKey:@"highScore"];
    [defaults setObject:[NSNumber numberWithInt:_stars] forKey:@"stars"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
