//
//  numberItem.h
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 13-11-29.
//  Copyright 2013年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "../Objects/objectDef/ObjectDef.h"
#import "objectDef/ObjectDef.h"


#define kItemwidth (32.0)
#define kItemHight (32.0)

#define myItemColor ccc3(205, 133, 63)

@interface NumberItem : CCNode
{
    NSUInteger m_indexX;
    NSUInteger m_indexY;
    enum EItemType m_type;
    
    CCSprite *m_spriteOne;
    CCSprite *m_spriteTwo;
    CCSprite *m_spriteThree;
    CCSprite *m_spriteFour;
    CCSprite *m_spriteFive;
    CCSprite *m_spriteSix;
    CCSprite *m_spriteSeven;
    CCSprite *m_spriteEight;
    CCSprite *m_spriteNine;
    CCSprite *m_spriteHide;
    CCSprite *m_spriteSelect;
    
    NSArray *m_arrayNumberSprite;
}

@property (readwrite) NSUInteger indexX;
@property (readwrite) NSUInteger indexY;
@property (readwrite) NSString* currentIndexString;

//-(void)setItemColor:(ccColor3B) color;
-(void)setItemSelect:(BOOL)value;
-(void)setNumberLabelVisable:(BOOL)isVisable;
-(BOOL)numberLabelVisable;
-(void)setItemType:(enum EItemType) type;
-(enum EItemType)getItemType;
//-(id)init;

@end
