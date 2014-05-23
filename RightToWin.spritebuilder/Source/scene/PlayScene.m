//
//  PlayScene.m
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import "PlayScene.h"
#import "../obj/BlockObj.h"
#import "../admob/GADAdSize.h"
#include "../libs/cocos2d-iphone/external/ObjectAL/OALSimpleAudio.h"
#import "../AppDelegate.h"
#import "../DataHandler/GameDataHandler.h"
#import "../../../../../tools/RandomArray.h"
#import "../../../../../tools/CreateArrayFromList.h"
#import "../Def/uiPostionDef.h"


#define kRowOfItemCount (6)
#define kCollumOfItemCount ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?(6):(5))

#define kZorderScore (10)
#define kLevelParameter (20)
#define kMoveOffset (0.1)

//#define kMaxLevel (10)
#define kLevelMoveparameter (40)
#define kLevelMoveparameterCrazy (60)
#define kStarMoveParameter (50)//((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?(50):(90))

#define kTapMoveParameter (10)

#define kAddMoveThreshold (5)

@interface PlayScene ()
@property NSInteger _updateStasticCount;
@property NSInteger _beepStasticCount;
@property NSInteger _tapCountStatistic;
@property eGameMode _gameMode;
@property GameDataHandler *_dataHandler;
@property BOOL _isStartGame;
@property NSArray* _musicArray;
@property NSInteger _soundStasticCount;
@property NSInteger _moveStastic;
@property NSInteger _moveAddStastic;
@property NSInteger _tapMoveCount;

@property BOOL _isTapMoveEnable;

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
    [self setMultipleTouchEnabled:NO];
    [self initSoundEgine];
    
    m_scorePanel.zOrder = kZorderScore;
    m_lableLevelUp.zOrder = kZorderScore;
    
    self.currentBlockType = self._dataHandler.blockTypeSelect;
    [m_targetItem setType:self.currentBlockType];
    
    self._isStartGame = YES;
    
    self._musicArray = [self readMusicPlist];
    self._soundStasticCount = 0;
    
    self._moveStastic = 0;
    self._tapMoveCount = 0;
    self._isTapMoveEnable = NO;
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
            if (self._gameMode!=eGameModeTime)
            {
                obj.position = ccp((obj.contentSize.width/2)+obj.contentSize.width*collum,obj.contentSize.height*2.5+(obj.contentSize.height/2)+obj.contentSize.height*row);
            }
            else
            {
                obj.position = ccp((obj.contentSize.width/2)+obj.contentSize.width*collum,(obj.contentSize.height/2)+obj.contentSize.height*row);
//                if(0==row)
//                {
//                    [obj setBlockDisable];
//                }
            }
            
            
            [self addChild:obj];
            [m_blockArray addObject:obj];
        }
    }
}

-(void)moveBlocks
{
    NSArray *typeArray = nil;
    NSString *typeString = nil;
    if (eGameModeTime != self._gameMode)
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
                for (NSInteger collumIndex = 0; collumIndex<kCollumOfItemCount; collumIndex++)
                {
                    currentObj = [m_blockArray objectAtIndex:rowIndex*kCollumOfItemCount+collumIndex];
                    if (self.currentBlockType == currentObj.blockType)
                    {
                        [[OALSimpleAudio sharedInstance] playEffect:kEffectError];
                        [self showFinishLayer];
                    }
                }
                
                typeArray = getRandomArray(kCollumOfItemCount);
                for (NSInteger collumIndex = 0; collumIndex<kCollumOfItemCount; collumIndex++)
                {
                    currentObj = [m_blockArray objectAtIndex:rowIndex*kCollumOfItemCount+collumIndex];
                    typeString = [typeArray objectAtIndex:collumIndex];
                    [currentObj setType:(eBlockType)typeString.integerValue];
                    
                    
                    BlockObj *topObj = [m_blockArray objectAtIndex:(kRowOfItemCount-1)*kCollumOfItemCount + collumIndex];
                    currentObj.position = ccp(topObj.position.x, currentObj.position.y+kRowOfItemCount*topObj.contentSize.height);
                }
            }
        }
    }
}

