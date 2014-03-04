//
//  GameDataHandler.h
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-2-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTimeLimit (4*60.0)
#define kTimeMin (60)

enum eDifficultLevel
{
    eDifficultLevelEasy = 0,
    eDifficultLevelNormal,
    eDifficultLevelHard,
};

@interface GameDataHandler : NSObject
{
    NSInteger m_level;
    NSInteger m_difficultLevel;
    NSInteger m_errorCount;
    double m_useTime;
    double m_timeLeft;
    double m_timeLimit;
    NSInteger m_starCount;
}

@property(nonatomic,readwrite) NSInteger level;
@property(nonatomic,readwrite) NSInteger difficultLevel;
@property(nonatomic,readwrite) NSInteger errorCount;
@property(nonatomic,readwrite) double useTime;
@property(nonatomic,readwrite) double timeLeft;
@property(nonatomic,readwrite) double timeLimit;
@property(nonatomic,readwrite) NSInteger starCount;


+(GameDataHandler*)sharedGameDataHandler;
+(id)alloc;
-(void)initSaveData;
-(void)saveData;
-(void)loadData;
-(void)saveDataArray:(NSArray*)array withKey:(NSString*)key;
-(void)initResource;
-(NSString*)getUseTimeString;
-(NSString*)getLeftTimeString;
-(double)getTimeLimit;
-(NSInteger)getGameLevel:(enum eDifficultLevel)difficultLevel;

@end
