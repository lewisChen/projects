//
//  BlockObj.m
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import "BlockObj.h"

#define kTopZorder (5)
#define kNormalZorder (1)

@implementation BlockObj

@synthesize blockType = m_blockType;
@synthesize rowIndex = m_rowIndex;
@synthesize colIndex = m_colIndex;

- (void) didLoadFromCCB
{
    
}

-(void)setType:(eBlockType)type
{
    self.blockType = type;
    switch (type)
    {
        case eBlockType1:
            m_spriteType1.zOrder = kTopZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            break;
        case eBlockType2:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kTopZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            break;
        case eBlockType3:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kTopZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            break;
        case eBlockType4:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kTopZorder;
            m_spriteType5.zOrder = kNormalZorder;
            break;
        case eBlockType5:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kTopZorder;
            break;

        default:
            break;
    }
}

@end
