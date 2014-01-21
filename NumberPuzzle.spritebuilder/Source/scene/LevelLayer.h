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
    CCButton *m_btn1;
    CCButton *m_btn2;
    CCButton *m_btn3;
    CCButton *m_btn4;
    CCButton *m_btn5;
    CCButton *m_btn6;
    CCButton *m_btn7;
    CCButton *m_btn8;
    CCButton *m_btn9;
    NSMutableArray *m_btnArray;
}

@property(readwrite)NSString* currentSelectIndexString;

- (void)initLayer;
- (void)setLevel:(NSUInteger)level;
- (void)selectRightFunction;
- (BOOL)isSectionFinish:(NSUInteger)xIndex :(NSUInteger)yIndex;
- (void)buttonVisblaHandle:(NSString*)itemString;
- (void)levelFinishHandle;

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;


@end
