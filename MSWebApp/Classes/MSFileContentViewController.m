//
//  MSFileContentViewController.m
//  Pods
//
//  Created by Dylan on 2016/9/7.
//
//

#import "MSFileContentViewController.h"

@interface MSFileContentViewController ()

@property ( nonatomic, strong ) NSString *filePath;
@property ( nonatomic, strong ) UIScrollView *scrollView;

@end

@implementation MSFileContentViewController

- (instancetype) initWithFilePath: (NSString *) filePath {
	self = [super init];
	if ( self ) {
		_filePath = filePath;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view addSubview:self.scrollView];
	
	// Get content
	self.title = _filePath.lastPathComponent;
	
	if ( [_filePath hasSuffix:@".png"] || [_filePath hasSuffix:@".jpg"] ) {
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:_filePath];
		if ( image ) {
			UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
			[self.scrollView addSubview:imageView];
			self.scrollView.contentSize = imageView.frame.size;
		}
		return;
	}
	NSString *fileContent = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
	NSArray *array = [fileContent componentsSeparatedByString:@"\n"];
	if ( array ) {
		CGFloat offset = 0;
		for ( NSString * s in array ) {
			UILabel * fileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			fileLabel.font = [UIFont systemFontOfSize:13.];
			fileLabel.textColor = [UIColor darkGrayColor];
			fileLabel.text = s;
			fileLabel.numberOfLines = 0;
			fileLabel.lineBreakMode = NSLineBreakByCharWrapping;
			[self.scrollView addSubview:fileLabel];
			
			CGSize size = [fileLabel sizeThatFits:CGSizeMake(self.view.frame.size.width, MAXFLOAT)];
			fileLabel.frame = CGRectMake(0, offset, size.width, size.height);
			
			_scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(fileLabel.frame));
			offset = CGRectGetMaxY(fileLabel.frame);
		}
	}
}

- (UIScrollView *)scrollView {
	if ( !_scrollView ) {
		_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
		_scrollView.backgroundColor = [UIColor whiteColor];
	}
	return _scrollView;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
