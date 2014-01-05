//
//  numberItem.h
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 13-11-29.
//  Copyright 2013年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "../Objects/objectDef/ObjectDef.h"

#define kItemwidth (32.0)
#define kItemHight (32.0)

#define myItemColor ccc3(205, 133, 63)

@interface NumberItem : CCSprite
{
    CCLabelTTF *m_lable;
    unsigned char m_indexX;
    unsigned char m_indexY;
    unsigned char m_labelNmber;
}

@property (readwrite,assign) CCLabelTTF* numberLabel;
@property (readwrite) unsigned char indexX;
@property (readwrite) unsigned char indexY;
@property (readonly) unsigned char labelNumber;

-(void)setItemColor:(ccColor3B) color;

-(id)init;

@end
