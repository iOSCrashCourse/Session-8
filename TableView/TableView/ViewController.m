//
//  ViewController.m
//  TableView
//
//  Created by Janum Trivedi on 2/26/15.
//  Copyright (c) 2015 Janum Trivedi. All rights reserved.
//

#import "ViewController.h"
#import "Item.h"
#import "ItemTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set our current view controller as the delegate of our table view
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    
    // Initialize our items array
    self.items = [[NSMutableArray alloc] init];
    
    // Set the navigation bar title
    self.title = @"Todo List";
    
    
    // Unarchive and load our items, then call reloadData
    [self loadItems];
    
    [self.tableView reloadData];
}


// Return a filePath (i.e., where we want to store our plist file)
- (NSString *)filePath
{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documents = [directories firstObject];
    NSString* filePath = [documents stringByAppendingPathComponent:@"items.plist"];
    return filePath;
}


- (void)loadItems
{
    NSString* filePath = [self filePath];
    
    // Check if NSKeyedUnarchiver returns a nil value
    if ([NSKeyedUnarchiver unarchiveObjectWithFile:filePath]) {

        // If not, the file exists. Set self.items to the archived array
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    else {
        
        // The file does not exist, so just init a new array
        self.items = [[NSMutableArray alloc] init];
    }
}


- (void)persistItems
{
    // Archieve the items array to a filePath
    [NSKeyedArchiver archiveRootObject:self.items toFile:[self filePath]];
}

- (IBAction)addNewItem:(id)sender
{
    NSString* itemName = [[self itemTextField] text];
    
    Item* newItem = [[Item alloc] initWithTitle:itemName dateCreated:[NSDate date]];
    
    // Add the new item
    [[self items] addObject:newItem];
    
    // Clear the text field
    [[self itemTextField] setText:@""];
    
    // Because we changed our tableView data set, we have to tell it to reload/refresh
    [[self tableView] reloadData];
    
    // Finally, hide the keyboard (which is the UITextField's firstResponder)
    [[self itemTextField] resignFirstResponder];
    
    // Call persistItems again to save our changes
    [self persistItems];
}

// Returns a UITableViewCell for our tableView for row index indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     This asks the table view if it has any cells that are not in use (i.e., created earlier 
     but are now offscreen). If there is, our table view will re-use that cell.
     Our cellIdentifier is some NSString that identifies which cells we can re-use.
     */
    ItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // If the cell is nil, then there wasn't a cell available for re-use.
    if (! cell) {
        /*
         Initialize our ItemTableViewCell (subclass of UITableViewCell). Because ItemTableViewCell is a custom cell, we must load the .xib (Nib) file that contains our cell, using [NSBundle mainBundle] loadNibNamed]. This method returns an array, so we are interested in the first (and only) object in the file– our custom cell view.
         */
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemTableViewCell" owner:self options:nil] firstObject];
    }
    
    // We want to be alerted when the checkmark box is tapped, but we cannot use an IBAction. So, we can add a UIGestureRecongizer (UITapGestureRecognizer specifically) to call a function, toggleCompleted, when it is tapped. Note the : in "toggleCompleted:", this indicates to the compiler that this method takes in one parameter.
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCompleted:)];
    [[cell checkmarkBox] addGestureRecognizer:tapRecognizer];
    
    Item* item = [[self items] objectAtIndex:indexPath.row];
    NSString* itemName = [item itemTitle];

    [[cell itemTitle] setText:itemName];
    
    // Get the item's NSDate that represents when the item was created
    NSDate* dateCreated = [item dateCreated];
    
    // Format the NSDate to a human-readable string
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSString* dateString = [formatter stringFromDate:dateCreated];
    
    // Set the cell's date label to the date string
    [[cell itemDateCreated] setText:dateString];
    
    // If the item's completed property is YES/true, use UIView's alpha property to fade the cell out.
    if ([item completed]) {
        [[cell checkmarkBox] setAlpha:0.5];
        [[cell itemTitle] setAlpha:0.5];
        [[cell itemDateCreated] setAlpha:0.5];
    }
    else {
        [[cell checkmarkBox] setAlpha:1];
        [[cell itemTitle] setAlpha:1];
        [[cell itemDateCreated] setAlpha:1];
    }
    
    // Return our UITableViewCell to our table view.
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self items] count];
}

// Toggle completed is called when the UITapGestureRecognizer that we added to the checkmark box is tapped. The sender argument (of type "id") is actually of type UITapGestureRecognizer
- (void)toggleCompleted:(id)sender
{
    NSLog(@"Tapped!");
    
    // We can get the tap location
    CGPoint tapLocation = [sender locationInView:self.tableView];
    
    // Then ask our tableView what cell index is at the tap location
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    // Get the item at that index
    Item* selectedItem = [self.items objectAtIndex:indexPath.row];
    
    // Set it's completed property to the opposite value (i.e., YES -> NO, NO -> YES)
    [selectedItem setCompleted: ![selectedItem completed]];
    
    // Reload the tableView because we are changing its data set.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
