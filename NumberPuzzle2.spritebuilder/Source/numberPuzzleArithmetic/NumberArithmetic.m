//
//  NumberArithmetic.m
//  NumberPuzzleBeta2
//
//  Created by mybox_1027@sina.com on 13-12-11.
//  Copyright (c) 2013年 mybox_1027@sina.com. All rights reserved.
//

#import "NumberArithmetic.h"

@implementation NumberArithmetic

static NumberArithmetic* _sharedNumberArithmetic = NULL;

+(NumberArithmetic*)sharedNumberArithmetic
{
    @synchronized([NumberArithmetic class])
    {
        if (_sharedNumberArithmetic == nil)
        {
            _sharedNumberArithmetic = [[self alloc] init];
        }
        return _sharedNumberArithmetic;
    }
    return  nil;
}

+(id)alloc
{
    @synchronized([NumberArithmetic class])
    {
        NSAssert(_sharedNumberArithmetic == nil, @"Attempted to allocate a second instance of the Game Manager singleton");//6
        _sharedNumberArithmetic = [super alloc];
        return _sharedNumberArithmetic;
    }
    return nil;
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

-(NSMutableArray*)getRandomArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:9];
    NSInteger randomNumber = 0;
    NSString *tempString = NULL;
    srandom(time(NULL));
    
    for (NSInteger i = 0; i<9; i++)
    {
        randomNumber = random()%9+1;
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
            
            randomNumber = random()%9+1;
        }
    }
    
    return array;
}

-(NSMutableArray*)createNumberPuzzleArray
{
    NSMutableArray *numberPuzzleArray = [NSMutableArray arrayWithCapacity:81];
    
    int seedArray[9][9]={
        {9,7,8,3,1,2,6,4,5},
        {3,1,2,6,4,5,9,7,8},
        {6,4,5,9,7,8,3,1,2},
        {7,8,9,1,2,3,4,5,6},
        {1,2,3,4,5,6,7,8,9},
        {4,5,6,7,8,9,1,2,3},
        {8,9,7,2,3,1,5,6,4},
        {2,3,1,5,6,4,8,9,7},
        {5,6,4,8,9,7,2,3,1}
    };
    
    NSMutableArray *randomArray = [self getRandomArray];
    
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            for (int k = 0; k < 9; k++) {
                if(seedArray[i][j]==[(NSString*)[randomArray objectAtIndex:k] integerValue])
                {
                    [numberPuzzleArray addObject:[randomArray objectAtIndex:(k+1)%9]];
                    
                    break;
                }
            }
        }
    }
    
    return numberPuzzleArray;
    
}

@end
