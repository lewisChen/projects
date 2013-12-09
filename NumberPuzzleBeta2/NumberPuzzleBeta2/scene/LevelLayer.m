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

#define MAX_ITEM_COUNT_X (9)
#define MAX_ITEM_COUNT_Y (9)
#define FIRST_BLOCK_INDEX (2)
#define SECOND_BLOCK_INDEX (5)


@implementation LevelLayer

- (void) didLoadFromCCB
{
    [self initLayer];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (void)initLayer

{
    //self = [super init];
    if (self)
    {
        float xOffset = 0.0;
        float yOffset = 0.0;
        //self.contentSize = [CCDirector sharedDirector].winSize;
        for (unsigned char indexX = 0; indexX<MAX_ITEM_COUNT_X; indexX++)
        {
            for (unsigned char indexY = 0; indexY<MAX_ITEM_COUNT_Y; indexY++)
            {
                NumberItem *numberItem = [NumberItem node];
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


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint currentPosition = [touch locationInView:touch.view];
    currentPosition = [[CCDirector sharedDirector] convertToGL:currentPosition];
    currentPosition = [self convertToNodeSpace:currentPosition];
    
    CCArray *childrenArray = [self children];
    CCNode *node = NULL;
    NumberItem *numberItem = NULL;
    CCARRAY_FOREACH(childrenArray, node)
    {
        if ([node isKindOfClass:[NumberItem class]])
        {
            numberItem = (NumberItem*)node;
            if (ccpDistanceSQ(currentPosition, numberItem.position)<(kItemwidth*kItemHight/4))
            {
                [numberItem setNumberLabel:[CCLabelTTF labelWithString:@"1" fontName:FontNameNormal fontSize:FontSizeNormal]];
            }
            
        }
    }
    
    return NO;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

@end
