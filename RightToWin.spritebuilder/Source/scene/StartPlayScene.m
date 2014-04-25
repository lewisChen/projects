//
//  StartPlayScene.m
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-18.
//

#import "StartPlayScene.h"
#import "../DataHandler/GameDataHandler.h"


@implementation StartPlayScene

-(void)buttonPress:(id)sender
{
    eBlockType blockType = eBlockTypeUnknow;
    
    if (sender==m_buttonType1)
    {
        blockType = eBlockType1;
        CCLOG(@"button1");
    }
    else if(sender==m_buttonType2)
    {
        blockType = eBlockType2;
        CCLOG(@"button2");
    }
    else if(sender==m_buttonType3)
    {
        blockType = eBlockType3;
        CCLOG(@"button3");
    }
    else if(sender==m_buttonType4)
    {
        blockType = eBlockType4;
        CCLOG(@"button4");
    }
    //set select type
    [GameDataHandler sharedGameDataHandler].blockTypeSelect = blockType;
    CCScene *scene = [CCBReader loadAsScene:@"PlayScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];

}

- (void)backPress:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.2]];
    
}


@end






