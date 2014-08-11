//
//  BABGameBoardViewController.m
//  Bricks & Balls
//
//  Created by Merritt Tidwell on 8/6/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//

#import "BABGameBoardViewController.h"
#import "BABHeaderView.h"
#import "BABLevelData.h"

// make a method that willdrop a uiview (gravity) from a broken brick like a powerup listen for it to collide with paddle

//randomly change the size of paddle when pwerup hit paddle


@interface BABGameBoardViewController ()<UICollisionBehaviorDelegate,UIAlertViewDelegate>
//@property (nonatomic) int scoreNumber;
//@property (nonatomic) int lifeNumber;
@end

@implementation BABGameBoardViewController

{
    UIDynamicAnimator * animator;
    UIView * ball;
    UIGravityBehavior * gravityBehavior;
    UICollisionBehavior * collisionBehavior;
    NSMutableArray * bricks;
    UIDynamicItemBehavior * ballItemBehavior;
    UIDynamicItemBehavior * brickItemBehavior;
    UIView * paddle;
    UIAttachmentBehavior * attachmentBehavior;
    UIButton * startButton;
    UIView * powerUp;
    UICollisionBehavior * powerCBehavior;
    
    
    BABHeaderView * headerView;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    
        headerView = [[BABHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        [self.view addSubview:headerView];
        
        bricks =[@[]mutableCopy];
        
        animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
        
        brickItemBehavior= [[UIDynamicItemBehavior alloc] init];
        
        brickItemBehavior.density= 10000000;
        
        [animator addBehavior:brickItemBehavior];
        ballItemBehavior= [[UIDynamicItemBehavior alloc]init];
        ballItemBehavior.friction = 0;
        ballItemBehavior.elasticity = 1;
        ballItemBehavior.resistance = 0;
        ballItemBehavior.allowsRotation = NO;
        
        [animator addBehavior:ballItemBehavior];
        
        gravityBehavior = [[UIGravityBehavior alloc]init];
        
        [animator addBehavior:gravityBehavior];
        
        collisionBehavior = [[UICollisionBehavior alloc]init];
        
        collisionBehavior.collisionDelegate = self;
        
        
        
        //this creates a boundary around the frame//
        
        //collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        
        [collisionBehavior addBoundaryWithIdentifier:@"floor" fromPoint:CGPointMake(0, SCREEN_HEIGHT+20) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT+20)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"left wall" fromPoint:CGPointMake(0,0) toPoint:CGPointMake( 0,SCREEN_HEIGHT)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"right wall" fromPoint:CGPointMake(SCREEN_WIDTH,0) toPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [collisionBehavior addBoundaryWithIdentifier:@"ceiling" fromPoint:CGPointMake(0,0 ) toPoint:CGPointMake(SCREEN_WIDTH, 0)];
        
        
        
        [animator addBehavior:collisionBehavior];
        
        
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    paddle = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-10, 100, 8)];
    self.view.backgroundColor = [UIColor colorWithRed:0.325f green:0.847f blue:0.843f alpha:1.0f];

    paddle.backgroundColor= [UIColor whiteColor];
    paddle.layer.cornerRadius= 5;
    [self.view addSubview:paddle];
    
    [self displayStartButton];
    
    // Do any additional setup after loading the view.
    
    //    ball = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, SCREEN_HEIGHT-30, 20, 20)];
    //    ball.layer.cornerRadius = ball.frame.size.width/2.0;
    //    ball.backgroundColor = [UIColor magentaColor];
    //    [self.view addSubview:ball];
    
}


-(void)startGame
{
    headerView.lives = 3;
    headerView.score = 0;
    
    [startButton removeFromSuperview];
    [self resetBricks];
    [self restartGame];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:paddle attachedToAnchor:paddle.center];
    
    [animator addBehavior:attachmentBehavior];
    
    //      [ballItemBehavior addItem:ball];
    //    [collisionBehavior addItem:ball];
    [brickItemBehavior addItem:paddle];
    [collisionBehavior addItem:paddle];
    
    
    //    UIPushBehavior * pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];
    //    pushBehavior.pushDirection = CGVectorMake(0.05, -0.05);
    //
    //    [animator addBehavior:pushBehavior];
    
    // [self resetBricks];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if([@"floor" isEqualToString:(NSString *)identifier])
    {
        UIView * ballItem = (UIView *) item;
        
        [collisionBehavior removeItem:ball];
        [ballItem removeFromSuperview];
        headerView.lives -= 1;
        
        ball=nil;
        if(headerView.lives > 0)
            
        {
            [self restartGame];
        }
        
        else if (headerView.lives == 0)
        {
            [self displayStartButton];
        }
    }
    
}

