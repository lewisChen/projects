//
//  LevelLayer.m
//  NumberPuzzleBeta2
//
//  Created by mybox_1027@sina.com on 13-12-3.
//  Copyright 2013年 mybox_1027@sina.com. All rights reserved.
//

#import "LevelLayer.h"
#import "../Objects/numberItem.h"
#include "CCBReader.h"
#include "../UiConstDef/FontRelateDef.h"
#include "NumberArithmetic.h"
#import "GameDataHandler.h"
#include "../libs/cocos2d-iphone/external/ObjectAL/OALSimpleAudio.h"
#import "../SoundDef/SoundDef.h"
#include "../UiConstDef/uiPostionDef.h"


#define kTagNameSpark (@"spark")
#define kMaxCountSectionItem (9)
#define MAX_ITEM_COUNT_X (9)
#define MAX_ITEM_COUNT_Y (9)
#define FIRST_BLOCK_INDEX (3)//first block edge
#define SECOND_BLOCK_INDEX (6)//second blog edge
#define kBtnPositionOffset (5)
#define kZOrderTop (100)


@interface LevelLayer ()
@property BOOL isTimerStart;
@end

@implementation LevelLayer

@synthesize currentSelectIndexString;
@synthesize errorTips = m_errorTips;

- (void) didLoadFromCCB
{
    GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
    [dataHandler initResource];
    
    CCNode *node = NULL;
    m_btnArray = [NSMutableArray arrayWithObjects:m_btn1,m_btn2,m_btn3,m_btn4,m_btn5,m_btn6,m_btn7,m_btn8,m_btn9, nil];
    for (node in m_btnArray)
    {
        node.zOrder = 2;
    }
    self.currentSelectIndexString = @"-1";
    [m_labelTime setString:dataHandler.getUseTimeString];
    [self initLayer];
    [self setGameLevel:dataHandler.difficultLevel];//create level;
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    //[self setEnabled:YES];//enable touch event
    [self initSoundEgine];
    [self setIsTimerStart:YES];
    [m_lableLevel setString:[NSString stringWithFormat:@"%d",dataHandler.level]];
    //[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    
    CCNode *sparkNode = [CCBReader load:@"spark.ccbi"];
    [self addChild:sparkNode z:0 name:kTagNameSpark];
    sparkNode.visible = NO;
    
    [self positionArragement];
}

