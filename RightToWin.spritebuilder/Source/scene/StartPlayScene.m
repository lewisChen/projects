//
//  StartPlayScene.m
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import "StartPlayScene.h"


@implementation StartPlayScene

-(void)buttonPress:(id)sender
{
    if (sender==m_buttonType1)
    {
        CCLOG(@"button1");
        CCScene *scene = [CCBReader loadAsScene:@"PlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:1]];
    }
    else if(sender==m_buttonType2)
    {
        CCLOG(@"button2");
        CCScene *scene = [CCBReader loadAsScene:@"PlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:1]];

    }
    else if(sender==m_buttonType3)
    {
        CCLOG(@"button3");
        CCScene *scene = [CCBReader loadAsScene:@"PlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:1]];

    }
    else if(sender==m_buttonType4)
    {
        CCLOG(@"button4");
        CCScene *scene = [CCBReader loadAsScene:@"PlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:1]];
    }
}

@end






