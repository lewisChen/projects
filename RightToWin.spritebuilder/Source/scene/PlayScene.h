//
//  PlayScene.h
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BlockObj.h"


@interface PlayScene : CCNode<CCBAnimationManagerDelegate>
{
    NSMutableArray *m_blockArray;
    CCSprite9Slice *m_scorePanel;
    BlockObj *m_targetItem;
    CCLabelTTF *m_lableRightTapCount;
    CCLabelTTF *m_labelLevel;
    CCLabelTTF *m_labelTime;
    CCSprite9Slice *m_backGround;
    CCSprite *m_spriteArrow;
    eBlockType m_currentBlockType;
}

@property(readwrite,nonatomic) eBlockType currentBlockType;

- (void)placeAllBlock;
- (void)moveBlocks;
//-(NSMutableArray*)getRandomArray:(NSInteger)arraySize;
//- (bool)isNumberInArray:(NSMutableArray*)array :(NSInteger)number;
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)update:(CCTime)delta;
- (void)initSoundEgine;
- (void)increaseLevel:(NSInteger) tapCount;
- (void)completedAnimationSequenceNamed:(NSString*)name;
- (void)playRandomSound;
- (void)showFinishLayer;
- (void)handleModeUiDisplay;

@end
