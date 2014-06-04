//
//  GameDataHandler.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-2-2.
//

#import "GameDataHandler.h"

//NSString* const kLevel = @"kLecel";
//NSString* const kDifficultLevel = @"kDifficultLevel";
//#define kLevelEasy (0)
//#define kLevelNormal (0)
//#define kLevelHard (0)


NSString* const kGameSaveData = @"kGameSaveData";
NSString* const kIsRate = @"kIsRate";
NSString* const kHighestScore = @"kHighestScore";
NSString* const kEnterTime = @"kEnterTime";



@interface GameDataHandler ()
@property double startTime;
//@property double timeLimit;
@end

@implementation GameDataHandler

@synthesize blockTypeSelect = m_blockTypeSelect;
@synthesize gameMode = m_gameMode;
@synthesize tapCount = m_tapCount;
@synthesize level = m_level;

@synthesize errorCount = m_errorCount;
@synthesize useTime = m_useTime;
@synthesize timeLeft = m_timeLeft;
@synthesize timeLimit = m_timeLimit;
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
    _sharedGameDataHandler.startTime = CACurrentMediaTime();
    self.timeLimit = self.getTimeLimit;
    self.level = 0;
    self.tapCount = 0;
//    self.errorCount = 0;
//    [self initSaveData];
//    [self loadData];
}

-(void)initSaveData
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *enterGameTime = [saveDefaults objectForKey:kEnterTime];
    if (nil==enterGameTime)
    {
        [saveDefaults setObject:[NSNumber numberWithInteger:0] forKey:kEnterTime];
    }
    else
    {
        [self loadData];
    }
    
    NSNumber *isRate = [saveDefaults objectForKey:kIsRate];
    if (nil==isRate)
    {
        [saveDefaults setObject:[NSNumber numberWithBool:NO] forKey:kIsRate];
    }
    
}

-(void)loadData
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enterTime = [saveDefaults objectForKey:kEnterTime];
    
    self.enterGameCount = enterTime.integerValue;
}

-(void)resetSaveData
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults removeObjectForKey:kGameSaveData];
}

-(void)saveData
{
//    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray* saveArray = [saveDefaults objectForKey:kGameSaveData];
//    NSArray *newArray = nil;
//    
//    id starCountAlready = getStarCount();
//    self.starCount = [(NSNumber*)starCountAlready integerValue] + self.starCount;
//    
//    switch (self.difficultLevel)
//    {
//        case eDifficultLevelEasy:
//            newArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.level],
//                                                [saveArray objectAtIndex:eLevelRecordNormal],
//                                                [saveArray objectAtIndex:eLevelRecordHard],
//                                                [NSNumber numberWithInteger:self.starCount],
//                                                nil];
//            break;
//        case eDifficultLevelNormal:
//            newArray = [NSArray arrayWithObjects:[saveArray objectAtIndex:eLevelRecordEasy],
//                                                [NSNumber numberWithInteger:self.level],
//                                                [saveArray objectAtIndex:eLevelRecordHard],
//                                                [NSNumber numberWithInteger:self.starCount],
//                                                nil];
//            break;
//        case eDifficultLevelHard:
//            newArray = [NSArray arrayWithObjects:[saveArray objectAtIndex:eLevelRecordEasy],
//                                                 [saveArray objectAtIndex:eLevelRecordNormal],
//                                                 [NSNumber numberWithInteger:self.level],
//                                                [NSNumber numberWithInteger:self.starCount],
//                                                 nil];
//            break;
//        default:
//            break;
//    }
//    [self saveDataArray:newArray withKey:kGameSaveData];
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
    timeString = [NSString stringWithFormat:@"%02d'%02d'%02d",min, sec, hund];
    
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
    timeString = [NSString stringWithFormat:@"%02d'%02d'%02d",min, sec, hund];
    
    //record use time
    self.timeLeft = secs;
    self.useTime = self.timeLimit-secs;
    
    return timeString;

}

-(double)getTimeLimit
{
    double timeLimit = kTimeLimit;
    return timeLimit;
}


-(void)resetTime
{
    self.startTime = CACurrentMediaTime();
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