-(void)moveBlocksAfterTap
{
    NSArray *typeArray = nil;
    NSString *typeString = nil;
    if (eGameModeTime == self._gameMode)
    {
        for (NSInteger rowIndex = 0; rowIndex<kRowOfItemCount; rowIndex++)
        {
            BlockObj *currentObj = nil;
            for (NSInteger collumIndex = 0; collumIndex<kCollumOfItemCount; collumIndex++)
            {
                currentObj = [m_blockArray objectAtIndex:rowIndex*kCollumOfItemCount+collumIndex];
                currentObj.position = ccp(currentObj.position.x, currentObj.position.y-kTapMoveParameter);
            }
            
            BOOL isOutScene = ( (currentObj.position.y+(currentObj.contentSize.height/2))<0 )?YES:NO;
            if (isOutScene)
            {
                self._tapMoveCount--;
                if (self._tapMoveCount<=0)
                {
                    self._isTapMoveEnable = NO;//stop move

                }
                
                typeArray = getRandomArray(kCollumOfItemCount);
                for (NSInteger collumIndex = 0; collumIndex<kCollumOfItemCount; collumIndex++)
                {
                    currentObj = [m_blockArray objectAtIndex:rowIndex*kCollumOfItemCount+collumIndex];
                    typeString = [typeArray objectAtIndex:collumIndex];
                    [currentObj setType:(eBlockType)typeString.integerValue];
                    
                    
                    BlockObj *topObj = [m_blockArray objectAtIndex:(kRowOfItemCount-1)*kCollumOfItemCount + collumIndex];
                    currentObj.position = ccp(topObj.position.x, currentObj.position.y+kRowOfItemCount*topObj.contentSize.height);
                }
            }
        }
    }

//    NSArray *typeArray = nil;
//    NSString *typeString = nil;
//    if (eGameModeTime == self._gameMode)
//    {
//        for (BlockObj *obj in m_blockArray)
//        {
//            if (obj.rowIndex<(kRowOfItemCount-1))
//            {
//                BlockObj *objNextRow = [m_blockArray objectAtIndex:((obj.rowIndex+1)*kCollumOfItemCount+obj.colIndex)];
//                [obj setType:objNextRow.blockType];
//                
//            }
//            else if((kRowOfItemCount-1) == obj.rowIndex)
//            {
//                typeArray = getRandomArray(kCollumOfItemCount);//[self getRandomArray:kCollumOfItemCount];
//                for (NSInteger index = 0; index<typeArray.count; index++)
//                {
//                    BlockObj *objLastCollum = [m_blockArray objectAtIndex:(obj.rowIndex*kCollumOfItemCount+index)];
//                    typeString = [typeArray objectAtIndex:index];
//                    [objLastCollum setType:(eBlockType)typeString.integerValue];
//                }
//                break;
//            }
//        }
//    }

}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self._isStartGame==NO)
    {
        return;
    }
    
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
                if (eBlockTypeDisable != obj.blockType)
                {
                    if (self.currentBlockType == obj.blockType)
                    {
                        [obj setBlockDisable];
                        [self playMusicFromSound];
                        //[self playRandomSound];
                        [m_lableRightTapCount setString:[NSString stringWithFormat:@"%d",m_lableRightTapCount.string.intValue+1]];
                        self._tapCountStatistic++;//need to be reseted in the increaseLevel method
                        [self increaseLevel:self._tapCountStatistic];
                        
                        if(eGameModeTime!=self._gameMode)
                        {
                            if(eGameModeCount==self._gameMode)
                            {
                                self._moveAddStastic= self._moveAddStastic+4;
                            }
                            else if(eGameModeCrazy == self._gameMode)
                            {
                                self._moveAddStastic = self._moveAddStastic+2;
                            }

                            if(self._moveAddStastic>=kAddMoveThreshold)
                            {
                                self._moveStastic++;
                                self._moveAddStastic = 0;
                            }
                        }
                        
                        if (eGameModeTime==self._gameMode)
                        {
                            self._tapMoveCount++;//add tap move Count

                        }
                        
                        break;
                    }
                    else
                    {
                        self._isStartGame = NO;
                        [[OALSimpleAudio sharedInstance] playEffect:kEffectError];
                        CCActionCallFunc* callFunc = [CCActionCallFunc actionWithTarget:self selector:@selector(showFinishLayer)];
                        
                        obj.zOrder = kZorderScore + 1;//place error obj to toppest
                        NSArray *actionArray = @[[CCActionScaleTo actionWithDuration:0.5 scale:1.3],
                                                 [CCActionScaleTo actionWithDuration:0.5 scale:1],
                                                 [CCActionScaleTo actionWithDuration:0.5 scale:1.3],
                                                 [CCActionScaleTo actionWithDuration:0.5 scale:1],callFunc];
                        CCActionSequence *actions = [CCActionSequence actionWithArray:actionArray];
                        [obj runAction:actions];
                        
                        CCLOG(@"GameOver");
                        break;
                    }
                }
                //                NSString *string = [NSString stringWithFormat:@"row = %ld,collum = %ld",(long)obj.rowIndex,(long)obj.colIndex];
                //                CCLOG(string);
            }
        }
    }


}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self._isStartGame==NO)
    {
        return;
    }
    
    if (self._gameMode == eGameModeTime)
    {
        self._isTapMoveEnable = YES;//enable tile move for a row after one tap
    }
}

