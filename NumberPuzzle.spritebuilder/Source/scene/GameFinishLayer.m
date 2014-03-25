//
//  GameFinishLayer.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-1-21.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "GameFinishLayer.h"
#include "CCBReader.h"
#include "../libs/cocos2d-iphone/external/ObjectAL/OALSimpleAudio.h"
#import "../SoundDef/SoundDef.h"
#import "GameDataHandler.h"
#import "GameKitHelper.h"

enum Estar
{
    eStar1,
    eStar2,
    eStar3,
};

@implementation GameFinishLayer

@synthesize starCount = m_starCount;

- (void) didLoadFromCCB
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    self.contentSize = [CCDirector sharedDirector].viewSize;
    
    m_labelResult = [CCLabelBMFont labelWithString:@"" fntFile:@"FinishFont.fnt"];
    m_labelResult.position = ccp(self.contentSize.width/2, self.contentSize.height*3/4);
    [self addChild:m_labelResult];

    [m_labelLevel setString:[NSString stringWithFormat:@"%d",dataHandler.level]];
    
    [self initResource];
    m_arraySprite = [NSMutableArray arrayWithObjects:m_star1,m_star2,m_star3,nil];
    [self handleShowScore];
    
    [dataHandler saveData];
    [[GameKitHelper sharedGameKitHelper] submitScore:dataHandler.starCount category:kHighScoreBoardIdentifier];
}

-(void)retryButtonPress:(id)sender
{
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];
    CCScene *scene = [CCBReader loadAsScene:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)nextButtonPress:(id)sender
{
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];

    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    dataHandler.level = dataHandler.level+1;
    [dataHandler saveData];
    
    CCScene *scene = [CCBReader loadAsScene:@"LevelLayer.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)initResource
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectStar];
}

-(void)handleShowScore
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    [self showIsWinLabel:dataHandler.isWin];
    
    self.starCount = self.getStarCount;
    dataHandler.starCount = self.starCount;
    [self starActionHandle:self.starCount];
}

-(NSInteger)getStarCount
{
    NSInteger result = 0;
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    double factor = dataHandler.timeLeft/dataHandler.timeLimit;
    if (factor>=0.8)
    {
        result = 3;
    }
    else if(factor>=0.5)
    {
        result = 2;
    }
    else if (factor>=0.2)
    {
        result = 1;
    }
    return result;
}

-(void)starActionHandle:(NSInteger)starCount
{
    CCNode *obj = nil;
    for (obj in m_arraySprite)
    {
        obj.visible = NO;
    }
    
    if (starCount>0)
    {
        CCActionCallFunc* callFuncStep2 = [CCActionCallFunc actionWithTarget:self selector:@selector(starTwoAction)];
        NSArray *actionArray = @[[self getStarAction],callFuncStep2];
        CCAction *actionStar = [CCActionSequence actionWithArray:actionArray];
        obj = [m_arraySprite objectAtIndex:0];
        if (obj)
        {
            obj.visible = YES;
            [obj runAction:actionStar];
        }

    }
}

-(void)starTwoAction
{
    CCNode *obj = nil;
    
    NSArray *actionArray = nil;
    CCAction *actionStar = nil;
    
    if (self.starCount>1)
    {
        if (3==self.starCount)
        {
            CCActionCallFunc* callFuncStep2 = [CCActionCallFunc actionWithTarget:self selector:@selector(starThreeAction)];
            actionArray = @[[self getStarAction],callFuncStep2];
            
        }
        else if (2==self.starCount)
        {
            actionArray = @[[self getStarAction]];
        }
        
        actionStar = [CCActionSequence actionWithArray:actionArray];
        obj = [m_arraySprite objectAtIndex:1];
        if (obj)
        {
            obj.visible = YES;
            [obj runAction:actionStar];
        }

    }
}

-(void)starThreeAction
{
    CCNode *obj = nil;
    
    if (3==self.starCount)
    {
        NSArray *actionArray = @[[self getStarAction]];
        CCAction *actionStar = [CCActionSequence actionWithArray:actionArray];
        obj = [m_arraySprite objectAtIndex:2];
        if (obj)
        {
            obj.visible = YES;
            [obj runAction:actionStar];
        }
    }

}

-(CCAction*)getStarAction
{
    CCAction *action = nil;
    
    CCActionCallFunc* callFunc = [CCActionCallFunc actionWithTarget:self selector:@selector(playStarSound)];
    NSArray *actionArray = @[[CCActionScaleTo actionWithDuration:0.5 scale:1],callFunc];
    action = [CCActionSequence actionWithArray:actionArray];
    return action;
}

-(void)showIsWinLabel:(BOOL)value
{
    NSString *temString = @"";
    if (value==YES)
    {
        temString = @"YOU WIN!";
    }
    else
    {
        temString =@"YOu LOSE!";
    }
    [m_labelResult setString:temString];
    
}

-(void)playStarSound
{
    [[OALSimpleAudio sharedInstance] playEffect:kEffectStar];
    
}


@end
