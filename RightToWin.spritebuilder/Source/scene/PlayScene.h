//
//  PlayScene.h
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayScene : CCNode
{
    NSMutableArray *m_blockArray;
}

- (void)placeAllBlock;
- (void)moveBlocks;
-(NSMutableArray*)getRandomArray:(NSInteger)arraySize;
- (bool)isNumberInArray:(NSMutableArray*)array :(NSInteger)number;
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)update:(CCTime)delta;


@end
