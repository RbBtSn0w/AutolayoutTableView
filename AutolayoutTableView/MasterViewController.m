//
//  MasterViewController.m
//  AutolayoutTableView
//
//  Created by Snow Wu on 10/22/15.
//  Copyright © 2015 Tencent Inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "TPDmoe1TableViewCell.h"


@interface MasterViewController ()
@property NSArray *textDatas;
@property NSMutableArray *objects;


@property (nonatomic, strong) UITableViewCell *tpCell;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    
    
    
    UINib *cellNib = [UINib nibWithNibName:@"TPDmoe1TableViewCell" bundle:nil];
    
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TPDmoe1TableViewCell"];
    
    
    
    
    //render by a new instance cell for helper.
    self.tpCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    
    
    
//    CGSize size = [self.tpCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    NSLog(@"viewDidLoad h=%f", size.height);
    
    self.textDatas = @[@"The top label is the title label, I don't know how many lines it will be.",
                       @" I need the title label to display all lines of text.",
                       @"Test haha",
                       @" I also need the other two labels and the small image to be laid out right below the title, however tall it happens to be. ",
                       @"I have set vertical spacing constraints between the labels and small image, as well as a top spacing constraint between the title label and its superview and a bottom spacing constraint between the small image and its superview. The white UIView has no height constraint, so it should stretch vertically to contain its subviews. I have set the number of lines for the title label to 0.",
                       @"How can I make this happen?",
                       @"How can I get the title label to resize to fit the number of lines required by the string? My understanding is that I can't use setFrame methods because I'm using Auto Layout. And I have to use Auto Layout because I need those other views to stay below the title label (hence the constraints)."];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    [self insertStringIndynamicString:[[NSDate date] description] atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


- (void)insertStringIndynamicString:(NSString*)timeString atIndex:(NSUInteger)index{
    
    NSUInteger randomIndex = arc4random() % [self.textDatas count];
    
//    NSLog(@"fetchResult randomIndex %td", randomIndex);
    
    NSString *result = [NSString stringWithFormat:@"%@ by time:%@",self.textDatas[randomIndex], timeString];
    
//    NSLog(@"fetchResult %@", result);
    
    [self.objects insertObject:result atIndex:index];
    

}


//update my custom cell
- (void)configureCell:(TPDmoe1TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    NSString *result = self.objects[indexPath.row];
    
    cell.autolayoutLabel.text = result;

}



#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TPDmoe1TableViewCell *cell = (TPDmoe1TableViewCell*) self.tpCell;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    [cell layoutSubviews];
    
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    
    return 1 + size.height;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count;
    
    count = self.objects.count;
    
//    NSLog(@"numberOfRowsInSection %td", count);

    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TPDmoe1TableViewCell *cell = (TPDmoe1TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TPDmoe1TableViewCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
