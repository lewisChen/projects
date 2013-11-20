//
//  MainMenuScene.m
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-27.
//
//

#import "MainMenuScene.h"
#import "CCBReader.h"

@implementation MainMenuScene

-(void)pressdPlay:(id)sender
{
    CCScene *gameScene = [CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

@end