- (void)initLayer
{
    if (self)
    {
        float xOffset = 0.0;
        float yOffset = 0.0;
        NSMutableArray *array = [NumberArithmetic sharedNumberArithmetic].createNumberPuzzleArray;
        NSString *indexString = @"";
        self.contentSize = [CCDirector sharedDirector].viewSize;
        for (unsigned char indexX = 0; indexX<MAX_ITEM_COUNT_X; indexX++)
        {
            for (unsigned char indexY = 0; indexY<MAX_ITEM_COUNT_Y; indexY++)
            {
                NumberItem *numberItem = [NumberItem node];
                numberItem.anchorPoint = ccp(0.5, 0.5);
                
                NSInteger type = [(NSString*)[array objectAtIndex:(indexX*MAX_ITEM_COUNT_X+indexY)] integerValue];
                [numberItem setItemType:type];
                
                //determind x offset
                if (indexX<FIRST_BLOCK_INDEX)
                {
                    xOffset = numberItem.contentSize.width*indexX;
                }
                else if (FIRST_BLOCK_INDEX<=indexX && indexX<SECOND_BLOCK_INDEX)
                {
                    xOffset = numberItem.contentSize.width*indexX+3;
                }
                else if (indexX>=SECOND_BLOCK_INDEX)
                {
                    xOffset = numberItem.contentSize.width*indexX+6;
                }
                
                //determind y offset
                if (indexY<FIRST_BLOCK_INDEX)
                {
                    yOffset = -numberItem.contentSize.height*indexY;
                }
                else if (FIRST_BLOCK_INDEX<=indexY && indexY<SECOND_BLOCK_INDEX)
                {
                    yOffset = -numberItem.contentSize.height*indexY-3;
                    
                }
                else if (indexY>=SECOND_BLOCK_INDEX)
                {
                    yOffset = -numberItem.contentSize.height*indexY-6;
                }
                
                
                indexString = [NSString stringWithFormat:@"%d",indexX*MAX_ITEM_COUNT_X+indexY];
                CGPoint pos = ccp(numberItem.contentSize.width*0.9,self.contentSize.height*2.97/4);
                pos = getUiPosition(pos);//convert pos to differenet device
                pos.x = pos.x +xOffset;
                pos.y = pos.y +yOffset;
                
                numberItem.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
                [self addChild:numberItem z:0 name:indexString];
                numberItem.indexX = indexX;
                numberItem.indexY = indexY;
                numberItem.currentIndexString = indexString;
                CCAction *moveAction = [CCActionMoveTo actionWithDuration:0.3 position:pos];
                [numberItem runAction:moveAction];
                
            }
        }
        
        self.errorTips = [CCLabelTTF labelWithString:@"Miss" fontName:kFontNameNormal fontSize:kFontSizeNormal];
        self.errorTips.fontColor = [CCColor colorWithCcColor3b:ccRED];
        self.errorTips.zOrder = kZOrderTop;
        self.errorTips.position = ccp([CCDirector sharedDirector].viewSize.width/2, [CCDirector sharedDirector].viewSize.height/2);
        self.errorTips.visible = NO;
        [self addChild:self.errorTips];
    }
    //return self;
}

