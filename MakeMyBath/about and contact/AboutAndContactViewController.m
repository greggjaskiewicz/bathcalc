//
//  AboutAndContactViewController.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 26/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "AboutAndContactViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>

@interface AboutAndContactViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionInfo;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterfeedbackButton;
@property (weak, nonatomic) IBOutlet UIView *aboutLittleBackground;

@end


@implementation AboutAndContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setVersionInformationLabel];
  
  [self.feedbackButton        setEnabled:[MFMailComposeViewController canSendMail]];
  [self.twitterfeedbackButton setEnabled:[TWTweetComposeViewController canSendTweet]];
  
  self.aboutLittleBackground.layer.cornerRadius = 6.5f;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


- (void)viewDidUnload
{
  [self setVersionInfo:nil];
  [self setFeedbackButton:nil];
  [self setAboutLittleBackground:nil];
  [super viewDidUnload];
}


- (void)setVersionInformationLabel
{
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  NSString *name = infoDictionary[@"CFBundleDisplayName"];
  NSString *version = infoDictionary[@"CFBundleShortVersionString"];
  NSString *build = infoDictionary[@"CFBundleVersion"];
  NSString *ads = @"";
  
  
  NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@) %@",name,version,build, ads];
  
  self.versionInfo.text = label;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
  if (result == MFMailComposeResultSent)
  {
    UIAlertView *ok = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Thanks for sending the feedback!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [ok show];
  }
  
  [self dismissViewControllerAnimated:YES completion:^{}];
}


- (IBAction)twitterFeedback
{
  // Create the view controller
  TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
  
  // Optional: set an image, url and initial text
  [twitter addImage:[UIImage imageNamed:@"icon-72.png"]];
  [twitter addURL:[NSURL URLWithString:@"http://www.cocoasmiths.com/bathcalc/Bath_Calc/About_Bath_Calculator.html"]];
  [twitter setInitialText:@"I'm using Bath Calc and I love it. \n CC @GreggJaskiewicz"];
  
  // Show the controller
  [self presentModalViewController:twitter animated:YES];
  
  // Called when the tweet dialog has been closed
  twitter.completionHandler = ^(TWTweetComposeViewControllerResult result)
  {
    NSString *title = @"Tweet Status";
    NSString *msg;
    
    if (result == TWTweetComposeViewControllerResultCancelled)
    {
      msg = @"Tweet compostion was canceled.";
    }
    else if (result == TWTweetComposeViewControllerResultDone)
    {
      msg = @"Tweet composition completed.";
    }
    
    // Show alert to see how things went...
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alertView show];
    
    // Dismiss the controller
    [self dismissModalViewControllerAnimated:YES];
  };
}


- (IBAction)cancel:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:^{
  }];
}


- (IBAction)bringUpFeedback
{
  if (![MFMailComposeViewController canSendMail])
  {
    return;
  }
  
  NSString *deviceInfo = @"";

/*
  NSBundle *bundle = [NSBundle mainBundle];
  NSDictionary *info = [bundle infoDictionary];
  if (info[@"SignerIdentity"])
  {
    deviceInfo = [deviceInfo stringByAppendingString:@"I DIDN'T BUY THIS APP!!!!!!!!!!!!\n\n"];
  }
*/
  deviceInfo = [deviceInfo stringByAppendingFormat:@"name: %@\n",           [[UIDevice currentDevice] name]];
  deviceInfo = [deviceInfo stringByAppendingFormat:@"systemName: %@\n",     [[UIDevice currentDevice] systemName]];
  deviceInfo = [deviceInfo stringByAppendingFormat:@"systemVersion: %@\n",  [[UIDevice currentDevice] systemVersion]];
  deviceInfo = [deviceInfo stringByAppendingFormat:@"model: %@\n",          [[UIDevice currentDevice] model]];
  deviceInfo = [deviceInfo stringByAppendingFormat:@"localizedModel: %@\n", [[UIDevice currentDevice] localizedModel]];
  
  
  MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
  mailer.mailComposeDelegate = self;
  [mailer setSubject:@"Bath Calculator Feedback"];
  [mailer setToRecipients:@[@"cocoasmiths@gmail.com"]];
  
  [mailer setMessageBody:[NSString stringWithFormat:@"\n\n-- \n\n%@\n%@\n", self.versionInfo.text, deviceInfo] isHTML:NO];
  mailer.modalPresentationStyle = UIModalPresentationPageSheet;
  if (mailer)
  {
    [self presentViewController:mailer animated:YES completion:^{}];
  }
}

@end

