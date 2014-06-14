//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

-(void)playBtnPress:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"PlayScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft duration:0.2]];

}

-(void)helpBtnPress:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"helpScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft duration:0.2]];

}

@end
