//
//  PlayScene.m
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import "PlayScene.h"
#import "../obj/BlockObj.h"
#import "../admob/GADAdSize.h"
#import "../Def/SoundDef.h"
#include "../libs/cocos2d-iphone/external/ObjectAL/OALSimpleAudio.h"
#import "../AppDelegate.h"
#import "../DataHandler/GameDataHandler.h"
#import "../../../../../tools/RandomArray.h"


#define kRowOfItemCount (9)
#define kCollumOfItemCount (5)
#define kZorderScore (10)

@interface PlayScene ()
@property NSInteger _updateStasticCount;
@end

@implementation PlayScene

@synthesize currentBlockType = m_currentBlockType;

- (void) didLoadFromCCB
{
    m_blockArray = [NSMutableArray array];
    [self placeAllBlock];
    [self setUserInteractionEnabled:YES];
    [self initSoundEgine];
    m_scorePanel.zOrder = kZorderScore;
    self.currentBlockType = [GameDataHandler sharedGameDataHandler].blockTypeSelect;
    [m_targetItem setType:self.currentBlockType];
}


-(void)placeAllBlock
{
    for (NSInteger row = 0; row<kRowOfItemCount; row++)
    {
        NSArray *typeArray = getRandomArray(kCollumOfItemCount);//[self getRandomArray:kCollumOfItemCount];
        for (NSInteger collum = 0; collum<kCollumOfItemCount; collum++)
        {
            BlockObj *obj = (BlockObj*)[CCBReader load:@"BlockObj.ccbi"];
            NSString *typeString = [typeArray objectAtIndex:collum];

            [obj setType:(eBlockType)typeString.integerValue];
            obj.colIndex = collum;
            obj.rowIndex = row;
            obj.position = ccp(obj.contentSize.width*collum,obj.contentSize.height*row);
            [self addChild:obj];
            [m_blockArray addObject:obj];
        }
    }
}

-(void)moveBlocks
{
    NSArray *typeArray = nil;
    for (BlockObj *obj in m_blockArray)
    {
        if (obj.rowIndex<(kRowOfItemCount-1))
        {
            BlockObj *objNextRow = [m_blockArray objectAtIndex:((obj.rowIndex+1)*kCollumOfItemCount+obj.colIndex)];
            [obj setType:objNextRow.blockType];

        }
        else if((kRowOfItemCount-1) == obj.rowIndex)
        {
            typeArray = getRandomArray(kCollumOfItemCount);//[self getRandomArray:kCollumOfItemCount];
            for (NSInteger index = 0; index<typeArray.count; index++)
            {
                BlockObj *objLastCollum = [m_blockArray objectAtIndex:(obj.rowIndex*kCollumOfItemCount+index)];
                NSString *typeString = [typeArray objectAtIndex:index];
                [objLastCollum setType:(eBlockType)typeString.integerValue];
            }
            break;
        }
    }
}


-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint currentPosition = [touch locationInView:touch.view];
    currentPosition = [[CCDirector sharedDirector] convertToGL:currentPosition];
    currentPosition = [self convertToNodeSpace:currentPosition];
    
    if (m_blockArray)
    {
        for (CCNode *node in m_blockArray)
        {
            BlockObj *obj = (BlockObj*)node;
            if ([node hitTestWithWorldPos:currentPosition])
            {
                if (self.currentBlockType == obj.blockType)
                {
                    [[OALSimpleAudio sharedInstance] playEffect:kEffectTouched];
                    [m_lableRightTapCount setString:[NSString stringWithFormat:@"%d",m_lableRightTapCount.string.integerValue+1]];

                }
                else
                {
                    CCScene *scene = [CCBReader loadAsScene:@"StartPlayScene"];
                    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];
                    CCLOG(@"GameOver");
                }
                 NSString *string = [NSString stringWithFormat:@"row = %d,collum = %d",obj.rowIndex,obj.colIndex];
                
                CCLOG(string);
                [self moveBlocks];
            }
        }
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
//    [notiCenter postNotificationName:kShowAdMessage object:nil];
}

- (void)update:(CCTime)delta
{
    self._updateStasticCount++;
    if (self._updateStasticCount>30)
    {
        //[self moveBlocks];
        self._updateStasticCount = 0;
    }
}

-(void)initSoundEgine
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectTouched];
}


@end