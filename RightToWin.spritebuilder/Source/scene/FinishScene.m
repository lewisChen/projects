//
//  FinishScene.m
//  Tap Right Tile to Win
//
//  Created by mybox_1027@sina.com on 14-4-28.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "FinishScene.h"
#import "../DataHandler/GameDataHandler.h"
#import "../Def/SoundDef.h"
#import "../DataHandler/GameKitHelper.h"


typedef enum : NSUInteger {
    eColor_1 = 0,
    eColor_2,
    eColor_3,
    eColor_4,
    eColor_5,
    eColor_6,
    
    eColorMax
} eColor;

@implementation FinishScene

- (void) didLoadFromCCB
{
    [self setBackgroundRandomColor];
    GameDataHandler *dataHandle = [GameDataHandler sharedGameDataHandler];
    eGameMode mode = dataHandle.gameMode;
    dataHandle.errorCount++;
    switch (mode)
    {
        case eGameModeTime:
            m_labelTime.visible = YES;
            m_lableCount.visible = NO;
            m_lableCrazy.visible = NO;
            break;
        case eGameModeCount:
            m_labelTime.visible = NO;
            m_lableCount.visible = YES;
            m_lableCrazy.visible = NO;
            break;
        case eGameModeCrazy:
            m_labelTime.visible = NO;
            m_lableCount.visible = NO;
            m_lableCrazy.visible = YES;
            break;
        default:
            break;
    }
    
    [m_blockObj setType:(eBlockType)dataHandle.blockTypeSelect];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectTouched];
    [m_labelTapCount setString:[NSString stringWithFormat:@"%d",dataHandle.tapCount]];
    
    [self sumitScore];
    

    [self showAlertView];
}

-(void)buttonPress:(id)sender
{
    if (m_buttonRetry == sender)
    {
        CCScene *scene = [CCBReader loadAsScene:@"ReadyGoScene"];
        [[CCDirector sharedDirector] replaceScene:scene];
    }
    else if(m_buttonBack == sender)
    {
        CCScene *scene = [CCBReader loadAsScene:@"StartPlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];
    }
    [[OALSimpleAudio sharedInstance] playEffect:kEffectTouched];
}

-(void)sumitScore
{
    GameDataHandler *dataHandle = [GameDataHandler sharedGameDataHandler];
    eGameMode mode = dataHandle.gameMode;
    switch (mode)
    {
        case eGameModeTime:
            [[GameKitHelper sharedGameKitHelper] submitScore:dataHandle.tapCount category:kBoardIdentifierTimeMode];
            break;
        case eGameModeCount:
            [[GameKitHelper sharedGameKitHelper] submitScore:dataHandle.tapCount category:kBoardIdentifierCountMode];
            break;
        case eGameModeCrazy:
            [[GameKitHelper sharedGameKitHelper] submitScore:dataHandle.tapCount category:kBoardIdentifierCrazeMode];
            break;
        default:
            break;
    }

}

-(void)setBackgroundRandomColor
{
    NSInteger colorIndex = (arc4random()%eColorMax);
    ccColor3B color = ccBLACK;
    switch (colorIndex)
    {
        case eColor_1:
            color = ccc3(100, 0, 20);
            break;
        case eColor_2:
            color = ccMAGENTA;
            break;
        case eColor_3:
            color = ccORANGE;
            break;
        case eColor_4:
            color = ccc3(200, 10, 150);
            break;
        case eColor_5:
            color = ccGRAY;
            break;
        case eColor_6:
            color = ccBLACK;
            break;
            
        default:
            break;
    }
    [m_background setColor:[CCColor colorWithCcColor3b:color]];
}

-(void)showAlertView
{
    GameDataHandler *dataHandle = [GameDataHandler sharedGameDataHandler];
    if (dataHandle.enterGameCount>=2)
    {
        if (NO == dataHandle.getIsRate)
        {
            CGSize winSize = [[UIScreen mainScreen] bounds].size;
            
            CCNode *alertView = [CCBReader load:@"alertNode"];
            alertView.position = ccp(winSize.width/2, winSize.height/2);
            [self addChild:alertView];
        }
    }
    
}

@end
