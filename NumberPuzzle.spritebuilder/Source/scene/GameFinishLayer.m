//
//  GameFinishLayer.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-1-21.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "GameFinishLayer.h"
#include "CCBReader.h"

@implementation GameFinishLayer

-(void)retryButtonPress:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)nextButtonPress:(id)sender
{
    
}

@end
