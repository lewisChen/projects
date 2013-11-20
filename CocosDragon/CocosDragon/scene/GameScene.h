//
//  GameScene.h
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-27.
//
//

#import "CCLayer.h"

@interface GameScene : CCLayer
{
    CCLayer *levelLayer;
    CCLabelTTF *scoreLabel;
    CCNode *level;
    int score;
}

@property (nonatomic,assign)int score;//为了在别的类可以取出分数和设置分数
+(GameScene*)sharedScene;
-(void)handleGameOver;
-(void)handleLevelComplete;

@end
