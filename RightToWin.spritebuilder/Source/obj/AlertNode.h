//
//  AlertNode.h
//  Tap Right Tile to Win
//
//  Created by mybox_1027@sina.com on 14-6-4.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define appId (869242710)

@interface AlertNode : CCNode
{
    CCButton *m_cancelBtn;
    CCButton *m_buttonOk;
    CCSprite9Slice *m_backgound;
}

-(void)actionFinishCall;

@end
