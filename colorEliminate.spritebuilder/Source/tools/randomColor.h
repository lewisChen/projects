//
//  randomColor.h
//  colorEliminate
//
//  Created by mybox_1027@sina.com on 14-6-12.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#ifndef colorEliminate_randomColor_h
#define colorEliminate_randomColor_h

typedef enum : NSUInteger {
    eColorWhite,
    eColorBlue,
    eColorPink,
    
    eColorMax
} EBlockColor;


inline static CCColor* getRandomColor(void)
{
    NSInteger colorIndex = arc4random()%eColorMax;
    CCColor *colorReturn = nil;
    
    switch (colorIndex)
    {
        case eColorWhite:
            colorReturn = [CCColor colorWithCcColor3b:ccc3(251, 248, 248)];
            break;
            
        case eColorBlue:
            colorReturn = [CCColor colorWithCcColor3b:ccc3(51, 102, 255)];
            break;
            
        case eColorPink:
            colorReturn = [CCColor colorWithCcColor3b:ccc3(247, 135, 135)];
            
        default:
            break;
    }
    
    return colorReturn;
}


#endif
