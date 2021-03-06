//
//  GameKitHelper.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-3-24.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "GameKitHelper.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper

#pragma mark Singleton stuff

+(id) sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        
        [self setLastError:error];
        
        if ([CCDirector sharedDirector].isPaused)
            [[CCDirector sharedDirector] resume];
        
        if (localPlayer.authenticated)
        {
            _gameCenterFeaturesEnabled = YES;
        }
        else if(viewController)
        {
            [[CCDirector sharedDirector] pause];
            [self presentViewController:viewController];
        }
        else
        {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}

#pragma mark Property setters

-(void) setLastError:(NSError*)error
{
    _lastError = [error copy];
    if (_lastError)
    {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc
{
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES completion:nil];
}

-(void) submitScore:(int64_t)score category:(NSString*)identifier
{
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        CCLOG(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore =[[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    
    //3: Set the score value
    gkScore.value = score;
    
    NSArray *scores = @[gkScore];
    
    //4: Send the score to Game Center
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error)
     {
        if (error) {
            // handle error
            [self setLastError:error];
            
            BOOL success = (error == nil);
            
            if ([_delegate respondsToSelector:@selector(onScoresSubmitted:)])
            {
                
                [_delegate onScoresSubmitted:success];
            }

        }
    }];
    
}

- (void)showLeaderboard : (NSString*)leaderboard
{
    if (!_gameCenterFeaturesEnabled)
        return;
    UIViewController* rootVC = [self getRootViewController];
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    gameCenterViewController.leaderboardIdentifier = leaderboard;
    gameCenterViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gameCenterViewController.gameCenterDelegate = self;
    [rootVC presentViewController:gameCenterViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:^(void){}];
}


@end
