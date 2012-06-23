//
//  RootViewController.m
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import "RootViewController.h"

#import "Player.h"
#import "RootTableViewCell.h"

#import "GuessFlagViewController.h"

#import "ConfigurationViewController.h"

@implementation RootViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize rootTableViewCell = _rootTableViewCell;

#pragma mark - Defines

#define NUMBER_OF_PLAYERS_AT_RANKING 10

#pragma mark - - - - Local Methods

#pragma mark Configure Cell

- (void)configureCell:(RootTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Player *player = [players objectAtIndex:indexPath.row];
    cell.namePlayerLabel.text = player.name;
    cell.scorePlayerLabel.text = [player.score stringValue];
    cell.placePlayerLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
}

#pragma mark Populating Table View

- (void)retrievePlayersFromDataBase 
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.managedObjectContext];
    
    NSError *error = nil;
    players = [[NSMutableArray alloc] initWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    if (error) {
        NSLog(@"Error - Loading Data");
    }
    
    [request release];
    [self orderPlayers:players];
} 

- (void)orderPlayers:(NSMutableArray *)array;
{
    NSSortDescriptor *sortDescripor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    [array sortUsingDescriptors:[NSArray arrayWithObject:sortDescripor]];
    [sortDescripor release];    
}


#pragma mark Start New Game

- (void)startNewGame
{
    GuessFlagViewController *guessFlagView = [[GuessFlagViewController alloc] initWithNibName:@"GuessFlagViewController" bundle:nil];
    guessFlagView.delegate = self;
    
    Player *newJogador = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:self.managedObjectContext];
    guessFlagView.player = newJogador;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:guessFlagView];
    [self presentModalViewController:navigationController animated:YES];
    
    [navigationController release];
    [guessFlagView release];
}

#pragma mark Configuration Game

- (void)configurationGame
{
    ConfigurationViewController *configurationView = [[[ConfigurationViewController alloc] initWithNibName:@"ConfigurationViewController" bundle:nil]autorelease];
    [configurationView setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentModalViewController:configurationView animated:YES];
}

#pragma mark Delegete

- (void)endGame
{
    [self retrievePlayersFromDataBase];
    [self.tableView reloadData];
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.title = @"Guess the Flag";
    
    UIBarButtonItem *newGameButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleDone target:self action:@selector(startNewGame)];
    self.navigationItem.rightBarButtonItem = newGameButton;
    [newGameButton release];
    
    UIBarButtonItem *configButton = [[UIBarButtonItem alloc] initWithTitle:@"Config" style:UIBarButtonItemStylePlain target:self action:@selector(configurationGame)];
    self.navigationItem.leftBarButtonItem = configButton;
    [configButton release];
    
    [self retrievePlayersFromDataBase];
    
}

#pragma mark - Table View DataSoucer 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([players count] < NUMBER_OF_PLAYERS_AT_RANKING) {
        return [players count];
    }
    return NUMBER_OF_PLAYERS_AT_RANKING;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"RootCell";
    
    RootTableViewCell *cellE = (RootTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cellE == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"RootTableViewCell" owner:self options:nil];
        cellE = self.rootTableViewCell;
        self.rootTableViewCell = nil;
    }
    
    [self configureCell:cellE atIndexPath:indexPath];
    
    return cellE;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleHeader = [[NSString alloc] init];
    if (section == 0) {
        titleHeader = @"Ranking";
    }
    return [titleHeader autorelease];
}

#pragma mark - Life Cycle - End

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.rootTableViewCell = nil;
    players = nil;
}

- (void)dealloc
{
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [_rootTableViewCell release];
    [players release];
    [super dealloc];
}

 

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
        {
	    /*
	     Replace this implementation with code to handle the error appropriately.

	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            [self configureCell:(RootTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
