//
//  ConfigurationViewController.m
//  GuessFlag
//
//  Created by Lucas Torquato on 02/02/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import "ConfigurationViewController.h"

@implementation ConfigurationViewController

@synthesize numberOfRoundsLabel = _numberOfRoundsLabel;
@synthesize pickerView = _pickerView;

#pragma mark - Defines

#define MINIMUM_ROUND 5
#define MAXIMUM_ROUND 15

#pragma mark - Save and Get Number of Rounds

- (void)saveCurrentNumberRound
{
    int indexRowSelecionado = [self.pickerView selectedRowInComponent:0];
    NSString *nomeRowSelecionado = [roundsNumbers objectAtIndex:indexRowSelecionado];
    numberRow = [nomeRowSelecionado intValue];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:numberRow forKey:@"numberRowKey"];
    [prefs synchronize];
}

- (void)getNumberRowAtNSUser
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    numberRow = [prefs integerForKey:@"numberRowKey"];
    
    if (numberRow != 0) {
       [self.pickerView selectRow:numberRow - MINIMUM_ROUND inComponent:0 animated:NO]; 
    }

    self.numberOfRoundsLabel.text = [NSString stringWithFormat:@"%d",numberRow];
    if (numberRow == 0) {
        self.numberOfRoundsLabel.text = @"5";
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    roundsNumbers = [[NSMutableArray alloc] init];
    
    for (int i = MINIMUM_ROUND; i < MAXIMUM_ROUND + 1; i++) {
        NSString *round = [NSString stringWithFormat:@"%d",i];
        [roundsNumbers addObject:round];
    }
 
    [self getNumberRowAtNSUser];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.numberOfRoundsLabel = nil;
    self.pickerView = nil;
    roundsNumbers = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self saveCurrentNumberRound];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Picker View DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [roundsNumbers count];
}

#pragma mark - Picker View Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [roundsNumbers objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.numberOfRoundsLabel.text = [roundsNumbers objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (view == nil){
        label= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        label.textAlignment = UITextAlignmentCenter;       
    }
    label.text = [NSString stringWithFormat:@"%@", [roundsNumbers objectAtIndex:row]];
    return label;
}

- (void)dealloc
{
    [_pickerView release];
    [_numberOfRoundsLabel release];
    [roundsNumbers release];
    [super dealloc];
}

@end
