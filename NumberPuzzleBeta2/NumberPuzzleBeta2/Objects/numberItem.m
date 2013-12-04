//
//  numberItem.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 13-11-29.
//  Copyright 2013年 Apportable. All rights reserved.
//

#import "numberItem.h"
#import "../UiConstDef/FontRelateDef.h"
#include "CCScale9Sprite.h"


@implementation NumberItem

@synthesize numberLabel = m_lable;
@synthesize indexX = m_indexX;
@synthesize indexY = m_indexY;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setContentSize:CGSizeMake(32.0, 32.0)];
        
        CCSpriteFrameCache *spriteCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        //[spriteCache addSpriteFramesWithFile:@"myRes.plist"];
        [spriteCache addSpriteFramesWithFile:@"myRes.plist" textureFilename:@"myRes.png"];
        
        CCScale9Sprite *itemBackground = [CCScale9Sprite spriteWithSpriteFrameName:@"itemBoxWhite.png" ];
        [itemBackground setContentSize:[self contentSize]];
        itemBackground.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:itemBackground];
        
        
        m_lable = [CCLabelTTF labelWithString:@"0" fontName:FontNameNormal fontSize:FontSizeNormal];
        m_lable.color = ccBLACK;
        m_lable.anchorPoint = ccp(0.5, 0.5);
        m_lable.position = ccp(itemBackground.contentSize.width/2, itemBackground.contentSize.height/2);
        [itemBackground addChild:m_lable];
    }
    return self;
}
@end
