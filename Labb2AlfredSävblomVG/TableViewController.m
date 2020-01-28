//
//  TableViewController.m
//  Labb2AlfredSävblomVG
//
//  Created by Alfred on 2020-01-20.
//  Copyright © 2020 Alfred. All rights reserved.
//

#import "TableViewController.h"
#import "TodoData.h"

@interface TableViewController ()


@end

@implementation TableViewController
- (IBAction)AddTodo:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Your task" message:@"" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        UITextField *textField = alert.textFields[0];
        
        if(textField.text.length > 0){
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/P
            
            TodoData *todo = [[TodoData alloc] initWithDate:[dateFormatter stringFromDate:[NSDate date]] andTask:textField.text];
            [self.todoTasks insertObject:todo atIndex:0];
            
            [self.tableView reloadData];
            
            [self saveData:self.todoTasks];
            
        }

    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:defaultAction];
                                   
    [alert addAction:cancelAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Task";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.todoTasks = [[NSMutableArray alloc] init];
    
    self.todoTasks = [self loadData];
    
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.todoTasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];

    TodoData *data = self.todoTasks[indexPath.row];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", data.task];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", data.date];
    
    return cell;
}

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{

if (pGesture.state == UIGestureRecognizerStateEnded)
{
    UITableView* tableView = (UITableView*)self.view;
    CGPoint touchPoint = [pGesture locationInView:self.view];
    NSIndexPath* selectedCell = [tableView indexPathForRowAtPoint:touchPoint];
    if (selectedCell != nil) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Task options" message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *prioAction = [UIAlertAction actionWithTitle:@"Prioritize" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            TodoData *d = self.todoTasks[selectedCell.row];
            d.state = priority;
            NSLog(@"%d", d.state);
            [self.todoTasks removeObjectAtIndex:selectedCell.row];
            [self.todoTasks insertObject:d atIndex:0];
            [self.tableView reloadData];
            
            [self saveData:self.todoTasks];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Task done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            TodoData *d = self.todoTasks[selectedCell.row];
            d.state = done;
            NSLog(@"%d", d.state);
            [self.todoTasks removeObjectAtIndex:selectedCell.row];
            [self.todoTasks insertObject:d atIndex:self.todoTasks.count];
            [self.tableView reloadData];
            
            [self saveData:self.todoTasks];
            
        }];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            [self.todoTasks removeObjectAtIndex:selectedCell.row];
            [self.tableView reloadData];
            
            [self saveData:self.todoTasks];
            
            /*UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                NSLog(@"Task done");
                
                [self.todoTasks removeObjectAtIndex:selectedCell.row];
                [self.tableView reloadData];
                
            }];
            
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                NSLog(@"Task done");
                
                [self.todoTasks removeObjectAtIndex:selectedCell.row];
                [self.tableView reloadData];
                
            }];
            
            [alert addAction:okAction];
            [alert addAction:noAction];
            */
        }];
        
        [alert addAction:prioAction];
                                       
        [alert addAction:cancelAction];
        
        [alert addAction:deleteAction];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
}

-(void)saveData:(NSMutableArray*)todoTask{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    for (int i = 0; i < todoTask.count; i++) {
        NSString *key = [NSString stringWithFormat:@"data%d", i];
        
        [dictionary setObject: [TodoData makeDictionary:todoTask[i]] forKey: key];
    }

    //NSLog(@"%lu", (unsigned long)array.count);

    [userDefaults setObject:dictionary forKey:@"todoTasks"];
    [userDefaults synchronize];
}

-(NSMutableArray*)loadData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary = [userDefaults objectForKey:@"todoTasks"];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dictionary.count; i++) {
        NSString *key = [NSString stringWithFormat:@"data%d", i];
        TodoData *todoData = [[TodoData alloc] init];
        todoData = [TodoData makeTodoData:[dictionary objectForKey:key]];
        array[i] = todoData;
    }
    
    return array;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
