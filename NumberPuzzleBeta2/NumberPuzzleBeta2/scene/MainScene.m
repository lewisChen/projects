//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#include "CCBReader.h"

@implementation MainScene

-(void)buttonPress:(id)sender
{
    CCScene *scene = [CCBReader sceneWithNodeGraphFromFile:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
