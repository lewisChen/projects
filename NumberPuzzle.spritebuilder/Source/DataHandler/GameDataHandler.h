//
//  GameDataHandler.h
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-2-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDataHandler : NSObject
{
    NSInteger m_level;
    NSInteger m_errorCount;
    double m_useTime;
    NSInteger m_starCount;
}

@property(nonatomic,readwrite) NSInteger level;
@property(nonatomic,readwrite) NSInteger errorCount;
@property(nonatomic,readwrite) double useTime;
@property(nonatomic,readwrite) NSInteger starCount;

+(GameDataHandler*)sharedGameDataHandler;
+(id)alloc;
-(void)saveData;
-(void)loadData;
-(void)initResource;
-(NSString*)getUseTimeString;

@end
