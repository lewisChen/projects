//
//  ColorBlock.h
//  colorEliminate
//
//  Created by mybox_1027@sina.com on 14-6-12.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum : NSUInteger {
    eBlockType_0,
    eBlockType_1,
    eBlockType_2,
} EBlockType;

@interface ColorBlock : CCNode
{
    CCNodeColor *m_backGround;
    EBlockType m_type;
    NSInteger m_indexRow;
    NSInteger m_indexCollum;
}

@property(nonatomic,assign)EBlockType blockType;
@property(nonatomic,assign)NSInteger indexRow;
@property(nonatomic,assign)NSInteger indexCollum;


-(void)setColorBackGround:(CCColor *)color;
-(BOOL)isSameType:(ColorBlock*)colorBlock;

@end
