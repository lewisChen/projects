//
//  PlayScene.h
//  colorEliminate
//
//  Created by mybox_1027@sina.com on 14-6-11.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class ColorBlock;

@interface PlayScene : CCNode
{
    CCNode *m_pauseLayer;
    CCNodeColor *m_ground;
    
    CGPoint m_beginPoint;
    CGPoint m_endPoint;
    
    NSMutableArray *m_arrayAllBlock;
    
    BOOL m_isIgnoreTouchMove;
}

@property(nonatomic,assign)CGPoint beginPoint;
@property(nonatomic,assign)CGPoint endPoint;
@property(nonatomic,retain)NSMutableArray* arrayAllBlock;
@property(nonatomic,readwrite)BOOL isIgnoreTouchMove;

-(CGPoint)convertIndexToPoint:(ColorBlock*)colorBlock;
-(void)changeBlockPosition:(ColorBlock *)colorBlock indexRow:(NSInteger)indexRow indexCollum:(NSInteger)indexCollum isAnimate:(BOOL)isAnimate;
-(void)generateColorBlock;
-(void)update:(CCTime)delta;
-(void)moveBlock;
-(NSInteger)getMinRowWithBlock:(ColorBlock*)block;
-(BOOL)isStartGenerate;
-(BOOL)isCanMoveLeft;
-(BOOL)isCanMoveRight;


@end
