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

@interface NumberItem : CCSprite
{
    CCLabelTTF *m_lable;
    unsigned char m_indexX;
    unsigned char m_indexY;
}

@property (readwrite) CCLabelTTF* numberLabel;
@property (readwrite) unsigned char indexX;
@property (readwrite) unsigned char indexY;


-(id)init;
-

@end
