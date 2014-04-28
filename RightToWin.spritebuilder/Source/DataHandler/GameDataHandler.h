//
//  GameDataHandler.h
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-2-2.
//

#import <Foundation/Foundation.h>
#import "../obj/BlockObj.h"

#define kTimeLimit (6*60.0)
#define kTimeMinEasy (2*60.0)
#define kTimeMinNormal (3*60.0)
#define kTimeMinHard (4*60.0)

enum eDifficultLevel
{
    eDifficultLevelEasy = 0,
    eDifficultLevelNormal,
    eDifficultLevelHard,
};

typedef enum : NSUInteger
{
    eGameModeTime = 0,
    eGameModeCount,
    eGameModeCrazy,
} eGameMode;

@interface GameDataHandler : NSObject
{
    eBlockType m_blockTypeSelect;
    eGameMode m_gameMode;
    NSInteger m_level;
    NSInteger m_difficultLevel;
    NSInteger m_errorCount;
    double m_useTime;
    double m_timeLeft;
    double m_timeLimit;
    NSInteger m_starCount;
    BOOL m_isWin;
}

@property(nonatomic,readwrite) eBlockType blockTypeSelect;
@property(nonatomic,readwrite) eGameMode  gameMode;
@property(nonatomic,readwrite) NSInteger level;
@property(nonatomic,readwrite) NSInteger difficultLevel;
@property(nonatomic,readwrite) NSInteger errorCount;
@property(nonatomic,readwrite) double useTime;
@property(nonatomic,readwrite) double timeLeft;
@property(nonatomic,readwrite) double timeLimit;
@property(nonatomic,readwrite) NSInteger starCount;
@property(nonatomic,readwrite) BOOL isWin;


+(GameDataHandler*)sharedGameDataHandler;
+(id)alloc;
-(void)initSaveData;
-(void)saveData;
-(void)loadData;
-(void)resetSaveData;
-(void)saveDataArray:(NSArray*)array withKey:(NSString*)key;
-(void)initResource;
-(NSString*)getUseTimeString;
-(NSString*)getLeftTimeString;
-(double)getTimeLimit;
-(NSInteger)getGameLevel:(enum eDifficultLevel)difficultLevel;

@end
