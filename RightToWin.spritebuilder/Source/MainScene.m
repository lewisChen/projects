//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
-(void)buttonPress:(id)sender
{
    if (sender==m_buttonType1)
    {
        CCLOG(@"button1");
    }
    else if(sender==m_buttonType2)
    {
        CCLOG(@"button2");
    }
    else if(sender==m_buttonType3)
    {
        CCLOG(@"button3");
    }
    else if(sender==m_buttonType4)
    {
        CCLOG(@"button4");
    }
    //set select type
    //[GameDataHandler sharedGameDataHandler].blockTypeSelect = blockType;
    CCScene *scene = [CCBReader loadAsScene:@"StartPlayScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.2]];
    
}

@end
