//
//  GameDataHandler.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-2-2.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "GameDataHandler.h"

@implementation GameDataHandler

@synthesize level = m_level;
@synthesize errorCount = m_errorCount;
@synthesize useTime = m_useTime;

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
}

-(void)loadData
{
    
}

-(void)saveData
{
    
}


@end
