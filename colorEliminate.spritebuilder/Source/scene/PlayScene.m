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
#define kZorderTop (100)
#define kZorderBlock (1)

#define kMaxCollum (5)

@interface PlayScene ()
@property BOOL _isGenerateBlock;
@property ColorBlock *_currentBlock;
@property NSInteger _updateStasticCount;
@end

@implementation PlayScene

@synthesize beginPoint = m_beginPoint;
@synthesize endPoint = m_endPoint;
@synthesize arrayAllBlock = m_arrayAllBlock;
@synthesize isIgnoreTouchMove = m_isIgnoreTouchMove;

- (void) didLoadFromCCB
{
    [self initGroundSizeAndColor];
    [self setUserInteractionEnabled:YES];
    self._isGenerateBlock = YES;
    self._currentBlock = nil;
    self.isIgnoreTouchMove = NO;
    
    m_pauseLayer.zOrder = kZorderTop;
    
    self.arrayAllBlock = [[NSMutableArray alloc] init];
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
            CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.2 position:point];
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
    if (self.isIgnoreTouchMove!=YES)
    {
        if (self.isCanMoveRight)
        {
            CCLOG(@"right");
            [self changeBlockPosition:self._currentBlock indexRow:self._currentBlock.indexRow indexCollum:self._currentBlock.indexCollum+1 isAnimate:NO];

        }
    }
}

-(void)leftMove
{
    if (self.isIgnoreTouchMove!=YES)
    {
        if (self.isCanMoveLeft)
        {
            CCLOG(@"left");
            [self changeBlockPosition:self._currentBlock indexRow:self._currentBlock.indexRow indexCollum:self._currentBlock.indexCollum-1 isAnimate:NO];

        }
    }
}

-(void)downMove
{
    if (self.isIgnoreTouchMove!=YES)
    {
        self.isIgnoreTouchMove = YES;
        CCLOG(@"down");
        [self changeBlockPosition:self._currentBlock indexRow:[self getMinRowWithBlock:self._currentBlock] indexCollum:self._currentBlock.indexCollum isAnimate:YES];

    }
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
    colorBlock.zOrder = kZorderBlock;
    colorBlock.indexRow = 8;
    colorBlock.indexCollum = kMaxCollum/2;
    [self addChild:colorBlock];
    [self changeBlockPosition:colorBlock indexRow:colorBlock.indexRow indexCollum:colorBlock.indexCollum isAnimate:NO];
    self._currentBlock = colorBlock;
    self._isGenerateBlock = NO;
    
    [self.arrayAllBlock addObject:colorBlock];
}

-(void)update:(CCTime)delta
{
    self._updateStasticCount++;
    if (self._updateStasticCount>60)
    {
        [self moveBlock];
        self._updateStasticCount = 0;
    }
    
    self._isGenerateBlock = [self isStartGenerate];
    if (self._isGenerateBlock)
    {
        self.isIgnoreTouchMove = NO;
        [self generateColorBlock];
    }
}

-(void)moveBlock
{
    NSInteger minRow = [self getMinRowWithBlock:self._currentBlock];
    
    if (self._currentBlock.indexRow>minRow)
    {
        
        [self changeBlockPosition:self._currentBlock
                         indexRow:self._currentBlock.indexRow-1
                      indexCollum:self._currentBlock.indexCollum
                        isAnimate:NO];
    }
}

-(NSInteger)getMinRowWithBlock:(ColorBlock *)block
{
    NSInteger result = 0;
    for (ColorBlock *obj in self.arrayAllBlock)
    {
        if (block.indexCollum == obj.indexCollum)
        {
            result = result + 1;
        }
    }
    
    result = result-1;//index is start from 0
    return result;
}

-(BOOL)isStartGenerate
{
    if (self._currentBlock==nil)
    {
        return YES;
    }
    else
    {
        if (self._currentBlock.indexRow == [self getMinRowWithBlock:self._currentBlock])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

-(BOOL)isCanMoveLeft
{
    for (ColorBlock *obj in self.arrayAllBlock)
    {
        if (obj.indexRow == self._currentBlock.indexRow)
        {
            if (obj.indexCollum == (self._currentBlock.indexCollum-1))
            {
                return NO;
            }
        }
    }
    
    if (self._currentBlock.indexCollum==0)
    {
        return NO;
    }
    
    return YES;
}

-(BOOL)isCanMoveRight
{
    for (ColorBlock *obj in self.arrayAllBlock)
    {
        if (obj.indexRow == self._currentBlock.indexRow)
        {
            if (obj.indexCollum==(self._currentBlock.indexCollum+1))
            {
                return NO;
            }
        }
    }
    
    if ((self._currentBlock.indexCollum+1)==kMaxCollum)
    {
        return NO;
    }
    
    return YES;

}

@end