-(void)setGameLevel:(NSUInteger)level
{
    BOOL isShow = NO;
    NSInteger randomNumber = 0;
    srandom((unsigned)time(NULL));
    NSArray *childrenArray = [self children];

    CCNode *node = NULL;
    NumberItem *numberItem = NULL;
    for (node in childrenArray)
    {
        randomNumber = random()%4;
        isShow = randomNumber>level?YES:NO;
        if ([node isKindOfClass:[NumberItem class]])
        {
            numberItem = (NumberItem*)node;
            [numberItem setNumberLabelVisable:isShow];
        }
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint currentPosition = [touch locationInView:touch.view];
    currentPosition = [[CCDirector sharedDirector] convertToGL:currentPosition];
    currentPosition = [self convertToNodeSpace:currentPosition];
    
    NSArray *childrenArray = [self children];
    CCNode *node = NULL;
    NumberItem *numberItem = NULL;
   // NSString *currentTouchNumberString = @"";
    enum EItemType currentTouchItemTpye = eItemType0;
    BOOL isHightLightSameNumber = NO;
    
    for (node in childrenArray)
    {
        if ([node isKindOfClass:[NumberItem class]])
        {
            numberItem = (NumberItem*)node;
            //if (ccpDistanceSQ(currentPosition, numberItem.position)<(kItemwidth*kItemHight/4))
            if([numberItem hitTestWithWorldPos:currentPosition])
            {
                [[OALSimpleAudio sharedInstance] playEffect:kEffectTouched];
                isHightLightSameNumber = numberItem.numberLabelVisable?YES:NO;
                if (!isHightLightSameNumber)
                {
                    self.currentSelectIndexString = numberItem.currentIndexString;
                    break;
                }
                currentTouchItemTpye = [numberItem getItemType];
                //currentTouchNumberString = [numberItem numberLabel].string;
                break;
            }
        }

    }
    
    if (isHightLightSameNumber)
    {
        //CCAction *rotateAction = nil;
        for (node in childrenArray)
        {
            //rotateAction = [CCActionRotateBy actionWithDuration:0.5 angle:360];
            if ([node isKindOfClass:[NumberItem class]])
            {
                numberItem = (NumberItem*)node;
                if ((currentTouchItemTpye == [numberItem getItemType])
                    &&(numberItem.numberLabelVisable))
                {
                    //[numberItem runAction:rotateAction];
                    //[numberItem setItemColor:ccGRAY];
                    [numberItem setItemSelect:YES];
                }
                
                else
                {
                    //[numberItem setItemColor:myItemColor];
                    [numberItem setItemSelect:NO];
                }
            }
        }
    }
    else
    {
        for (node in childrenArray)
        {
            if ([node isKindOfClass:[NumberItem class]])
            {
                numberItem = (NumberItem*)node;
                //[numberItem setItemColor:myItemColor];
                [numberItem setItemSelect:NO];
                
            }
        }
        numberItem = (NumberItem*)[self getChildByName:self.currentSelectIndexString recursively:NO];
        //[numberItem setItemColor:ccGRAY];
        [numberItem setItemSelect:YES];

    }
}


-(void)buttonReturn:(id)sender
{
    [[OALSimpleAudio sharedInstance] playEffect:kEffectClickButton];
    CCScene *scene = [CCBReader loadAsScene:@"MainScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];

}

-(void)itemButtonClick:(id)sender
{
    CCButton *btn = (CCButton*)sender;
    NSString *btnTitle = btn.title;
    
    if (self.currentSelectIndexString.intValue>=0)
    {
        NumberItem *currentNumberItem = (NumberItem*)[self getChildByName:self.currentSelectIndexString recursively:NO];
        CGPoint toPosition = currentNumberItem.position;
        CGPoint currentPos = btn.position;
        
        if (currentNumberItem.getItemType == (enum EItemType)btnTitle.intValue)
        {
            CCActionCallFunc* callFunc = [CCActionCallFunc actionWithTarget:self selector:@selector(selectRightFunction)];

            NSArray *actionsArray = [NSArray arrayWithObjects:[CCActionMoveTo actionWithDuration:0.3 position:toPosition],
                                     [CCActionHide action],
                                     [CCActionMoveTo actionWithDuration:0.0 position:currentPos],
                                     [CCActionShow action],
                                     callFunc,nil];
            CCAction *action = [CCActionSequence actionWithArray:actionsArray];
            [btn runAction:action];
        }
        else
        {
            //error count increase
            [[OALSimpleAudio sharedInstance] playEffect:kEffectError];
            CGPoint tipsStartPos = ccp([CCDirector sharedDirector].viewSize.width/2, [CCDirector sharedDirector].viewSize.height/2);
            m_errorTips.position = tipsStartPos;
            NSArray *errorActionsArray = [NSArray arrayWithObjects:
                                          [CCActionShow action],
                                          [CCActionScaleTo actionWithDuration:0.2 scale:5],
                                          [CCActionScaleTo actionWithDuration:0.05 scale:1],
                                          //[CCActionMoveTo actionWithDuration:0.5 position:ccp(tipsStartPos.x, tipsStartPos.y+40)],
                                          //[CCActionMoveTo actionWithDuration:0.0 position:tipsStartPos],
                                          [CCActionHide action],nil];
            CCAction *errorAction = [CCActionSequence actionWithArray:errorActionsArray];
            [m_errorTips runAction: errorAction];
            [GameDataHandler sharedGameDataHandler].errorCount = [GameDataHandler sharedGameDataHandler].errorCount+1;
            [m_lableError setString:[NSString stringWithFormat:@"%d",[GameDataHandler sharedGameDataHandler].errorCount]];
            
        }
    }
}



-(void)selectRightFunction
{
    NumberItem *currentNumberItem = (NumberItem*)[self getChildByName:self.currentSelectIndexString recursively:NO];
    [currentNumberItem setNumberLabelVisable:YES];
    //[currentNumberItem setItemColor:myItemColor];
    [currentNumberItem setItemSelect:NO];
    
    CCActionCallFunc* callFunc = [CCActionCallFunc actionWithTarget:self selector:@selector(matchRightFunctionCall)];
    NSArray *actionArray = @[[CCActionScaleTo actionWithDuration:0.1 scale:1.2],[CCActionScaleTo actionWithDuration:0.3 scale:1],callFunc];
    CCAction *actionMatch = [CCActionSequence actionWithArray:actionArray];
    [currentNumberItem runAction:actionMatch];
    
}

-(void)matchRightFunctionCall
{
    [[OALSimpleAudio sharedInstance] playEffect:kEffectMatch];
    
    NumberItem *currentNumberItem = (NumberItem*)[self getChildByName:self.currentSelectIndexString recursively:NO];
    CGPoint toPosition = currentNumberItem.position;
    CCParticleSystemBase *sparkNode = (CCParticleSystemBase*)[self getChildByName:kTagNameSpark recursively:NO];
    if (sparkNode)
    {
        [sparkNode resetSystem];
        sparkNode.visible = YES;
        sparkNode.position = toPosition;
    }
    //CCNode *sparkNode = [CCBReader load:@"spark.ccbi"];
    //sparkNode.position = toPosition;
    //[self addChild:sparkNode z:0 name:kTagNameSpark];
    
    //hide button if kinds of item reach 9
    [self buttonVisblaHandle:currentNumberItem.getItemType];
    //run effect if one section finish
    [self isSectionFinish:currentNumberItem.indexX :currentNumberItem.indexY];
    //reset current select
    self.currentSelectIndexString = @"-1";
    
    //level finish effect
    [self levelFinishHandle];
    
    //[self removeChildByName:kTagNameSpark];

}

-(void)buttonVisblaHandle:(enum EItemType)itemTpye//(NSString *)itemString
{
    NSArray *childrenArray = [self children];
    CCNode *node = NULL;
    NumberItem *numberItem = NULL;
    NSUInteger finishCount = 0;
    
    for (node in childrenArray)
    {
        if ([node isKindOfClass:[NumberItem class]])
        {
            numberItem = (NumberItem*)node;
            if ((numberItem.numberLabelVisable)&&(numberItem.getItemType == itemTpye))//itemString.intValue))
            {
                finishCount++;
            }
        }
    }
    if (kMaxCountSectionItem==finishCount)
    {
        CCButton *btn = [m_btnArray objectAtIndex:((NSInteger)itemTpye)-1];//itemString.intValue-1];
        btn.visible = NO;
    }
    

}

//9 item is one section
-(BOOL)isSectionFinish:(NSUInteger)xIndex :(NSUInteger)yIndex
{
    BOOL result = NO;
    NSUInteger xStartIndex = 0;
    NSUInteger xEndIndex = 0;
    NSUInteger yStartIndex = 0;
    NSUInteger yEndIndex = 0;
    
    if (xIndex<FIRST_BLOCK_INDEX)
    {
        xStartIndex = 0;
        xEndIndex = FIRST_BLOCK_INDEX;
    }
    else if (FIRST_BLOCK_INDEX<=xIndex && xIndex<SECOND_BLOCK_INDEX)
    {
        xStartIndex = FIRST_BLOCK_INDEX;
        xEndIndex = SECOND_BLOCK_INDEX;
    }
    else if (xIndex>=SECOND_BLOCK_INDEX)
    {
        xStartIndex = SECOND_BLOCK_INDEX;
        xEndIndex = MAX_ITEM_COUNT_X;
    }
    

    if (yIndex<FIRST_BLOCK_INDEX)
    {
        yStartIndex = 0;
        yEndIndex = FIRST_BLOCK_INDEX;
    }
    else if (FIRST_BLOCK_INDEX<=yIndex && yIndex<SECOND_BLOCK_INDEX)
    {
        yStartIndex = FIRST_BLOCK_INDEX;
        yEndIndex = SECOND_BLOCK_INDEX;
        
    }
    else if (yIndex>=SECOND_BLOCK_INDEX)
    {
        yStartIndex = SECOND_BLOCK_INDEX;
        yEndIndex = MAX_ITEM_COUNT_Y;
    }
    
    NSUInteger visableCount = 0;
    for (NSUInteger x = xStartIndex; x<xEndIndex; x++)
    {
        for (NSUInteger y = yStartIndex; y<yEndIndex; y++)
        {
            NSString *indexString = [NSString stringWithFormat:@"%d",x*MAX_ITEM_COUNT_X+y];
            NumberItem *numberItem = (NumberItem*)[self getChildByName:indexString recursively:NO];
            if (numberItem.numberLabelVisable)
            {
                visableCount++;
            }
        }
    }
    
    CCAction *rotateAction = nil;
    if (kMaxCountSectionItem == visableCount)
    {
        for (NSUInteger x = xStartIndex; x<xEndIndex; x++)
        {
            for (NSUInteger y = yStartIndex; y<yEndIndex; y++)
            {
                NSString *indexString = [NSString stringWithFormat:@"%d",x*MAX_ITEM_COUNT_X+y];
                NumberItem *numberItem = (NumberItem*)[self getChildByName:indexString recursively:NO];
                rotateAction = [CCActionRotateBy actionWithDuration:0.5 angle:360];
                [numberItem runAction:rotateAction];
            }
        }

        result = YES;
    }
    
    return result;
}

-(void)levelFinishHandle
{
    NSArray *childrenArray = [self children];
    CCNode *node = NULL;
    NumberItem *numberItem = NULL;
    NSUInteger visableCount = 0;
    
    for (node in childrenArray)
    {
        if ([node isKindOfClass:[NumberItem class]])
        {
            numberItem = (NumberItem*)node;
            if (numberItem.numberLabelVisable)
            {
                visableCount++;
            }
        }
    }
    
    if (visableCount == MAX_ITEM_COUNT_X*MAX_ITEM_COUNT_Y)
    {
        CCAction *rotateAction = nil;
        for (node in childrenArray)
        {
            if ([node isKindOfClass:[NumberItem class]])
            {
                rotateAction = [CCActionRotateBy actionWithDuration:0.5 angle:360];
                numberItem = (NumberItem*)node;
                [numberItem runAction:rotateAction];
            }
        }
        //show finish layer
        [self setResultWin:YES];
        [self showFinishLayer];
        //CCLOG(@"You win");
        
    }
}

-(void)initSoundEgine
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectError];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectMatch];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectTouched];
    
}

