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
            [self.todoTasks addObject:todo];
            
            [self saveData:self.todoTasks];
            
            [self.tableView reloadData];
            
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
    
    self.priorityTasks = [[NSMutableArray alloc] init];
    self.regularTasks = [[NSMutableArray alloc] init];
    self.doneTasks = [[NSMutableArray alloc] init];
    
    self.todoTasks = [self loadData];
    
    [self setUpArrays:self.todoTasks];
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    /*NSString* sectionName;
    
    switch (section) {
        case 0:
            sectionName = @"Priority";
            break;
            
        case 1:
            sectionName = @"Tasks";
            break;
            
        case 2:
            sectionName = @"Tasks done";
            break;
            
        default:
            sectionName = @"";
            break;
    } */
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /*[self setUpArrays:self.todoTasks];
    
    int size = 0;
    
    switch (section) {
        case 0:
            size = (int) self.priorityTasks.count;
            break;
            
        case 1:
            size = (int) self.regularTasks.count;
            break;
        
        case 2:
            size = (int) self.doneTasks.count;
            break;
            
        default:
            size = 0;
            break;
    }*/
    
    return (int) self.todoTasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];
    
    TodoData *todoData = self.todoTasks[indexPath.row];
    
    switch (todoData.state) {
        case priority:
            cell.textLabel.textColor = [UIColor purpleColor];
            cell.detailTextLabel.textColor = [UIColor purpleColor];
            break;
         
        case regular:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            break;
            
         case done:
            cell.textLabel.textColor = [UIColor greenColor];
            cell.detailTextLabel.textColor = [UIColor greenColor];
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = todoData.task;
    cell.detailTextLabel.text = todoData.date;
    
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
            
            [self saveData:self.todoTasks];
            
            [self.tableView reloadData];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Task done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            TodoData *d = self.todoTasks[selectedCell.row];
            d.state = done;
            NSLog(@"%d", d.state);
            [self.todoTasks removeObjectAtIndex:selectedCell.row];
            [self.todoTasks insertObject:d atIndex:self.todoTasks.count];
            
            [self saveData:self.todoTasks];
            
            [self.tableView reloadData];
            
        }];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            [self.todoTasks removeObjectAtIndex:selectedCell.row];
            
            [self saveData:self.todoTasks];
            
            [self.tableView reloadData];
            
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

-(void)setUpArrays:(NSMutableArray*)todoTask{
    
    [self.priorityTasks removeAllObjects];
    [self.regularTasks removeAllObjects];
    [self.doneTasks removeAllObjects];
    
    for (int i = 0; i < todoTask.count; i++) {
        
        TodoData *data = todoTask[i];
        
        switch (data.state) {
            case priority:
                [self.priorityTasks addObject:data];
                break;
                
            case regular:
                [self.regularTasks addObject:data];
                break;
                
            case done:
                [self.doneTasks addObject:data];
                break;
                
            default:
                break;
        }
    }
    
    NSLog(@"%d, %d, %d,", (int) self.priorityTasks.count, (int) self.regularTasks.count, (int) self.doneTasks.count);
    
}

-(void)saveData:(NSMutableArray*)todoTask{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    for (int i = 0; i < todoTask.count; i++) {
        NSString *key = [NSString stringWithFormat:@"data%d", i];
        
        [dictionary setObject: [TodoData makeDictionary:todoTask[i]] forKey: key];
    }

    [userDefaults setObject:dictionary forKey:@"todoTasks"];
    NSLog(@"%lu", (unsigned long)dictionary.count);
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
