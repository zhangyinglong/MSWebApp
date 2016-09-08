//
//  MSFileBrowserTableViewController.m
//  Pods
//
//  Created by Dylan on 2016/9/7.
//
//

#import "MSFileBrowserTableViewController.h"
#import "MSWebAppUtil.h"
#import "MSFileContentViewController.h"

#define kMSFileType @"fileType"
#define kMSFileName @"fileName"
#define kMSFileHasSub @"fileHasSubFolder"
#define kMSFilePath @"fileFullPath"

@interface MSFileBrowserTableViewController ()

@property ( nonatomic, strong ) NSMutableArray * fileArray;
@property ( nonatomic, strong ) NSString * path;

@end

@implementation MSFileBrowserTableViewController

- (instancetype) initWithFolderPath: (NSString *) folderPath {
    self = [super initWithStyle:UITableViewStylePlain];
    _fileArray = [NSMutableArray arrayWithCapacity:1];
    if ( self ) {
        _path = folderPath;
        if ( ![_path hasSuffix:@"/"] ) {
            _path = [_path stringByAppendingString:@"/"];
        }
        BOOL foldered;
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:_path isDirectory:&foldered] ) {
            MSLog(@"%@ IS NOT FOLDER! ", _path);
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _path.lastPathComponent ?: @"File browser!";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 50;
    [self enumFiles];
}

- (void) enumFiles {
    NSArray *subPaths =[[NSFileManager defaultManager] subpathsAtPath:_path];
    
    for ( NSString *path in subPaths ) {
        NSString *fullPath = [_path stringByAppendingString:path];
        NSDirectoryEnumerator * enuma = [[NSFileManager defaultManager] enumeratorAtPath:fullPath];
        if ( ![path containsString:@"/"] ) {
            
            NSDictionary * properties = enuma.fileAttributes?: enuma.directoryAttributes;
            NSDictionary *fileInfo
            = @{
                kMSFileType: properties[NSFileType]?:@"",
                kMSFileName: path,
                kMSFileHasSub: @([[NSFileManager defaultManager] subpathsAtPath:fullPath].count),
                kMSFilePath: fullPath
                };
            [_fileArray addObject:fileInfo];
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ms_file_browser"];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ms_file_browser"];
    }
    
    NSDictionary *fileInfo = _fileArray[indexPath.row];
    cell.textLabel.text = fileInfo[kMSFileName];
    
    NSNumber *subFileNumber = fileInfo[kMSFileHasSub];
    if ( subFileNumber.integerValue != 0 ) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *fileType  = fileInfo[kMSFileType];
    UIImage * typeImage = [UIImage imageNamed:@"other"];
    
    if ( [fileType isEqualToString:NSFileTypeDirectory] ) {
        typeImage = [UIImage imageNamed:@"folder_blue"];
    } else {
        if ( [fileInfo[kMSFilePath] hasSuffix:@".css"] ) {
            typeImage = [UIImage imageNamed:@"css"];
        }
        if ( [fileInfo[kMSFilePath] hasSuffix:@".html"] ) {
            typeImage = [UIImage imageNamed:@"html"];
        }
        if ( [fileInfo[kMSFilePath] hasSuffix:@".js"] ) {
            typeImage = [UIImage imageNamed:@"js"];
        }
    }
    cell.imageView.image = typeImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *fileInfo = _fileArray[indexPath.row];
    NSString *fileType = fileInfo[kMSFileType];
    if ( [fileType isEqualToString:NSFileTypeDirectory] ) {
        MSFileBrowserTableViewController *browser = [[MSFileBrowserTableViewController alloc] initWithFolderPath:fileInfo[kMSFilePath]];
        [self.navigationController pushViewController:browser animated:YES];
    } else {
        // Open file.
        MSFileContentViewController * fileContent = [[MSFileContentViewController alloc] initWithFilePath:fileInfo[kMSFilePath]];
        [self.navigationController pushViewController:fileContent animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *fileInfo = _fileArray[indexPath.row];
        NSString *filePath = fileInfo[kMSFilePath];
        if ( [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil] ) {
            [_fileArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            MSLog(@"%@", @"Remove item with error!");
        }
    }
}

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
