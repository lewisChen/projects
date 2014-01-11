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

#define MAX_ITEM_COUNT_X (9)
#define MAX_ITEM_COUNT_Y (9)
#define FIRST_BLOCK_INDEX (2)
#define SECOND_BLOCK_INDEX (5)


@implementation LevelLayer

- (void) didLoadFromCCB
{
    [self initLayer];
    [self setLevel:1];//create level;
    [self setEnabled:YES];//enable touch event
    //[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (void)initLayer
{
    if (self)
    {
        float xOffset = 0.0;
        float yOffset = 0.0;
        NSMutableArray *array = [NumberArithmetic sharedNumberArithmetic].createNumberPuzzleArray;
        
        self.contentSize = [CCDirector sharedDirector].viewSize;
        for (unsigned char indexX = 0; indexX<MAX_ITEM_COUNT_X; indexX++)
        {
            for (unsigned char indexY = 0; indexY<MAX_ITEM_COUNT_Y; indexY++)
            {
                NumberItem *numberItem = [NumberItem node];
                [numberItem setNumberLabel:[CCLabelTTF labelWithString:(NSString*)[array objectAtIndex:(indexX*MAX_ITEM_COUNT_X+indexY)] fontName:FontNameNormal fontSize:FontSizeNormal]];
                numberItem.anchorPoint = ccp(0.5, 0.5);
                
                //determind x offset
                if (indexX<=FIRST_BLOCK_INDEX)
                {
                    xOffset = numberItem.contentSize.width*indexX;
                }
                else if (FIRST_BLOCK_INDEX<indexX && indexX<=SECOND_BLOCK_INDEX)
                {
                    xOffset = numberItem.contentSize.width*indexX+2;
                }
                else if (indexX>SECOND_BLOCK_INDEX)
                {
                    xOffset = numberItem.contentSize.width*indexX+4;
                }
                
                //determind y offset
                if (indexY<=FIRST_BLOCK_INDEX)
                {
                    yOffset = -numberItem.contentSize.height*indexY;
                }
                else if (FIRST_BLOCK_INDEX<indexY && indexY<=SECOND_BLOCK_INDEX)
                {
                    yOffset = -numberItem.contentSize.height*indexY-2;
                    
                }
                else if (indexY>SECOND_BLOCK_INDEX)
                {
                    yOffset = -numberItem.contentSize.height*indexY-4;
                }
                
                
                numberItem.position = ccp(numberItem.contentSize.width+xOffset, (self.contentSize.height*3/4)+ yOffset);
                [self addChild:numberItem];
                
            }
        }
    }
    //return self;
}

-(void)setLevel:(NSUInteger)level
{
    BOOL isShow = NO;
    NSInteger randomNumber = 0;
    srandom(time(NULL));
    NSArray *childrenArray = [self children];

    CCNode *node = NULL;
    NumberItem *numberItem = NULL;
    for (node in childrenArray)
    {
        randomNumber = random()%2;
        isShow = randomNumber>0?YES:NO;
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
    NSString *currentTouchNumberString = @"0";
    BOOL isIgnoreTouch = NO;
    
    for (node in childrenArray)
    {
        if ([node isKindOfClass:[NumberItem class]])
        {
            numberItem = (NumberItem*)node;
            if (ccpDistanceSQ(currentPosition, numberItem.position)<(kItemwidth*kItemHight/4))
            {
                isIgnoreTouch = numberItem.numberLabelVisable?NO:YES;
                if (isIgnoreTouch)
                {
                    break;
                }
                currentTouchNumberString = [numberItem numberLabel].string;
                break;
                //[numberItem setNumberLabel:[CCLabelTTF labelWithString:@"1" fontName:FontNameNormal fontSize:FontSizeNormal]];
            }
        }

    }
    
    if (!isIgnoreTouch)
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
                    [numberItem setItemColor:ccGRAY];
                }
                
                else
                {
                    [numberItem setItemColor:myItemColor];
                }
            }
        }

    }
}


-(void)buttonReturn:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];

}

-(void)itemButtonClick:(id)sender
{
    CCButton *btn = (CCButton*)sender;
    NSString *temString = btn.title;
    btn.position = ccp(btn.position.x+2.0,btn.position.y);
}

@end
