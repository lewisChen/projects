//
//  FinishScene.h
//  Tap Right Tile to Win
//
//  Created by mybox_1027@sina.com on 14-4-28.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "../obj/BlockObj.h"

@interface FinishScene : CCNode
{
    CCLabelTTF *m_labelTime;
    CCLabelTTF *m_lableCrazy;
    CCLabelTTF *m_lableCount;
    CCLabelTTF *m_labelTapCount;
    BlockObj *m_blockObj;
    
    CCButton *m_buttonRetry;
    CCButton *m_buttonBack;
    
    CCSprite9Slice *m_background;
}

-(void)sumitScore;
-(void)setBackgroundRandomColor;
-(void)showAlertView;

@end
