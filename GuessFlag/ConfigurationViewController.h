//
//  ConfigurationViewController.h
//  GuessFlag
//
//  Created by Lucas Torquato on 02/02/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigurationViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UILabel *_numberOfRoundsLabel;
    UIPickerView *_pickerView;
    
    NSMutableArray *roundsNumbers;
    NSInteger numberRow;
}

@property(nonatomic, retain) IBOutlet UILabel *numberOfRoundsLabel;
@property(nonatomic, retain) IBOutlet UIPickerView *pickerView;

@end
