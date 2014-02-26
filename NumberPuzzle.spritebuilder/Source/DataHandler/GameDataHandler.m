//
//  GameDataHandler.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-2-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "GameDataHandler.h"

@interface GameDataHandler ()
@property double startTime;
@end

@implementation GameDataHandler

@synthesize level = m_level;
@synthesize errorCount = m_errorCount;
@synthesize useTime = m_useTime;
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
}

-(void)loadData
{
    
}

-(void)saveData
{
    
}

-(NSString*)getUseTimeString
{
    NSString *timeString = @"00:00:00";
    
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
    self.useTime = min;
    
    return timeString;

}


@end
