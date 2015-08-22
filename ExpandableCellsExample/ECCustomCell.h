//
//  ECCustomCell.h
//  ExpandableCellsExample
//
//  Created by Roger Oba on 8/22/15.
//  Copyright © 2015 Roger Oba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *expansionImage;

@end
