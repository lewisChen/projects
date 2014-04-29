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
#import "../Def/uiPostionDef.h"


#define kRowOfItemCount (10)
#define kCollumOfItemCount ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?(6):(5))

#define kZorderScore (10)
#define kLevelParameter (50)
#define kMoveOffset (5)

@interface PlayScene ()
@property NSInteger _updateStasticCount;
@property NSInteger _tapCountStatistic;
@property eGameMode _gameMode;
@property GameDataHandler *_dataHandler;
@end

@implementation PlayScene

@synthesize currentBlockType = m_currentBlockType;

- (void) didLoadFromCCB
{
    self._dataHandler = [GameDataHandler sharedGameDataHandler];
    [self._dataHandler initResource];
    self._gameMode = self._dataHandler.gameMode;
    
    m_blockArray = [NSMutableArray array];
    self._tapCountStatistic = 0;
    self._updateStasticCount = 0;
    
    [self placeAllBlock];
    [self setUserInteractionEnabled:YES];
    [self initSoundEgine];
    
    m_scorePanel.zOrder = kZorderScore;
    m_spriteArrow.zOrder = kZorderScore;
    
    self.currentBlockType = self._dataHandler.blockTypeSelect;
    [m_targetItem setType:self.currentBlockType];
}


-(void)placeAllBlock
{
    for (NSInteger row = 0; row<kRowOfItemCount; row++)
    {
        NSArray *typeArray = getRandomArray(kCollumOfItemCount);
        for (NSInteger collum = 0; collum<kCollumOfItemCount; collum++)
        {
            BlockObj *obj = (BlockObj*)[CCBReader load:@"BlockObj.ccbi"];
            NSString *typeString = [typeArray objectAtIndex:collum];

            [obj setType:(eBlockType)typeString.integerValue];
            obj.colIndex = collum;
            obj.rowIndex = row;
            obj.position = ccp((obj.contentSize.width/2)+obj.contentSize.width*collum,(obj.contentSize.height/2)+obj.contentSize.height*row);
            [self addChild:obj];
            [m_blockArray addObject:obj];
        }
    }
}

-(void)moveBlocks
{
    NSArray *typeArray = nil;
    NSString *typeString = nil;
    if (eGameModeTime == self._gameMode)
    {
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
                    typeString = [typeArray objectAtIndex:index];
                    [objLastCollum setType:(eBlockType)typeString.integerValue];
                }
                break;
            }
        }
    }
    else//other mode move block method
    {
        for (NSInteger rowIndex = 0; rowIndex<kRowOfItemCount; rowIndex++)
        {
            BlockObj *currentObj = nil;
            for (NSInteger collumIndex = 0; collumIndex<kCollumOfItemCount; collumIndex++)
            {
                currentObj = [m_blockArray objectAtIndex:rowIndex*kCollumOfItemCount+collumIndex];
                currentObj.position = ccp(currentObj.position.x, currentObj.position.y-kMoveOffset);
            }
            
            BOOL isOutScene = ( (currentObj.position.y+(currentObj.contentSize.height/2))<0 )?YES:NO;
            if (isOutScene)
            {
                typeArray = getRandomArray(kCollumOfItemCount);
                for (NSInteger collumIndex = 0; collumIndex<kCollumOfItemCount; collumIndex++)
                {
                    currentObj = [m_blockArray objectAtIndex:rowIndex*kCollumOfItemCount+collumIndex];
                    typeString = [typeArray objectAtIndex:collumIndex];
                    [currentObj setType:(eBlockType)typeString.integerValue];
                    
                    
                    BlockObj *topObj = [m_blockArray objectAtIndex:(kRowOfItemCount-1)*kCollumOfItemCount + collumIndex];
                    currentObj.position = ccp(topObj.position.x, topObj.position.y+topObj.contentSize.height- kMoveOffset + topObj.contentSize.height*rowIndex);
                }
            }
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
                    [self playRandomSound];
                    [obj setBlockDisable];
                    [m_lableRightTapCount setString:[NSString stringWithFormat:@"%d",m_lableRightTapCount.string.intValue+1]];
                    self._tapCountStatistic++;//need to be reseted in the increaseLevel method
                    [self increaseLevel:self._tapCountStatistic];
                    [self moveBlocks];
                }
                else
                {
                    [[OALSimpleAudio sharedInstance] playEffect:kEffectError];
                    CCActionCallFunc* callFunc = [CCActionCallFunc actionWithTarget:self selector:@selector(showFinishLayer)];

                    NSArray *actionArray = @[[CCActionScaleTo actionWithDuration:0.5 scale:1.1],
                                             [CCActionScaleTo actionWithDuration:0.5 scale:1],
                                             [CCActionScaleTo actionWithDuration:0.5 scale:1.1],
                                             [CCActionScaleTo actionWithDuration:0.5 scale:1],callFunc];
                    CCActionSequence *actions = [CCActionSequence actionWithArray:actionArray];
                    [obj runAction:actions];
                    
                    [GameDataHandler sharedGameDataHandler].tapCount = m_lableRightTapCount.string.integerValue;
                    CCLOG(@"GameOver");
                    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
                    [notiCenter postNotificationName:kShowAdMessage object:nil];

                }
                 NSString *string = [NSString stringWithFormat:@"row = %ld,collum = %ld",(long)obj.rowIndex,(long)obj.colIndex];
                CCLOG(string);
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
    [self handleModeUiDisplay];
    self._updateStasticCount++;
    
    if (eGameModeCount == self._gameMode)
    {
        
        [self moveBlocks];
//        if (self._updateStasticCount>1)
//        {
//            [self moveBlocks];
//            self._updateStasticCount = 0;
//        }
    }
}

