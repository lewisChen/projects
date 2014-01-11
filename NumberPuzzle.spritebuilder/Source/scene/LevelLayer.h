//
//  LevelLayer.h
//  NumberPuzzleBeta2
//
//  Created by mybox_1027@sina.com on 13-12-3.
//  Copyright 2013年 mybox_1027@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelLayer:CCControl
{
    
}

- (void)initLayer;
- (void)setLevel:(NSUInteger)level;

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;


@end