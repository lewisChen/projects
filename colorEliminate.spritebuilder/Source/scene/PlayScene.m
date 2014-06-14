//
//  PlayScene.m
//  colorEliminate
//
//  Created by mybox_1027@sina.com on 14-6-11.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "PlayScene.h"
#import "../tools/randomColor.h"
#import "../tools/uiPostionDef.h"
#import "../obj/ColorBlock.h"

#define kMoveThreshold (5)

@interface PlayScene ()
@property BOOL _isGenerateBlock;
@property ColorBlock *_currentBlock;
@property NSInteger _updateStasticCount;
@end

@implementation PlayScene

@synthesize beginPoint = m_beginPoint;
@synthesize endPoint = m_endPoint;

- (void) didLoadFromCCB
{
    [self initGroundSizeAndColor];
    [self setUserInteractionEnabled:YES];
    self._isGenerateBlock = YES;
    self._currentBlock = nil;
}

-(void)initGroundSizeAndColor
{
    m_ground.contentSize = getAdSize();
    m_ground.color = getRandomColor();

}

-(void)buttonPressBack:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionRight duration:0.2]];

}

-(void)buttonPressPause:(id)sender
{
    CCAction *action = [CCActionMoveTo actionWithDuration:0.5 position:ccp(0.0, 0.0)];
    [m_pauseLayer runAction:action];
    
}

-(CGPoint)convertIndexToPoint:(ColorBlock *)colorBlock
{
    CGPoint point = CGPointZero;
    if (colorBlock!=nil)
    {
        CGSize blockSize = colorBlock.contentSize;
        CGSize groundSize = m_ground.contentSize;
        
        point.x = blockSize.width*colorBlock.indexCollum;
        point.y = blockSize.height*colorBlock.indexRow+groundSize.height;
    }
    return point;
}

-(void)changeBlockPosition:(ColorBlock *)colorBlock indexRow:(NSInteger)indexRow indexCollum:(NSInteger)indexCollum isAnimate:(BOOL)isAnimate
{
    CGPoint point = CGPointZero;

    if (colorBlock!=nil)
    {
        CGSize blockSize = colorBlock.contentSize;
        CGSize groundSize = m_ground.contentSize;
        
        point.x = blockSize.width*indexCollum;
        point.y = blockSize.height*indexRow+groundSize.height;

        colorBlock.indexRow = indexRow;
        colorBlock.indexCollum = indexCollum;
        
        if (YES == isAnimate)
        {
            CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.5 position:point];
            [colorBlock runAction:actionMove];
        }
        else
        {
            colorBlock.position = point;
        }
        
    }
}

-(void)rightMove
{
    CCLOG(@"right");
    [self changeBlockPosition:self._currentBlock indexRow:self._currentBlock.indexRow indexCollum:self._currentBlock.indexCollum+1 isAnimate:NO];
}

-(void)leftMove
{
    CCLOG(@"left");
    [self changeBlockPosition:self._currentBlock indexRow:self._currentBlock.indexRow indexCollum:self._currentBlock.indexCollum-1 isAnimate:NO];
}

-(void)downMove
{
    CCLOG(@"down");
    [self changeBlockPosition:self._currentBlock indexRow:self._currentBlock.indexRow-1 indexCollum:self._currentBlock.indexCollum isAnimate:NO];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint currentPosition = [touch locationInView:touch.view];

    self.beginPoint = currentPosition;
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint currentPosition = [touch locationInView:touch.view];
    self.endPoint = currentPosition;
    
    CGFloat diffX = self.beginPoint.x-self.endPoint.x;
    CGFloat diffY = self.beginPoint.y-self.endPoint.y;
    
    if (abs(diffX)>abs(diffY))
    {
        //left or right
        if (abs(diffX)>=kMoveThreshold)
        {
            if (diffX>0)
            {
                [self leftMove];
            }
            else
            {
                [self rightMove];
            }
        }
        
    }
    else
    {
        //down
        if (abs(diffY)>=kMoveThreshold)
        {
            if (diffY<0)
            {
                [self downMove];
            }
        }
    }
}

-(void)generateColorBlock
{
    ColorBlock *colorBlock = (ColorBlock*)[CCBReader load:@"ColorBlock.ccbi"];
    colorBlock.indexRow = 8;
    colorBlock.indexCollum = 3;
    [self addChild:colorBlock];
    [self changeBlockPosition:colorBlock indexRow:colorBlock.indexRow indexCollum:colorBlock.indexCollum isAnimate:NO];
    self._currentBlock = colorBlock;
    self._isGenerateBlock = NO;
}

-(void)update:(CCTime)delta
{
    if (self._isGenerateBlock)
    {
        [self generateColorBlock];
    }
    
    self._updateStasticCount++;
    if (self._updateStasticCount>60)
    {
        [self moveBlock];
        self._updateStasticCount = 0;
    }
}

-(void)moveBlock
{
    if (self._currentBlock.indexRow>0)
    {
        [self changeBlockPosition:self._currentBlock
                         indexRow:self._currentBlock.indexRow-1
                      indexCollum:self._currentBlock.indexCollum
                        isAnimate:NO];
        
        
    }
    else
    {
        self._isGenerateBlock = YES;
    }
}

@end
