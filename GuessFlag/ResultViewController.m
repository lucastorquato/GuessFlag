//
//  ResultViewController.m
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import "ResultViewController.h"

#import "Player.h"

@implementation ResultViewController

@synthesize scoreLabel = _scoreLabel;
@synthesize namePlayerTF = _namePlayerTF;
@synthesize player = _player;
@synthesize delegate = _delegate;


#pragma mark - Delegete

-(void)endGame
{
    if([self.namePlayerTF.text isEqualToString:@""]){
        self.player.name = @"Player";
    }else{
        self.player.name = self.namePlayerTF.text;
    }
    
    NSError *error = nil;
	if (![self.player.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}

    [self.delegate endGame];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"End";
    
    UIBarButtonItem *saveGameButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(endGame)];
    self.navigationItem.rightBarButtonItem = saveGameButton;
    [saveGameButton release];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.scoreLabel.text = [self.player.score stringValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scoreLabel = nil;
    self.namePlayerTF = nil;
    self.player = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [_scoreLabel release];
    [_namePlayerTF release];
    [_player release];
    [super dealloc];
}

@end
