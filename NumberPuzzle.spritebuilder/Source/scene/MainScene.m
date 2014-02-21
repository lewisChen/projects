//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#include "CCBReader.h"
#import "LevelLayer.h"
#import "GameDataHandler.h"
#include "../libs/cocos2d-iphone/external/ObjectAL/OALSimpleAudio.h"
#import "../SoundDef/SoundDef.h"


enum eLevel
{
    eLevelEasy = 0,
    eLevelNormal,
    eLevelHard,
};

@implementation MainScene

- (void) didLoadFromCCB
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectClickButton];
}

-(void)buttonPress:(id)sender
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    dataHandler.level = eLevelEasy;
    
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];

    CCScene *scene = [CCBReader loadAsScene:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)buttonPressSimple:(id)sender
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    dataHandler.level = eLevelNormal;
    
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];
    
    CCScene *scene = [CCBReader loadAsScene:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