- (void)update:(CCTime)delta
{
    [self handleModeUiDisplay];
    self._updateStasticCount++;
    self._beepStasticCount++;
    
    NSInteger moveCount = 0;
    
    if (self._gameMode != eGameModeTime)
    {
        if (self._isStartGame)
        {
            if (self._gameMode == eGameModeCount)
            {
                moveCount = self._moveStastic+kStarMoveParameter;//self._dataHandler.level*kLevelMoveparameter+kStarMoveParameter;

            } else
            {
                moveCount = self._moveStastic*4+kStarMoveParameter;//self._dataHandler.level*kLevelMoveparameterCrazy+kStarMoveParameter;
            }
            
            for (NSInteger count = 0; count<moveCount; count++)
            {
                [self moveBlocks];
            }

        }
    }
    else//time mode
    {
        if (self._isTapMoveEnable == YES)
        {
            [self moveBlocksAfterTap];
        }
    }
    
    if (self._gameMode!=eGameModeCount)
    {
        if (self._beepStasticCount>60)
        {
            if (self._dataHandler.timeLeft<5)
            {
                [[OALSimpleAudio sharedInstance] playEffect:kEffectBeep];
            }
            self._beepStasticCount = 0;
        }
        
        if (0==self._dataHandler.timeLeft)
        {
            [self showFinishLayer];
        }
    }
    
//    if (self._updateStasticCount>20)
//    {
//        //[self playRandomSound];
//        [self playMusicFromSound];
//        self._updateStasticCount=0;
//    }
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
    
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectBeep];

}

-(void)increaseLevel:(NSInteger)tapCount
{
    int currentLevel = m_labelLevel.string.intValue;
    BOOL isUpLevel = ( tapCount>(currentLevel+1)*kLevelParameter )?YES:NO;
    if (isUpLevel)
    {
        // the animation manager of each node is stored in the 'userObject' property
        CCBAnimationManager* animationManager = self.userObject;
        animationManager.delegate = self;
        // timelines can be referenced and run by name
        [animationManager runAnimationsForSequenceNamed:@"levelUp"];
        [[OALSimpleAudio sharedInstance] playEffect:kEffectLevelUp];
        
        //reset tap statistic
        self._tapCountStatistic = 0;
        
        if ((self._gameMode == eGameModeCrazy)||(self._gameMode == eGameModeTime))
        {
            [self._dataHandler resetTime];
        }

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
        
        int currentLevel = m_labelLevel.string.intValue +1;
        [m_labelLevel setString:[NSString stringWithFormat:@"%d",currentLevel]];
        self._dataHandler.level = currentLevel;
    }
    
}

-(void)playRandomSound
{
    NSInteger randomNumber = (arc4random()%eRandomSoundMax);
    [self playPianoFrom:(enum eRandomSound)randomNumber];
}

-(void)playPianoFrom:(enum eRandomSound)key
{
    switch (key)
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

-(void)playMusicFromSound
{
    NSString *pianoKeyString = nil;
    if (self._soundStasticCount<self._musicArray.count)
    {
        pianoKeyString = [self._musicArray objectAtIndex:self._soundStasticCount];
        [self playPianoFrom:(enum eRandomSound)pianoKeyString.integerValue-1];
        self._soundStasticCount++;
    }
    else if(self._soundStasticCount>=self._musicArray.count)
    {
        self._soundStasticCount = 0;
        self._musicArray = [self readMusicPlist];
    }
}

-(void)showFinishLayer
{
    [GameDataHandler sharedGameDataHandler].tapCount = m_lableRightTapCount.string.integerValue;
    
    if(self._dataHandler.errorCount>=3)
    {
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter postNotificationName:kShowAdMessage object:nil];
        self._dataHandler.errorCount = 0;
    }
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
            [m_labelTime setString:self._dataHandler.getLeftTimeString];
            break;
        default:
            break;
    }
}

-(NSArray*)readMusicPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"musicList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSInteger soundIndex = arc4random()%(data.count)+1;
    
    NSString *musicString = [data objectForKey:[NSString stringWithFormat:@"music%ld",(long)soundIndex]];
    NSArray *musicArray = readListMakeArray(musicString, @",");
    
    return musicArray;
}

@end
