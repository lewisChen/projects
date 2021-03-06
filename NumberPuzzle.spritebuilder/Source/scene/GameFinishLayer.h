//
//  GameFinishLayer.h
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-1-21.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "CCControl.h"

@interface GameFinishLayer : CCControl
{
    CCSprite *m_star1;
    CCSprite *m_star2;
    CCSprite *m_star3;
    
    NSMutableArray *m_arraySprite;
    NSInteger m_starCount;
    CCLabelBMFont *m_labelResult;
    CCLabelTTF *m_labelLevel;
}

@property(nonatomic,readwrite) NSInteger starCount;

-(void)initResource;
-(void)handleShowScore;
-(NSInteger)getStarCount;
-(void)starActionHandle:(NSInteger)starCount;
-(void)playStarSound;
-(void)starTwoAction;
-(void)starThreeAction;
-(CCAction*)getStarAction;
-(void)showIsWinLabel:(BOOL)value;

@end