-(void)initSoundEgine
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectTouched];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectLevelUp];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectExplosion];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectError];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoDo];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoRe];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoMi];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoFa];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoSo];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoLa];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoQi];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectPianoDi];

}

-(void)increaseLevel:(NSInteger)tapCount
{
    int currentLevel = m_labelLevel.string.intValue;
    BOOL isUpLevel = ( tapCount>(currentLevel+1)*kLevelParameter )?YES:NO;
    if (isUpLevel)
    {
        currentLevel = currentLevel +1;
        [m_labelLevel setString:[NSString stringWithFormat:@"%d",currentLevel]];
        
        // the animation manager of each node is stored in the 'userObject' property
        CCBAnimationManager* animationManager = self.userObject;
        animationManager.delegate = self;
        // timelines can be referenced and run by name
        [animationManager runAnimationsForSequenceNamed:@"levelUp"];
        [[OALSimpleAudio sharedInstance] playEffect:kEffectLevelUp];
        
        //reset tap statistic
        self._tapCountStatistic = 0;

    }
}

- (void)completedAnimationSequenceNamed:(NSString*)name;
{
    if ([name isEqualToString:@"levelUp"])
    {
        // load particle effect
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"LevelUpObj"];
        [[OALSimpleAudio sharedInstance] playEffect:kEffectExplosion];
        // make the particle effect clean itself up, once it is completed
        explosion.autoRemoveOnFinish = TRUE;
        CGSize viewSize = [CCDirector sharedDirector].viewSize;
        explosion.position = ccp(viewSize.width/2,viewSize.height/2);
        [self addChild:explosion];

    }
    
}

-(void)playRandomSound
{
    NSInteger randomNumber = (arc4random()%eRandomSoundMax);
    switch (randomNumber)
    {
        case eRandomSound1:
            [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoDo];
            break;
        case eRandomSound2:
            [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoRe];
            break;
        case eRandomSound3:
            [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoMi];
            break;
        case eRandomSound4:
            [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoFa];
            break;
        case eRandomSound5:
            [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoSo];
            break;
        case eRandomSound6:
            [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoLa];
            break;
        case eRandomSound7:
            [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoQi];
            break;
        case eRandomSound8:
            [[OALSimpleAudio sharedInstance] playEffect:kEffectPianoDi];
            break;

        default:
            break;
    }
}

-(void)showFinishLayer
{
    CCScene *scene = [CCBReader loadAsScene:@"FinishScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];
}

- (void)handleModeUiDisplay
{
    switch (self._gameMode)
    {
        case eGameModeTime:
            [m_labelTime setString:self._dataHandler.getLeftTimeString];
            break;
        case eGameModeCount:
            [m_labelTime setString:self._dataHandler.getUseTimeString];
            break;
        case eGameModeCrazy:
            [m_labelTime setString:self._dataHandler.getUseTimeString];
            break;
        default:
            break;
    }
}

@end