-(void)displayStartButton
{
    
    for (UIView * brick in bricks)
    {   [brick removeFromSuperview];
        [brickItemBehavior removeItem:brick];
        [collisionBehavior removeItem:brick];
    }
    
    [bricks removeAllObjects];
    
    
    startButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2.0, (SCREEN_HEIGHT-175)/2.0, 150, 150)];
    startButton.backgroundColor =[UIColor clearColor];
    startButton.layer.cornerRadius = 75;
    startButton.layer.borderWidth = 2.0;
    
    startButton.layer.borderColor =[UIColor whiteColor].CGColor;
    
    [startButton setTitle:@"Play" forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont fontWithName:@"Avenir-LightOblique" size:38];
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
}





-(void)resetBricks
{
    
    
    int colCount = [[[BABLevelData mainData] levelInfo][@"cols"] intValue];
    int rowCount = [[[BABLevelData mainData] levelInfo][@"rows"] intValue];
    int brickSpacing = 8;
    
    for (int col = 0; col < colCount; col++)
        
    {
        for (int row = 0; row < rowCount; row++)
        {
            float width = (SCREEN_WIDTH -(brickSpacing* (colCount + 1)))/ colCount;
            float height = ((SCREEN_HEIGHT/3) -(brickSpacing* rowCount) )/ rowCount;
            
            float x = brickSpacing + (width + brickSpacing)* col;
            float y = brickSpacing + (height +brickSpacing) * row+30;
            
            UIView *  brick = [[UIView alloc]initWithFrame:CGRectMake(x, y, width   , height)];
            brick.layer.borderWidth = 3;
            brick.layer.borderColor = [UIColor whiteColor].CGColor;
            brick.layer.cornerRadius = 4;
            [bricks addObject:brick];
            [self.view addSubview:brick];
            
            [brickItemBehavior addItem:brick];
            [collisionBehavior addItem:brick];
            
        }
        
    }
}



-(void)restartGame
{
    
    ball = [[UIView alloc]initWithFrame:CGRectMake(paddle.center.x, SCREEN_HEIGHT-30, 20, 20)];
    ball.layer.cornerRadius = ball.frame.size.width/2.0;
    ball.backgroundColor = [UIColor  colorWithRed:0.929f green:0.012f blue:0.529f alpha:1.0f];
    [self.view addSubview:ball];
    
    UIPushBehavior * pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(0.05, -0.05);
    
    
    [ballItemBehavior addItem:ball];
    
    [collisionBehavior addItem:ball];
    [animator addBehavior:pushBehavior];
    
    
}





-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p

{
    for (UIView * brick in [bricks copy])
    {
        if([item1 isEqual:brick] || [item2 isEqual:brick])
        {
            [collisionBehavior removeItem:brick];
            
            [gravityBehavior addItem:brick];
            
            [bricks removeObjectIdenticalTo:brick];
            
            headerView.score += 10;
            
            int random = arc4random_uniform(4);
            
            if (random == 3)
            {
                [self powerUpMethod:(UIView *)brick];
            }
            
            [UIView animateWithDuration:.3 animations:^{
                brick.alpha = 0;
                
                
            }completion:^(BOOL finished){
                
                
                [brick removeFromSuperview];
                
            }];
            
            if (bricks.count == 0)
                
            {
                [collisionBehavior removeItem:ball];
                [ball removeFromSuperview];
                
                [BABLevelData mainData].currentLevel++;
                [self displayStartButton];
            
            }
            
            
        }
        
    }
    
    
}

-(void)powerUpMethod:(UIView *)brick
 {

     powerUp= [[UIView alloc]initWithFrame:CGRectMake(brick.center.x, brick.center.y,20, 20)];
     
     powerUp.backgroundColor= [UIColor blackColor];
     
     powerUp.layer.cornerRadius = 10;
    
     [self.view addSubview:powerUp];
 
     [gravityBehavior addItem:powerUp];
     
     
     

 }

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [self movePaddleWithTouches:touches];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

{
    [self movePaddleWithTouches:touches];
    
    
}

-(void)movePaddleWithTouches: (NSSet *)touches
{
    UITouch * touch = [touches allObjects][0];
    CGPoint location = [touch locationInView:self.view];
    
    float guard = paddle.frame.size.width/ 2.0 + 10;
    float dragX = location.x;
    
    if (dragX < guard)
    {
        
        dragX = guard;
    }
    if(dragX > SCREEN_WIDTH -  guard)
    {
        dragX = SCREEN_WIDTH - guard;
    }
    
    
    attachmentBehavior.anchorPoint = CGPointMake(dragX, paddle.center.y);
    //    paddle.center = CGPointMake(location.x,paddle.center.y);
    
}

-(BOOL)prefersStatusBarHidden{return YES;}

@end
