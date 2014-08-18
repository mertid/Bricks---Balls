//
//  BABHeaderView.m
//  Bricks & Balls
//
//  Created by Merritt Tidwell on 8/7/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//

#import "BABHeaderView.h"
#import"BABLevelData.h"
@implementation BABHeaderView
{
    UILabel * scoreLabel;
    UIView * ballHolder;

    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
   
        
        
        scoreLabel= [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-200, 0,190, 40)];
        
        scoreLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:scoreLabel];
        
        
        ballHolder= [[UIView alloc]initWithFrame:CGRectMake(0,0,200,40)];
        [self addSubview:ballHolder];

        self.lives = 3;
        self.score = 0;
    
    
    }
    return self;
}

-(void)setLives:(int)lives
{
    _lives = lives;
    
    for (UIView * lifeBall in ballHolder.subviews)
    {
    
        [lifeBall removeFromSuperview];
    }
    
    
    for (int i = 0; i < lives; i++)
    
    {
        UIView * lifeBall = [[UIView alloc]initWithFrame:CGRectMake(10+30 *i, 10, 20, 20)];
        
        lifeBall.backgroundColor = [UIColor  colorWithRed:0.929f green:0.012f blue:0.529f alpha:1.0f];
        lifeBall.layer.cornerRadius = 10;
        [ballHolder addSubview:lifeBall];
        
    }
}

//Overriding the setter for your score property
-(void)setScore:(int)score
{
    _score = score;
    
    if([BABLevelData mainData].topScore < score) [BABLevelData mainData].topScore = score;
    
    
    
    
    
    scoreLabel.text = [NSString stringWithFormat:@"Score: %d",score];
    scoreLabel.textColor =[UIColor lightGrayColor];
    scoreLabel.font = [UIFont fontWithName:@"Avenir" size:16];
}

@end
