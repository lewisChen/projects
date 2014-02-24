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
#define kEffectZorder (3)
#define kNameBackground (@"itemBackground")
#define kNameFrontSprite (@"kNameFontSprite")
#define kNameEffect (@"kNameEffect")

@interface NumberItem ()

@property BOOL numberVisiable;

@end

@implementation NumberItem

@synthesize indexX = m_indexX;
@synthesize indexY = m_indexY;

inline static NSString* getIcon(enum EItemType type)
{
    NSString *resultString = nil;
    switch (type)
    {
        case eItemType0:
            resultString = @"hide.png";
            break;
        case eItemType1:
            resultString = @"one.png";
            break;
        case eItemType2:
            resultString = @"two.png";
            break;
        case eItemType3:
            resultString = @"three.png";
            break;
        case eItemType4:
            resultString =@"four.png";
            break;
        case eItemType5:
            resultString =@"five.png";
            break;
        case eItemType6:
            resultString =@"six.png";
            break;
        case eItemType7:
            resultString =@"seven.png";
            break;
        case eItemType8:
            resultString = @"eight.png";
            break;
        case eItemType9:
            resultString = @"nine.png";
            break;

        default:
            break;
    }
    return resultString;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setContentSize:CGSizeMake(kItemwidth,kItemHight)];
        
        CCSprite9Slice *itemBackground = [CCSprite9Slice spriteWithImageNamed:@"hide.png" ];//[CCSprite9Slice spriteWithSpriteFrameName:@"itemBoxWhite.png" ];
        [itemBackground setContentSize:[self contentSize]];
        //itemBackground.color = [CCColor colorWithCcColor3b:myItemColor];
        itemBackground.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:itemBackground z:kBackgroundTag name:kNameBackground];
        //[self addChild:itemBackground z:1 tag:kBackgroundTag];
        
        CCSprite9Slice *selectEffect = [CCSprite9Slice spriteWithImageNamed:@"selectEffect.png" ];
        selectEffect.visible = NO;
        [selectEffect setContentSize:CGSizeMake(34,34)];
        selectEffect.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:selectEffect z:kEffectZorder name:kNameEffect];
        
    }
    return self;
}


-(void)setItemColor:(ccColor3B)color
{
    CCSprite9Slice *sprite = (CCSprite9Slice*)[self getChildByName:kNameBackground recursively:YES];
    [sprite setColor:[CCColor colorWithCcColor3b:color]];
}

-(void)setItemSelect:(BOOL)value
{
    CCSprite9Slice *sprite = (CCSprite9Slice*)[self getChildByName:kNameEffect recursively:YES];

    if (sprite)
    {
        sprite.visible = value;
    }
}

-(void)setNumberLabelVisable:(BOOL)isVisable
{
    //m_lable.visible = isVisable;
    _numberVisiable = isVisable;
    if (isVisable)
    {
        [self getChildByName:kNameBackground recursively:YES].visible = NO;
        [self getChildByName:kNameFrontSprite recursively:YES].visible = YES;
    }
    else
    {
        [self getChildByName:kNameBackground recursively:YES].visible = YES;
        [self getChildByName:kNameFrontSprite recursively:YES].visible = NO;
    }
}

-(BOOL)numberLabelVisable
{
    return _numberVisiable;//m_lable.visible;
}

-(void)setItemType:(enum EItemType)type
{
    m_type = type;
    CCSprite9Slice *spriteBackground = (CCSprite9Slice*)[self getChildByName:kNameBackground recursively:YES];
    if (spriteBackground)
    {
        spriteBackground.visible = NO;
    }
    CCSprite9Slice *sprite = [CCSprite9Slice spriteWithImageNamed:getIcon(type)];
    [sprite setContentSize:[self contentSize]];
    //itemBackground.color = [CCColor colorWithCcColor3b:myItemColor];
    sprite.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:sprite z:kBackgroundTag name:kNameFrontSprite];

}

-(enum EItemType)getItemType
{
    return m_type;
}

//-(void)dealloc
//{
////    [m_lable release];
////    [m_lable dealloc];
//    [super dealloc];
//}

@end
