//
//  GuessFlagViewController.h
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultViewController.h"

@class Player;

@interface GuessFlagViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, ResultViewDelegate>
{
    Player         *_player;
    NSInteger       playerScore;
    
    UIImageView    *_flagImage;
    UIPickerView   *_pickerView;
    
    NSMutableArray *allFlags;               //LISTA TODAS AS BANDEIRAS
    NSMutableArray *flagsForGame;           //LISTA DE BANDEIRAS SELECIONADAS PARA A NOVA PARTIDA
    NSMutableArray *flagsForRound;          //LISTA DE OPCOES DE BANDEIRAS PARA O TURNO 
    NSMutableArray *flagsForRoundToPicker;
    
    NSString       *nameFlagCurrent;
    int             numberRoundsCounter;
    BOOL            valueAnswer;
    
    id<ResultViewDelegate> _delegate;
    
    int             numberRoundsAtNSUser;
}

@property(nonatomic, retain) IBOutlet UIImageView *flagImage;
@property(nonatomic, retain) IBOutlet UIPickerView *pickerView;

@property(nonatomic, retain) Player *player;

@property(nonatomic, retain) id<ResultViewDelegate> delegate;

- (void)setGlobalVariables;
- (void)loadAllFlags;
- (void)loadNewGameFlags;
- (void)loadRound;
- (void)chooseOption;
- (void)showResultAlertView;
- (void)pushResultView;
- (void)getNumberRoundsAtNSUser;

@end

// Flag Images by www.free-country-flags.com/flag_pack.php?id=3