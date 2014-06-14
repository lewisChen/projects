//
//  HelpScene.m
//  colorEliminate
//
//  Created by mybox_1027@sina.com on 14-6-12.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "HelpScene.h"


@implementation HelpScene

-(void)buttonBack:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionRight duration:0.2]];

}

@end
