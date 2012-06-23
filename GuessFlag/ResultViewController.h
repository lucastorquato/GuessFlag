//
//  ResultViewController.h
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultViewDelegate <NSObject>
- (void)endGame;
@end

@class Player;

@interface ResultViewController : UIViewController
{
    Player      *_player;
    
    UILabel     *_scoreLabel;
    UITextField *_namePlayerTF;
    
    id<ResultViewDelegate> _delegate;
    
}

@property(nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property(nonatomic, retain) IBOutlet UITextField *namePlayerTF;

@property(nonatomic, retain) Player *player;

@property(nonatomic, retain) id<ResultViewDelegate> delegate;

- (void)endGame;

@end
