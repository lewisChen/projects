//
//  numberItem.m
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 13-11-29.
//  Copyright 2013年 Apportable. All rights reserved.
//

#import "numberItem.h"
#import "../UiConstDef/FontRelateDef.h"
#include "CCSprite9Slice.h"

#define kBackgroundTag (1)

@implementation NumberItem

//@synthesize numberLabel = m_lable;
@synthesize indexX = m_indexX;
@synthesize indexY = m_indexY;
@synthesize labelNumber =m_labelNmber;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setContentSize:CGSizeMake(kItemwidth,kItemHight)];
        
        CCSpriteFrameCache *spriteCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        //[spriteCache addSpriteFramesWithFile:@"myRes.plist"];
        [spriteCache addSpriteFramesWithFile:@"myRes.plist" textureFilename:@"myRes.png"];
        
        CCSprite9Slice *itemBackground = [CCSprite9Slice spriteWithImageNamed:@"itemBoxWhite.png" ];//[CCSprite9Slice spriteWithSpriteFrameName:@"itemBoxWhite.png" ];
        [itemBackground setContentSize:[self contentSize]];
        itemBackground.color = [CCColor colorWithCcColor3b:ccc3(205, 133, 63)];
        itemBackground.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:itemBackground z:1];
        //[self addChild:itemBackground z:1 tag:kBackgroundTag];
        
        
        m_lable = [CCLabelTTF labelWithString:@"0" fontName:FontNameNormal fontSize:FontSizeNormal];
        m_labelNmber = m_lable.string.integerValue;
        m_lable.fontColor = [CCColor colorWithCcColor3b:ccBLACK];
        //m_lable.color = ccBLACK;
        m_lable.anchorPoint = ccp(0.5, 0.5);
        m_lable.position = ccp(itemBackground.contentSize.width/2, itemBackground.contentSize.height/2);
        [itemBackground addChild:m_lable];
        
    }
    return self;
}

-(void)setNumberLabel:(CCLabelTTF *)numberLabel
{
    m_lable.string = numberLabel.string;
    m_labelNmber = numberLabel.string.integerValue;
    
}

-(CCLabelTTF*)numberLabel
{
    return m_lable;
}

-(void)setItemColor:(ccColor3B)color
{
//    CCScale9Sprite *sprite = (CCScale9Sprite*)[self getChildByTag:kBackgroundTag];
//    [sprite setColor:color];
}

//-(void)dealloc
//{
////    [m_lable release];
////    [m_lable dealloc];
//    [super dealloc];
//}

@end
