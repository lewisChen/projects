//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Objects/numberItem.h"

#define MAX_ITEM_COUNT_X (9)
#define MAX_ITEM_COUNT_Y (9)
#define FIRST_BLOCK_INDEX (2)
#define SECOND_BLOCK_INDEX (5)

@implementation MainScene

- (id)init
{
    self = [super init];
    if (self)
    {
        float xOffset = 0.0;
        float yOffset = 0.0;
        self.contentSize = [CCDirector sharedDirector].viewSize;
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
    return self;
}


@end
