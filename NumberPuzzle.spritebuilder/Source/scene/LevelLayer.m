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

#define kMaxCountSectionItem (9)
#define MAX_ITEM_COUNT_X (9)
#define MAX_ITEM_COUNT_Y (9)
#define FIRST_BLOCK_INDEX (3)//first block edge
#define SECOND_BLOCK_INDEX (6)//second blog edge
#define kBtnPositionOffset (5)
#define kZOrderTop (100)

@implementation LevelLayer

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
    
    m_errorTips = [CCLabelTTF labelWithString:@"Miss" fontName:kFontNameNormal fontSize:kFontSizeNormal];
    m_errorTips.fontColor = [CCColor colorWithCcColor3b:ccRED];
    m_errorTips.zOrder = kZOrderTop;
    //m_errorTips.position = ccp([CCDirector sharedDirector].viewSize.width/2, [CCDirector sharedDirector].viewSize.height/2);
    [self addChild:m_errorTips];
    
    self.currentSelectIndexString = @"-1";
    
    [self initLayer];
    [self setGameLevel:dataHandler.level];//create level;
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    //[self setEnabled:YES];//enable touch event
    [self initSoundEgine];
    //[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
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
                [numberItem setNumberLabel:[CCLabelTTF labelWithString:(NSString*)[array objectAtIndex:(indexX*MAX_ITEM_COUNT_X+indexY)] fontName:kFontNameNormal fontSize:kFontSizeNormal]];
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
                numberItem.position = ccp(numberItem.contentSize.width+xOffset, (self.contentSize.height*3/4)+ yOffset);
                [self addChild:numberItem z:0 name:indexString];
                numberItem.indexX = indexX;
                numberItem.indexY = indexY;
                numberItem.currentIndexString = indexString;
                
            }
        }
    }
    //return self;
}

-(void)setGameLevel:(NSUInteger)level
{
    BOOL isShow = NO;
    NSInteger randomNumber = 0;
    srandom(time(NULL));
    NSArray *childrenArray = [self children];

    CCNode *node = NULL;
    NumberItem *numberItem = NULL;
    for (node in childrenArray)
    {
        randomNumber = random()%3;
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
    NSString *currentTouchNumberString = @"";
    BOOL isHightLightSameNumber = NO;
    
    for (node in childrenArray)
    {
        if ([node isKindOfClass:[NumberItem class]])
        {
            numberItem = (NumberItem*)node;
            if (ccpDistanceSQ(currentPosition, numberItem.position)<(kItemwidth*kItemHight/4))
            {
                isHightLightSameNumber = numberItem.numberLabelVisable?YES:NO;
                if (!isHightLightSameNumber)
                {
                    self.currentSelectIndexString = numberItem.currentIndexString;
                    break;
                }
                currentTouchNumberString = [numberItem numberLabel].string;
                break;
                //[numberItem setNumberLabel:[CCLabelTTF labelWithString:@"1" fontName:FontNameNormal fontSize:FontSizeNormal]];
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
                if ((currentTouchNumberString == numberItem.numberLabel.string)
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
        
        if (currentNumberItem.labelNumber == btnTitle.intValue)
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
                                          [CCActionMoveTo actionWithDuration:1.0 position:ccp(tipsStartPos.x, tipsStartPos.y+40)],
                                          [CCActionMoveTo actionWithDuration:0.0 position:tipsStartPos],
                                          [CCActionHide action],
                                          nil];
            CCAction *errorAction = [CCActionSequence actionWithArray:errorActionsArray];
            [m_errorTips runAction: errorAction];
            
        }
    }
}

-(void)selectRightFunction
{
    NumberItem *currentNumberItem = (NumberItem*)[self getChildByName:self.currentSelectIndexString recursively:NO];
    [currentNumberItem setNumberLabelVisable:YES];
    //[currentNumberItem setItemColor:myItemColor];
    [currentNumberItem setItemSelect:NO];
    
    //hide button if kinds of item reach 9
    [self buttonVisblaHandle:currentNumberItem.numberLabel.string];
    //run effect if one section finish
    [self isSectionFinish:currentNumberItem.indexX :currentNumberItem.indexY];
    //reset current select
    self.currentSelectIndexString = @"-1";
    //level finish effect
    [self levelFinishHandle];
}

-(void)buttonVisblaHandle:(NSString *)itemString
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
            if ((numberItem.numberLabelVisable)&&(numberItem.labelNumber == itemString.intValue))
            {
                finishCount++;
            }
        }
    }
    if (kMaxCountSectionItem==finishCount)
    {
        CCButton *btn = [m_btnArray objectAtIndex:itemString.intValue-1];
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
        CCNode *finishLayer = [CCBReader load:@"GameFinishLayer.ccbi"];
        finishLayer.position = ccp(0.0, self.contentSize.height);
        [self addChild:finishLayer z:2];
        CCAction *moveAction = [CCActionMoveTo actionWithDuration:0.5 position:ccp(0.0, 0.0)];
        [finishLayer runAction:moveAction];
        //CCLOG(@"You win");
    }
}

-(void)initSoundEgine
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectError];
}

@end
