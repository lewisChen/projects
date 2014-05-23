//
//  BlockObj.h
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum : NSUInteger
{
    eBlockType1 = 0,
    eBlockType2,
    eBlockType3,
    eBlockType4,
    eBlockType5,
    
    eBlockTypeUnknow,
    eBlockTypeDisable
    
} eBlockType;

@interface BlockObj : CCNode
{
    CCSprite9Slice *m_spriteType1;
    CCSprite9Slice *m_spriteType2;
    CCSprite9Slice *m_spriteType3;
    CCSprite9Slice *m_spriteType4;
    CCSprite9Slice *m_spriteType5;
    CCSprite9Slice *m_spriteType6;
    
    eBlockType m_blockType;
    NSInteger m_rowIndex;
    NSInteger m_colIndex;
}

@property (readwrite,nonatomic) eBlockType blockType;
@property (readwrite,nonatomic) NSInteger rowIndex;
@property (readwrite,nonatomic) NSInteger colIndex;

-(void)setType:(eBlockType)type;
-(void)setBlockDisable;
-(void)handleUnknowType;
-(void)disableActionCall;

@end
