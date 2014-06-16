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
    eStarCount,
};

NSString* const kGameSaveData = @"kGameSaveData";
NSString* const kIsRate = @"kIsRate";
NSString* const kEnterTime = @"kEnterTime";


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

inline static id getStarCount(void)
{
    id tempData = 0;
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* saveArray = [saveDefaults objectForKey:kGameSaveData];
    
    if (saveArray)
    {
        tempData = [saveArray objectAtIndex:eStarCount];

    }
    
    return tempData;
}

@interface GameDataHandler ()
@property double startTime;
//@property double timeLimit;
@end

@implementation GameDataHandler

@synthesize level = m_level;
@synthesize difficultLevel = m_difficultLevel;
@synthesize errorCount = m_errorCount;
@synthesize useTime = m_useTime;
@synthesize timeLeft = m_timeLeft;
@synthesize timeLimit = m_timeLimit;
@synthesize starCount = m_starCount;
@synthesize isWin = m_isWin;
@synthesize enterGameCount = m_enterGameCount;


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
//    CCSpriteFrameCache *spriteCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//    [spriteCache addSpriteFramesWithFile:@"numberItemTex.plist" textureFilename:@"numberItemTex.png"];
    _sharedGameDataHandler.startTime = CACurrentMediaTime();
    self.timeLimit = self.getTimeLimit;
    self.errorCount = 0;
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
                                              [NSNumber numberWithInteger:0],
                                              nil];
        [self saveDataArray:saveArray withKey:kGameSaveData];
    }
    
    NSNumber *enterGameTime = [saveDefaults objectForKey:kEnterTime];
    if (nil==enterGameTime)
    {
        [saveDefaults setObject:[NSNumber numberWithInteger:0] forKey:kEnterTime];
    }
    
    NSNumber *isRate = [saveDefaults objectForKey:kIsRate];
    if (nil==isRate)
    {
        [saveDefaults setObject:[NSNumber numberWithBool:NO] forKey:kIsRate];
    }


}

-(void)loadData
{
    id tempData = getSavaDataByDifficultLevel((enum eDifficultLevel)self.difficultLevel);
    self.level = [(NSNumber*)tempData integerValue];
    self.timeLeft = self.getTimeLimit;
    
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enterTime = [saveDefaults objectForKey:kEnterTime];
    self.enterGameCount = enterTime.integerValue;
    
//    tempData = getSavaDataByDifficultLevel(eDifficultLevelHard);
//    tempData = getSavaDataByDifficultLevel(eDifficultLevelNormal);
}

-(void)resetSaveData
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults removeObjectForKey:kGameSaveData];
}

-(void)saveData
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* saveArray = [saveDefaults objectForKey:kGameSaveData];
    NSArray *newArray = nil;
    
    id starCountAlready = getStarCount();
    self.starCount = [(NSNumber*)starCountAlready integerValue] + self.starCount;
    
    switch (self.difficultLevel)
    {
        case eDifficultLevelEasy:
            newArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.level],
                                                [saveArray objectAtIndex:eLevelRecordNormal],
                                                [saveArray objectAtIndex:eLevelRecordHard],
                                                [NSNumber numberWithInteger:self.starCount],
                                                nil];
            break;
        case eDifficultLevelNormal:
            newArray = [NSArray arrayWithObjects:[saveArray objectAtIndex:eLevelRecordEasy],
                                                [NSNumber numberWithInteger:self.level],
                                                [saveArray objectAtIndex:eLevelRecordHard],
                                                [NSNumber numberWithInteger:self.starCount],
                                                nil];
            break;
        case eDifficultLevelHard:
            newArray = [NSArray arrayWithObjects:[saveArray objectAtIndex:eLevelRecordEasy],
                                                 [saveArray objectAtIndex:eLevelRecordNormal],
                                                 [NSNumber numberWithInteger:self.level],
                                                [NSNumber numberWithInteger:self.starCount],
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
    self.useTime = self.timeLimit-secs;
    
    return timeString;

}

-(double)getTimeLimit
{
    NSInteger gameLevel = [self getGameLevel:(enum eDifficultLevel)self.difficultLevel];
    double timeLimit = kTimeLimit-gameLevel*10;
    
    switch (self.difficultLevel)
    {
        case eDifficultLevelEasy:
            if (timeLimit< kTimeMinEasy)
            {
                timeLimit = kTimeMinEasy;
            }
            break;
        case eDifficultLevelNormal:
            if (timeLimit< kTimeMinNormal)
            {
                timeLimit = kTimeMinNormal;
            }
            break;
        case eDifficultLevelHard:
            if (timeLimit< kTimeMinHard)
            {
                timeLimit = kTimeMinHard;
            }
        default:
            break;
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

-(void)increaseEnterTime
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enterTime = [saveDefaults objectForKey:kEnterTime];
    if (enterTime!=nil)
    {
        NSInteger currentEnterCount = [enterTime integerValue];
        
        NSInteger enterCount = currentEnterCount+1;
        [saveDefaults setObject:[NSNumber numberWithInteger:enterCount] forKey:kEnterTime];
        self.enterGameCount = enterCount;
        
    }
    
}

-(void)resetEnterTime
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults setObject:[NSNumber numberWithInteger:0] forKey:kEnterTime];
    self.enterGameCount = 0;
}

-(void)setIsRate
{
    if (self.getIsRate==NO)
    {
        NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
        [saveDefaults setObject:[NSNumber numberWithBool:YES] forKey:kIsRate];
    }
}
-(BOOL)getIsRate
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *isRate = [saveDefaults objectForKey:kIsRate];
    return isRate.boolValue;
    
}


@end
