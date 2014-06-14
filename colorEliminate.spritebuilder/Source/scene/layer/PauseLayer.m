//
//  PauseLayer.m
//  colorEliminate
//
//  Created by mybox_1027@sina.com on 14-6-11.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "PauseLayer.h"


@implementation PauseLayer

- (void) didLoadFromCCB
{
    [self setUserInteractionEnabled:YES];//set to hold up all touch
}

-(void)buttonResume:(id)sender
{
    CCAction *action = [CCActionMoveTo actionWithDuration:0.5 position:ccp(0.0, 1.0)];
    [self runAction:action];
    
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return;//hold up all touch
}


@end