-(void)showFinishLayer
{
    self.isTimerStart = NO;//stop timer
    CCNode *finishLayer = [CCBReader load:@"GameFinishLayer.ccbi" owner:self];//[CCBReader load:@"GameFinishLayer.ccbi"];
    finishLayer.position = ccp(0.0, self.contentSize.height);
    [self addChild:finishLayer z:2];
    CCAction *moveAction = [CCActionMoveTo actionWithDuration:0.5 position:ccp(0.0, 0.0)];
    [finishLayer runAction:moveAction];
}

-(void)setResultWin:(BOOL)result
{
    [GameDataHandler sharedGameDataHandler].isWin = result;
}

-(void)draw
{
    [super draw];
    if (self.isTimerStart)
    {
        GameDataHandler *dataHandler = [GameDataHandler sharedGameDataHandler];
        if (0==dataHandler.timeLeft)
        {
            [self setResultWin:NO];
            [self showFinishLayer];
        }
        [m_labelTime setString:dataHandler.getLeftTimeString];//getUseTimeString];
    }
}

-(void)positionArragement
{
    if (!IS_IPHONE_5)
    {
        m_backArrow.position = ccp(m_backArrow.position.x, m_backArrow.position.y-55);
        m_backButton.position = ccp(m_backButton.position.x,m_backButton.position.y-55);
        m_lableTimeTitle.position = ccp(m_lableTimeTitle.position.x,m_lableTimeTitle.position.y-55);
        m_labelTime.position = ccp(m_labelTime.position.x,m_labelTime.position.y-55);

    }
}

@end
