//
//  PlayScene.m
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import "PlayScene.h"
#import "../obj/BlockObj.h"


#define kRowOfItemCount (9)
#define kCollumOfItemCount (5)

@interface PlayScene ()

@property NSInteger _updateStasticCount;

@end

@implementation PlayScene

- (void) didLoadFromCCB
{
    m_blockArray = [NSMutableArray array];
    [self placeAllBlock];
    [self setUserInteractionEnabled:YES];
}


-(void)placeAllBlock
{
    for (NSInteger row = 0; row<kRowOfItemCount; row++)
    {
        NSArray *typeArray = [self getRandomArray:kCollumOfItemCount];
        for (NSInteger collum = 0; collum<kCollumOfItemCount; collum++)
        {
            BlockObj *obj = (BlockObj*)[CCBReader load:@"BlockObj.ccbi"];
            NSString *typeString = [typeArray objectAtIndex:collum];

            [obj setType:(eBlockType)typeString.integerValue];
            obj.colIndex = collum;
            obj.rowIndex = row;
            obj.position = ccp(obj.contentSize.width*collum, obj.contentSize.height*row);
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
            typeArray = [self getRandomArray:kCollumOfItemCount];
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

- (bool)isNumberInArray:(NSMutableArray*)array :(NSInteger)number
{
    for (NSUInteger index = 0; index<array.count; index++)
    {
        if ([(NSString*)[array objectAtIndex:index] integerValue] == number)
        {
            return YES;
        }
    }
    return NO;
    
}


-(NSMutableArray*)getRandomArray:(NSInteger)arraySize
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:arraySize];
    NSInteger randomNumber = 0;
    NSString *tempString = NULL;
    
    //srandom(time(NULL));//add timeSeed variable for time too fast condiction
    for (NSInteger i = 0; i<arraySize; i++)
    {
        randomNumber =  (arc4random()%arraySize);//random()%arraySize;//
        tempString = [NSString stringWithFormat:@"%d",randomNumber];
        
        while (YES)
        {
            BOOL isBreak = NO;
            if (array.count>0)
            {
                if (NO == [self isNumberInArray:array :randomNumber])
                {
                    tempString = [NSString stringWithFormat:@"%d",randomNumber];
                    [array addObject:tempString];
                    isBreak = YES;
                }
                
            }
            else
            {
                [array addObject:tempString];
                isBreak = YES;
            }
            
            if (isBreak)
            {
                break;
            }
            
            randomNumber = random()%arraySize;
        }
    }
    
    return array;
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
                NSString *string = [NSString stringWithFormat:@"row = %d,collum = %d",obj.rowIndex,obj.colIndex];
                CCLOG(string);
                [self moveBlocks];
            }
        }
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
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

@end
