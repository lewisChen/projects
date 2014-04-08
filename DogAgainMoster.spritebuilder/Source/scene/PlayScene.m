//
//  PlayScene.m
//  DogAgainMoster
//
//  Created by mybox_1027@sina.com on 14-3-30.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "PlayScene.h"
#import "../libs/cocos2d-iphone/cocos2d/CCDrawingPrimitives.h"

@interface PlayScene ()
@property NSInteger updateCount;
@property BOOL isStarControlBall;
@property CGPoint forceLine;
@end

@implementation PlayScene

@synthesize aimPoint = m_pointAim;
@synthesize startPosition = m_startPosition;

- (void) didLoadFromCCB
{
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    //[[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    //m_spriteBall.physicsNode.debugDraw = YES;
    
    m_mouseJointNode.physicsBody.collisionMask = @[];
    m_objLeftPin.physicsBody.collisionMask = @[];
    m_objRightPin.physicsBody.collisionMask =@[];
    
    self.startPosition = m_spriteBall.position;
    m_background.zOrder = -1;
    
    //[self initWeapon];
}


-(void)backButton:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)releaseJoint
{
    if (m_mouseJoint != nil)
    {
        // releases the joint and lets the catapult snap back
        [m_mouseJoint invalidate];
        m_mouseJoint = nil;
    }
}

-(void)initWeapon
{
   
    
    m_jointLeft = [CCPhysicsJoint connectedDistanceJointWithBodyA:m_objLeftPin.physicsBody
                                                            bodyB:m_spriteBall.physicsBody
                                                            anchorA:m_objLeftPin.anchorPointInPoints
                                                            anchorB:m_spriteBall.anchorPointInPoints
                                                            minDistance:0.0
                                                            maxDistance:103];
    
    m_jointRight = [CCPhysicsJoint connectedDistanceJointWithBodyA:m_objRightPin.physicsBody
                                                             bodyB:m_spriteBall.physicsBody
                                                             anchorA:m_objRightPin.anchorPointInPoints
                                                             anchorB:m_spriteBall.anchorPointInPoints
                                                             minDistance:0.0
                                                             maxDistance:103];
    
}

-(void)resetWeapon
{
    m_spriteBall.physicsBody.velocity = ccp(0.0, 0.0);
    m_spriteBall.position = self.startPosition;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPos = [touch locationInNode:self];
    
    self.aimPoint = touchPos;
    
    if (CGRectContainsPoint([m_spriteBall boundingBox], touchPos))
    {
        m_mouseJointNode.position = touchPos;
        m_spriteBall.position = touchPos;
//        m_mouseJoint = [CCPhysicsJoint connectedDistanceJointWithBodyA:m_mouseJointNode.physicsBody
//                                                                 bodyB:m_spriteBall.physicsBody
//                                                                 anchorA:m_mouseJointNode.anchorPointInPoints
//                                                                anchorB:m_spriteBall.anchorPointInPoints
//                                                                minDistance:0.f maxDistance:0.f];
        
//        m_mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:m_mouseJointNode.physicsBody
//                                                               bodyB:m_spriteBall.physicsBody
//                                                               anchorA:m_mouseJointNode.anchorPointInPoints
//                                                               anchorB:m_spriteBall.anchorPointInPoints
//                                                               restLength:20
//                                                               stiffness:3000.f
//                                                               damping:150.f];
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    
    if (CGRectContainsPoint([m_spriteBall boundingBox], touchLocation))
    {
        float distance=ccpDistance(touchLocation,self.startPosition);
        float cos=(touchLocation.x-self.startPosition.x)/distance;
        float sin=(touchLocation.y-self.startPosition.y)/distance;
        self.forceLine= ccp(-2.f*distance*cos,-2.f*distance*sin);
        
        
        self.aimPoint = touchLocation;
        m_mouseJointNode.position = touchLocation;
        m_spriteBall.position = touchLocation;
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    self.forceLine = ccp(0.0, 0.0);
    if (CGRectContainsPoint([m_spriteBall boundingBox], touchLocation))
    {
        if (m_spriteBall.position.y<self.startPosition.y)
        {
            float distance=ccpDistance(touchLocation,self.startPosition);
            float cos=(touchLocation.x-self.startPosition.x)/distance;
            float sin=(touchLocation.y-self.startPosition.y)/distance;
            CGPoint force = ccp(-5.5f*distance*cos,-5.5f*distance*sin);
            
            [[m_spriteBall physicsBody] applyForce:ccp(force.x, force.y)];
            self.isStarControlBall = YES;

        }
        else if(m_spriteBall.position.y>self.startPosition.y)
        {
            m_spriteBall.position = self.startPosition;
        }
       
    }
    
    [self releaseJoint];
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self releaseJoint];
}

-(void)drawLine
{
    if (m_spriteBall.position.y<(self.startPosition.y+m_spriteBall.contentSize.height/2))
    {
        CHECK_GL_ERROR_DEBUG();
        
        glLineWidth( 5.0f );
        //设置后面要进行绘制时所用的色彩
        ccDrawColor4B(255,255,255,80);
        ccDrawLine(m_spriteBall.position,m_objLeftPin.position);
        ccDrawLine(m_spriteBall.position,m_objRightPin.position);
        
        ccDrawColor4B(255,0,0,80);
        ccDrawLine(m_spriteBall.position,ccp(m_spriteBall.position.x+self.forceLine.x, m_spriteBall.position.y+self.forceLine.y));

        CHECK_GL_ERROR_DEBUG();

    }
}

-(void)draw
{
    [super draw];
    [self drawLine];
    if (m_spriteBall.position.y<=0)
    {
        m_spriteBall.physicsBody.velocity = ccp(0.0, 0.0);
        m_spriteBall.position = self.startPosition;//ccp(m_spriteBall.position.x, m_spriteBall.position.y+m_spriteBall.contentSize.height/2);
    }
}

-(void)update:(CCTime)delta
{
    self.updateCount = self.updateCount+1;
    if ((self.updateCount>300)&&self.isStarControlBall)
    {
        [self resetWeapon];
        self.isStarControlBall = NO;
        self.updateCount = 0;
    }
}

@end
