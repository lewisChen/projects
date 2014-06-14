//
//  ColorBlock.m
//  colorEliminate
//
//  Created by mybox_1027@sina.com on 14-6-12.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "ColorBlock.h"
#import "../tools/randomColor.h"

@implementation ColorBlock

@synthesize blockType = m_type;
@synthesize indexRow = m_indexRow;
@synthesize indexCollum = m_indexCollum;


- (void) didLoadFromCCB
{
    [self setColorBackGround:getRandomColor()];
}


-(void)setColorBackGround:(CCColor *)color
{
    m_backGround.color = color;
}

-(BOOL)isSameType:(ColorBlock *)colorBlock
{
    if (self.blockType == colorBlock.blockType)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
