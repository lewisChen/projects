//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "./DataHandler/GameDataHandler.h"
#import "Def/SoundDef.h"

@implementation MainScene

- (void) didLoadFromCCB
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoDo];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoRe];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoMi];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoFa];
}


-(void)buttonPress:(id)sender
{
    if (sender==m_buttonType1)
    {
        [GameDataHandler sharedGameDataHandler].gameMode = eGameModeTime;
        [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoDo];
        CCLOG(@"Time Mode");
    }
    else if(sender==m_buttonType2)
    {
        [GameDataHandler sharedGameDataHandler].gameMode = eGameModeCount;
        [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoRe];
        CCLOG(@"Count Mode");
    }
    else if(sender==m_buttonType3)
    {
        [GameDataHandler sharedGameDataHandler].gameMode = eGameModeCrazy;
        [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoMi];
        CCLOG(@"Crazy Mode");
    }
    else if(sender==m_buttonType4)
    {
        [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoFa];
        CCLOG(@"Game Center");
    }
    
    if (sender!=m_buttonType4)
    {
        //set select type
        //[GameDataHandler sharedGameDataHandler].blockTypeSelect = blockType;
        CCScene *scene = [CCBReader loadAsScene:@"StartPlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.2]];

    }
    
}

@end
