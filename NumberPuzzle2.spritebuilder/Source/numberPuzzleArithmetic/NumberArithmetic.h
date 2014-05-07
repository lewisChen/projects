//
//  NumberArithmetic.h
//  NumberPuzzleBeta2
//
//  C/Users/user/Documents/study/arithmetic/numberPuzzleArithmetic/NumberArithmetic.hreated by mybox_1027@sina.com on 13-12-11.
//  Copyright (c) 2013年 mybox_1027@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberArithmetic : NSObject

+(NumberArithmetic*)sharedNumberArithmetic;
-(NSMutableArray*)getRandomArray;
-(NSMutableArray*)createNumberPuzzleArray;

@end
