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
}

@property(nonatomic,assign)CGPoint beginPoint;
@property(nonatomic,assign)CGPoint endPoint;

-(CGPoint)convertIndexToPoint:(ColorBlock*)colorBlock;
-(void)changeBlockPosition:(ColorBlock *)colorBlock indexRow:(NSInteger)indexRow indexCollum:(NSInteger)indexCollum isAnimate:(BOOL)isAnimate;
-(void)generateColorBlock;
-(void)update:(CCTime)delta;
-(void)moveBlock;

@end
