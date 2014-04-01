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
#import "GameKitHelper.h"


@implementation MainScene

- (void) didLoadFromCCB
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectClickButton];
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

-(void)buttonPress:(id)sender
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    dataHandler.difficultLevel = eDifficultLevelEasy;
    
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];

    CCScene *scene = [CCBReader loadAsScene:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)buttonPressNormal:(id)sender
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    dataHandler.difficultLevel = eDifficultLevelNormal;
    
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];
    
    CCScene *scene = [CCBReader loadAsScene:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)buttonPressHard:(id)sender
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    dataHandler.difficultLevel = eDifficultLevelHard;
    
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];
    
    CCScene *scene = [CCBReader loadAsScene:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)buttonPressReset:(id)sender
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    [dataHandler resetSaveData];
}

-(void)btnGameCenter:(id)sender
{
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];
    [[GameKitHelper sharedGameKitHelper] showLeaderboard:kHighScoreBoardIdentifier];

}

@end
