//
//  GameScene.m
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-27.
//
//

#import "GameScene.h"
#import "CCBReader.h"

static GameScene *sharedScene;

@implementation GameScene

@synthesize score;

+(GameScene*)sharedScene
{
    return sharedScene;
}

-(void)didLoadFromCCB
{
    sharedScene = self;
    self.score = 0;
    
    
    level = [CCBReader nodeGraphFromFile:@"level.ccbi"];
    [levelLayer addChild:level];
}

-(void)setScore:(int)value
{
    score = value;
    [scoreLabel setString:[NSString stringWithFormat:@"%d",value]];
}

-(void)handleGameOver
{
    [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"]];
}
-(void)handleLevelComplete
{
    [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"]];
}
@end
