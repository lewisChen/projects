//
//  GameDataHandler.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-2-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "GameDataHandler.h"

//NSString* const kLevel = @"kLecel";
//NSString* const kDifficultLevel = @"kDifficultLevel";
//#define kLevelEasy (0)
//#define kLevelNormal (0)
//#define kLevelHard (0)

enum eLevelRecordTag
{
    eLevelRecordEasy = 0,
    eLevelRecordNormal,
    eLevelRecordHard,
};

NSString* const kGameSaveData = @"kGameSaveData";

inline static id getSavaDataByDifficultLevel(enum eDifficultLevel difficultLevel)
{
    id tempData = 0;
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* saveArray = [saveDefaults objectForKey:kGameSaveData];

    switch (difficultLevel)
    {
        case eDifficultLevelEasy:
            tempData = [saveArray objectAtIndex:eLevelRecordEasy];
            break;
        case eDifficultLevelNormal:
            tempData = [saveArray objectAtIndex:eLevelRecordNormal];
            break;
        case eDifficultLevelHard:
            tempData = [saveArray objectAtIndex:eLevelRecordHard];
        default:
            break;
    }
    return tempData;
}

@interface GameDataHandler ()
@property double startTime;
@property double timeLimit;
@end

@implementation GameDataHandler

@synthesize level = m_level;
@synthesize difficultLevel = m_difficultLevel;
@synthesize errorCount = m_errorCount;
@synthesize useTime = m_useTime;
@synthesize timeLeft = m_timeLeft;
@synthesize starCount = m_starCount;

static GameDataHandler* _sharedGameDataHandler = nil;

+(GameDataHandler*)sharedGameDataHandler
{
    @synchronized([GameDataHandler class])
    {
        if (_sharedGameDataHandler == nil)
        {
            _sharedGameDataHandler = [[self alloc] init];
        }
        return _sharedGameDataHandler;
    }
    return  nil;
}

+(id)alloc
{
    @synchronized([GameDataHandler class])
    {
        NSAssert(_sharedGameDataHandler == nil, @"Attempted to allocate a second instance of the Game Manager singleton");
        _sharedGameDataHandler = [super alloc];
        return _sharedGameDataHandler;
    }
    return nil;
}

-(void)initResource
{
    CCSpriteFrameCache *spriteCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [spriteCache addSpriteFramesWithFile:@"numberItemTex.plist" textureFilename:@"numberItemTex.png"];
    _sharedGameDataHandler.startTime = CACurrentMediaTime();
    self.timeLimit = self.getTimeLimit;
    [self initSaveData];
    [self loadData];
}

-(void)initSaveData
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* saveArray = [saveDefaults objectForKey:kGameSaveData];

    if (nil==saveArray)
    {
        saveArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0],
                                              [NSNumber numberWithInteger:0],
                                              [NSNumber numberWithInteger:0],
                                              nil];
        [self saveDataArray:saveArray withKey:kGameSaveData];
    }
}

-(void)loadData
{
    id tempData = getSavaDataByDifficultLevel(self.difficultLevel);
    self.level = [(NSNumber*)tempData integerValue];
    self.timeLeft = self.getTimeLimit;
    
    tempData = getSavaDataByDifficultLevel(eDifficultLevelHard);
    tempData = getSavaDataByDifficultLevel(eDifficultLevelNormal);
}

-(void)saveData
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* saveArray = [saveDefaults objectForKey:kGameSaveData];
    NSArray *newArray = nil;
    
    switch (self.difficultLevel)
    {
        case eDifficultLevelEasy:
            newArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.level],
                                                [saveArray objectAtIndex:eLevelRecordNormal],
                                                [saveArray objectAtIndex:eLevelRecordHard],
                                                nil];
            break;
        case eDifficultLevelNormal:
            newArray = [NSArray arrayWithObjects:[saveArray objectAtIndex:eLevelRecordEasy],
                                                [NSNumber numberWithInteger:self.level],
                                                [saveArray objectAtIndex:eLevelRecordHard],
                                                nil];
            break;
        case eDifficultLevelHard:
            newArray = [NSArray arrayWithObjects:[saveArray objectAtIndex:eLevelRecordEasy],
                                                 [saveArray objectAtIndex:eLevelRecordNormal],
                                                 [NSNumber numberWithInteger:self.level],
                                                 nil];
            break;
        default:
            break;
    }
    [self saveDataArray:newArray withKey:kGameSaveData];
}

-(void)saveDataArray:(NSArray*)array withKey:(NSString *)key
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults setObject:array forKey:key];
}

-(NSString*)getUseTimeString
{
    NSString *timeString = @"00:00";
    
    double currentTime = CACurrentMediaTime();
    double secs = MAX(0, currentTime - [self startTime]);
    double intPart = 0;
    double fractPart = modf(secs, &intPart);
    int isecs = (int)intPart;
    int min = isecs / 60;
    int sec = isecs % 60;
    int hund = (int) (fractPart * 100);
    timeString = [NSString stringWithFormat:@"%02d:%02d:%02d",min, sec, hund];
    
    //record use time
    self.useTime = isecs;
    
    return timeString;

}

-(NSString*)getLeftTimeString
{
    NSString *timeString = @"00:00:00";

    double currentTime = CACurrentMediaTime();
    double secs = MAX(0,  self.timeLimit - (currentTime - [self startTime]));
    double intPart = 0;
    double fractPart = modf(secs, &intPart);
    int isecs = (int)intPart;
    int min = isecs / 60;
    int sec = isecs % 60;
    int hund = (int) (fractPart * 100);
    timeString = [NSString stringWithFormat:@"%02d:%02d:%02d",min, sec, hund];
    
    //record use time
    self.timeLeft = secs;
    
    return timeString;

}

-(double)getTimeLimit
{
    NSInteger gameLevel = [self getGameLevel:self.difficultLevel];
    double timeLimit = kTimeLimit-gameLevel*10;
    if (timeLimit< kTimeMin)
    {
        timeLimit = kTimeMin;
    }
    return timeLimit;
}

-(NSInteger)getGameLevel:(enum eDifficultLevel)difficultLevel
{
    NSInteger gameLevel = 0;
    id tempData = getSavaDataByDifficultLevel(difficultLevel);
    gameLevel = [(NSNumber*)tempData integerValue];
    return gameLevel;
}

@end
