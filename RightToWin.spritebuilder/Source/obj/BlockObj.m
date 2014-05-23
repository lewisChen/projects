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
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockType2:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kTopZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockType3:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kTopZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockType4:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kTopZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockType5:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kTopZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockTypeDisable:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kTopZorder;
            break;


        default:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kTopZorder;
            //[self handleUnknowType];
            break;
    }
}

-(void)setBlockDisable
{
    m_spriteType6.scale = 0;
    m_spriteType1.zOrder = kNormalZorder;
    m_spriteType2.zOrder = kNormalZorder;
    m_spriteType3.zOrder = kNormalZorder;
    m_spriteType4.zOrder = kNormalZorder;
    m_spriteType5.zOrder = kNormalZorder;
    m_spriteType1.visible = NO;
    m_spriteType2.visible = NO;
    m_spriteType3.visible = NO;
    m_spriteType4.visible = NO;
    m_spriteType5.visible = NO;
    
    m_spriteType6.zOrder = kTopZorder;
    
    CCActionCallFunc *actionEndFunction = [CCActionCallFunc actionWithTarget:self selector:@selector(disableActionCall)];
    CCActionScaleBy *actionScale = [CCActionScaleTo actionWithDuration:0.15 scale:1];
    NSArray *actionArray  = @[actionScale,actionEndFunction];
    CCAction *action = [CCActionSequence actionWithArray:actionArray];
    [m_spriteType6 runAction:action];
    
    self.blockType = eBlockTypeDisable;
}

-(void)handleUnknowType
{
    self.blockType = (eBlockType)(arc4random()%eBlockTypeUnknow);
    switch (self.blockType)
    {
        case eBlockType1:
            m_spriteType1.zOrder = kTopZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockType2:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kTopZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockType3:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kTopZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockType4:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kTopZorder;
            m_spriteType5.zOrder = kNormalZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
        case eBlockType5:
            m_spriteType1.zOrder = kNormalZorder;
            m_spriteType2.zOrder = kNormalZorder;
            m_spriteType3.zOrder = kNormalZorder;
            m_spriteType4.zOrder = kNormalZorder;
            m_spriteType5.zOrder = kTopZorder;
            m_spriteType6.zOrder = kNormalZorder;
            break;
            
        default:
            break;
    }
}

-(void)disableActionCall
{
    m_spriteType1.visible = YES;
    m_spriteType2.visible = YES;
    m_spriteType3.visible = YES;
    m_spriteType4.visible = YES;
    m_spriteType5.visible = YES;
}

@end
