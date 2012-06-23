//
//  GuessFlagViewController.m
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import "GuessFlagViewController.h"

#import "ResultViewController.h"
#import "Player.h"


@implementation GuessFlagViewController

@synthesize flagImage = _flagImage;
@synthesize pickerView = _pickerView;
@synthesize player = _player;
@synthesize delegate = _delegate;

#pragma mark - Defines

#define NUMBER_OF_FLAGS_OPTIONS 4

#pragma mark - - - - Local Methods

#pragma mark Settings

- (void)setGlobalVariables
{
    allFlags = [[NSMutableArray alloc] init];
    flagsForGame = [[NSMutableArray alloc] init];
    flagsForRound = [[NSMutableArray alloc] init];
    flagsForRoundToPicker = [[NSMutableArray alloc] init];
    valueAnswer = NO;
    [self getNumberRoundsAtNSUser];
}

- (void)getNumberRoundsAtNSUser
{   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    numberRoundsAtNSUser = [prefs integerForKey:@"numberRowKey"];
    if (numberRoundsAtNSUser == 0) {
        numberRoundsAtNSUser = 5;
    }
}

#pragma mark Load Flags

- (void)loadAllFlags
{
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"];
    NSArray *onlyPNGs = [dirContents filteredArrayUsingPredicate:fltr];
    
    for (NSString *namePngFile in onlyPNGs){
        [allFlags addObject:namePngFile];
    }
}

- (void)loadNewGameFlags   
{
    for (int i = 0; i < numberRoundsAtNSUser ; i++) {
        
        int randomNumber = arc4random() % [allFlags count];
        
        NSString *nomeImage = [allFlags objectAtIndex:randomNumber];
        [allFlags removeObjectAtIndex:randomNumber];
        [flagsForGame addObject:nomeImage];
    }
}

- (void)loadRound
{
    [self.view addSubview:self.pickerView];
    [self.pickerView reloadAllComponents];
    valueAnswer = NO;
    
    NSString *newFlagName = [[flagsForGame lastObject] retain];
    nameFlagCurrent = newFlagName;
    UIImage *newFlagImage = [UIImage imageNamed:newFlagName];
    self.flagImage.image = newFlagImage;
    [flagsForGame removeLastObject];
    
    NSMutableArray *options = [[NSMutableArray alloc] init];   
    for (int i = 0; i < NUMBER_OF_FLAGS_OPTIONS - 1; i++) {
    
        int randomNumber = arc4random() % [allFlags count];
        
        NSString *nomeImageRandom = [allFlags objectAtIndex:randomNumber];
        [options addObject:nomeImageRandom];
    }
    flagsForRound = options;

    [flagsForRound addObject:nameFlagCurrent];
    
    int randomNumber2 = arc4random() % [flagsForRound count];
    [flagsForRound exchangeObjectAtIndex:NUMBER_OF_FLAGS_OPTIONS - 1 withObjectAtIndex:randomNumber2];
    
    //To Picker
    flagsForRoundToPicker = flagsForRound;
    NSMutableArray *optionsWithoutPNGAnd_ = [[NSMutableArray alloc] init];  
    for (NSString *nameFlagForRound in flagsForRound) {
        NSString *nameFlagWithoutPNG = [nameFlagForRound stringByReplacingOccurrencesOfString:@".png" withString:@""];
        NSString *nameFlagWithoutPNGAnd_ = [nameFlagWithoutPNG stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
        [optionsWithoutPNGAnd_ addObject:nameFlagWithoutPNGAnd_];
    }
    flagsForRoundToPicker = optionsWithoutPNGAnd_;
}

#pragma mark Choose and Alert

- (void)chooseOption
{
    int indexRowSelected = [self.pickerView selectedRowInComponent:0];
    NSString *nameRowSelected = [flagsForRound objectAtIndex:indexRowSelected];
    numberRoundsCounter++;
    
    if ([nameRowSelected isEqualToString:nameFlagCurrent]) {
        playerScore = playerScore + 20;
        self.player.score = [[[NSNumber alloc] initWithInt:playerScore] autorelease];
        valueAnswer = YES;
    }
    [self showResultAlertView];
}

- (void)showResultAlertView
{
    [self.pickerView removeFromSuperview];
    
    NSString *stringTitle = [NSString stringWithFormat:@"Guess the Flag - Round %d", numberRoundsCounter];
    NSString *stringValorResposta = [NSString stringWithFormat:@"You %@", valueAnswer ? @"Hit": @"Miss"];
    NSString *stringCancelButton = [NSString stringWithFormat:@"%@",numberRoundsCounter == numberRoundsAtNSUser ? @"End Game": @"OK"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:stringTitle 
                                                        message:stringValorResposta 
                                                       delegate:self 
                                              cancelButtonTitle:stringCancelButton
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark End Game

- (void)pushResultView
{
    ResultViewController *resultView = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
    resultView.delegate = self;
    
    resultView.player = self.player;
  
    [self.navigationController pushViewController:resultView animated:YES];
    [resultView release];
    
}

#pragma mark Delegate

- (void)endGame
{
    [self.delegate endGame];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (numberRoundsCounter == numberRoundsAtNSUser) {
            [self pushResultView];
        }else{
            [self loadRound];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setGlobalVariables];
    [self loadAllFlags];
    [self loadNewGameFlags];
    [self loadRound];
    
    self.title = @"Guess the Flag";
    
    UIBarButtonItem *okChooseButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(chooseOption)];
    self.navigationItem.rightBarButtonItem = okChooseButton;
    [okChooseButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pickerView = nil;
    self.flagImage = nil;
    self.player = nil;
    allFlags = nil;
    flagsForGame = nil;
    flagsForRound = nil;
    flagsForRoundToPicker = nil;
    nameFlagCurrent = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_flagImage release];
    [_pickerView release];
    [self.player release];
    [allFlags release];
    [flagsForGame release];
    [flagsForRound release];
    [flagsForRoundToPicker release];
    [super dealloc];
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [flagsForRoundToPicker count];
}

#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [flagsForRoundToPicker objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (view == nil){
        label= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        label.textAlignment = UITextAlignmentCenter;       
    }
    label.text = [NSString stringWithFormat:@"%@", [flagsForRoundToPicker objectAtIndex:row]] ;
    return label;
}

@end
