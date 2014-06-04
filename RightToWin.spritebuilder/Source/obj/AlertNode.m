//
//  AlertNode.m
//  Tap Right Tile to Win
//
//  Created by mybox_1027@sina.com on 14-6-4.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "AlertNode.h"
#import "../DataHandler/GameDataHandler.h"


@implementation AlertNode

-(void)buttonPress:(id)sender
{
    CCActionCallFunc* callFunc = [CCActionCallFunc actionWithTarget:self selector:@selector(actionFinishCall)];
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.5 position:ccp(self.position.x, -m_backgound.contentSize.height)];
    NSArray *actionArray = @[actionMove,callFunc];
    CCActionSequence *actions = [CCActionSequence actionWithArray:actionArray];


    GameDataHandler *dataHandler =  [GameDataHandler sharedGameDataHandler];

    if (m_buttonOk == sender)
    {
        [dataHandler setIsRate];

        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if(m_cancelBtn == sender)
    {
        [dataHandler resetEnterTime];
    }
    
    [self runAction:actions];
}

-(void)actionFinishCall
{
    [self removeFromParent];
}

@end
