//
//  ECTableViewController.m
//  ExpandableCellsExample
//
//  Created by Roger Oba on 8/22/15.
//  Copyright © 2015 Roger Oba. All rights reserved.
//

#import "ECTableViewController.h"
#import "ECCustomCell.h"

static const CGFloat expandedCellHeight = 132.0f;
static const CGFloat collapsedCellHeight = 106.0f;

@interface ECTableViewController () <UITextViewDelegate>

@property (strong,nonatomic) NSArray *names;
@property (strong,nonatomic) NSArray *occupation;


@property (strong,nonatomic) NSMutableDictionary *textViews;
@property (strong,nonatomic) NSMutableArray *expandedIndexPaths;

@end

@implementation ECTableViewController

#pragma mark - Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Expandable Cells Example";
	
	
	
	//Random data
	self.names = @[@"Benjamin",@"Jonathan",@"Alex",@"Donny",@"Adrien",@"Ian",@"James",@"Michael",@"Peter"];
	self.occupation = @[@"Marketer",@"Designer",@"Music Producer",@"iOS Developer",@"Soccer Player",@"Full Stack Developer",@"Basketball Player",@"Artist",@"Artist"];
	
	
	
	//Initializing the properties
	self.expandedIndexPaths = [NSMutableArray array];
	self.textViews = [NSMutableDictionary dictionary];
	
	
	
	
	//Adding observers to keyboard status changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifier = @"customCell";

    ECCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[ECCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}

	[self configureCell:cell inTableView:tableView atIndexPath:indexPath];
    
    return cell;
}


/**
 *  @author Roger Oba
 *
 *  Method that properly configures the table view cell.
 *
 *  @param cell      The cell to be configured
 *  @param tableView The table view where the cell is being displayed on
 *  @param indexPath The index path of the cell that's being configured
 */
- (void)configureCell:(ECCustomCell *)cell inTableView:(UITableView*)tableView atIndexPath:(NSIndexPath *)indexPath {
	
	cell.nameLabel.text = [self.names objectAtIndex:indexPath.row];
	cell.occupationLabel.text = [self.occupation objectAtIndex:indexPath.row];
	cell.profilePicture.image = [UIImage imageNamed:@"randomPicture"];
	
	//Set the delegate of the text view as this view controller,
	//so we can implement the dynamic cell height and cursor focus
	cell.descriptionTextView.delegate = self;
	
	
	//Add each text view as the object for the given indexPath key, so its easier to retrieve each text view when the indexPath is provided
	[self.textViews setObject:cell.descriptionTextView forKey:indexPath];
	
	
	//Setting the correct expansion image
	if ([self.expandedIndexPaths containsObject:indexPath]) {
		cell.expansionImage.image = [UIImage imageNamed:@"minus"];
	}
	else {
		cell.expansionImage.image = [UIImage imageNamed:@"plus"];
	}
}

#pragma mark - UITableView Delegate Methods -

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath	{
	
	ECCustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	//This method makes it possible to change the cell height with animations
	[tableView beginUpdates];
	
	//If the selected cell is already expanded, collapse it.
	if ([self.expandedIndexPaths containsObject:indexPath]) {
		cell.expansionImage.image = [UIImage imageNamed:@"plus"];
		[self.expandedIndexPaths removeObject:indexPath];
		//Also hides keyboard when collapsing a cell.
		[self.view endEditing:YES];
	}
	//Otherwise, expand it.
	else {
		cell.expansionImage.image = [UIImage imageNamed:@"minus"];
		[self.expandedIndexPaths addObject:indexPath];
	}
	
	//Ends animations
	[tableView endUpdates];
}

//The estimated height is required to make it display something while the cells finish loading
- (CGFloat)tableView:(nonnull UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath	{
	
	if ([self.expandedIndexPaths containsObject:indexPath]) {
		return expandedCellHeight;
	}
	else {
		return collapsedCellHeight;
	}
}


//Once the cell finishes loading and calculating its properties, this delegate method sets the correct height for each row
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

	if ([self.expandedIndexPaths containsObject:indexPath]) {
		return [self heightForCellAtIndexPath:indexPath];
	}
	else {
		return collapsedCellHeight;
	}
}

/**
 *  @author Roger Oba
 *
 *  Calculates and returns the height of the cell, based on its text view.
 *
 *  @param indexPath index path of the cell that is being loaded.
 *
 *  @return Returns the height of the cell, based on its text view.
 */
- (CGFloat) heightForCellAtIndexPath:(NSIndexPath*)indexPath {
	UITextView *textView = [self.textViews objectForKey:indexPath];
	return collapsedCellHeight + [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)].height + 8; //`8` is the min space to the next cell.
}

#pragma mark - UITextView Delegate Methods -

- (void) textViewDidChange:(nonnull UITextView *)textView {
	[self.tableView beginUpdates]; // This will cause an animated update of
	[self.tableView endUpdates];   // the height of your UITableViewCell
	
	[self scrollToCursorForTextView:textView]; // OPTIONAL: Follow cursor
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self scrollToCursorForTextView:textView];
}

#pragma mark - Cursor Focus Methods -

/**
 *  Method that scrolls to the cursor while a text view is being edited.
 *
 *  @param textView text view that is being edited.
 
 *  @see http://stackoverflow.com/a/18818036/4075379
 */
- (void)scrollToCursorForTextView: (UITextView*)textView {
	
	CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
	
	cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
	
	if (![self rectVisible:cursorRect]) {
		cursorRect.size.height += 8; // To add some space underneath the cursor
		[self.tableView scrollRectToVisible:cursorRect animated:YES];
	}
}

/**
 *  Method that returns whether the given rect is visible in screen or not.
 *
 *  @param rect Rect to calculate its visiblity
 *
 *  @return return YES if the given rect is visible, or NO otherwise.
 *
 *  @see http://stackoverflow.com/a/18818036/4075379
 */
- (BOOL)rectVisible: (CGRect)rect {
	CGRect visibleRect;
	visibleRect.origin = self.tableView.contentOffset;
	visibleRect.origin.y += self.tableView.contentInset.top;
	visibleRect.size = self.tableView.bounds.size;
	visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
	
	return CGRectContainsRect(visibleRect, rect);
}

#pragma mark - Keyboard Notifications -

/**
 *  @author Roger Oba
 *
 *  Method called when the keyboard will show. Set the table view content inset so the cursor isn't covered by the keyboard.
 *
 *  @param aNotification The notification that tells this observer when the keyboard will be shown.
 */
- (void)keyboardWillShow:(NSNotification*)aNotification {
	NSDictionary* info = [aNotification userInfo];
	CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, keyboardSize.height, 0.0);
	self.tableView.contentInset = contentInsets;
	self.tableView.scrollIndicatorInsets = contentInsets;
}


/**
 *  @author Roger Oba
 *
 *  Method called when the keyboard will hide. It animates the table view when hiding the keyboard.
 *
 *  @param aNotification The notification that tells this observer when the keyboard will be hidden.
 */
- (void)keyboardWillHide:(NSNotification*)aNotification {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.35];
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
	self.tableView.contentInset = contentInsets;
	self.tableView.scrollIndicatorInsets = contentInsets;
	[UIView commitAnimations];
}

@end
