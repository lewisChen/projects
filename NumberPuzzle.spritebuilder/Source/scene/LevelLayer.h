//
//  LevelLayer.h
//  NumberPuzzleBeta2
//
//  Created by mybox_1027@sina.com on 13-12-3.
//  Copyright 2013年 mybox_1027@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "../Objects/objectDef/ObjectDef.h"

@interface LevelLayer:CCScene
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
    CCLabelTTF *m_labelTime;
    CCLabelTTF *m_lableLevel;
    CCLabelTTF *m_lableError;
    NSMutableArray *m_btnArray;
    CCLabelTTF *m_errorTips;

}

@property(readwrite)NSString* currentSelectIndexString;
@property(nonatomic,readwrite) CCLabelTTF* errorTips;

- (void)initLayer;
- (void)setGameLevel:(NSUInteger)level;
- (void)selectRightFunction;
- (void)matchRightFunctionCall;
- (BOOL)isSectionFinish:(NSUInteger)xIndex :(NSUInteger)yIndex;
- (void)buttonVisblaHandle:(enum EItemType)itemTpye;//(NSString*)itemString;
- (void)levelFinishHandle;
- (void)initSoundEgine;
- (void)showFinishLayer;
- (void)setResultWin:(BOOL)result;

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)draw;


@end
