//
//  StartPlayScene.m
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import "StartPlayScene.h"
#import "../DataHandler/GameDataHandler.h"
#import "../Def/SoundDef.h"
#import "../AppDelegate.h"

@implementation StartPlayScene

- (void) didLoadFromCCB
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectTouched];

    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoSo];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoLa];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoQi];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoDi];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter postNotificationName:kShowAdMessage object:nil];
}


-(void)buttonPress:(id)sender
{
    eBlockType blockType = eBlockTypeUnknow;
    
    if (sender==m_buttonType1)
    {
        blockType = eBlockType1;
        [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoSo];
        CCLOG(@"button1");
    }
    else if(sender==m_buttonType2)
    {
        blockType = eBlockType2;
        [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoLa];
        CCLOG(@"button2");
    }
    else if(sender==m_buttonType3)
    {
        blockType = eBlockType3;
        [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoQi];
        CCLOG(@"button3");
    }
    else if(sender==m_buttonType4)
    {
        blockType = eBlockType4;
        [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoDi];
        CCLOG(@"button4");
    }
    
    //set select type
    [GameDataHandler sharedGameDataHandler].blockTypeSelect = blockType;
    
    CCScene *scene = [CCBReader loadAsScene:@"ReadyGoScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
    //[[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];

}

- (void)backPress:(id)sender
{
    [[OALSimpleAudio sharedInstance] playEffect:kEffectTouched];
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.2]];
    
}


@end






