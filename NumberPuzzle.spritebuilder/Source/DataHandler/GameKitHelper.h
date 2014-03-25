//
//  GameKitHelper.h
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-3-24.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
//   Include the GameKit framework
#import <GameKit/GameKit.h>

#define kHighScoreBoardIdentifier @"com.zhenyuChen.numberPuzzle.highScore"

//   Protocol to notify external
//   objects when Game Center events occur or
//   when Game Center async tasks are completed
@protocol GameKitHelperProtocol<NSObject>
-(void) onScoresSubmitted:(bool)success;
@end


@interface GameKitHelper : NSObject

@property (nonatomic, assign) id<GameKitHelperProtocol> delegate;

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;
// Player authentication, info
-(void) authenticateLocalPlayer;

// Scores
-(void)submitScore:(int64_t)score category:(NSString*)identifier;

@end
