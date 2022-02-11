/*
     File: MyViewController.m

 */

#import "TalkSpotAppDelegate.h"
#import "MyViewController.h"
#import "MainMenuController.h"
#import "Wrapper.h"
#include <stdlib.h>

NSMutableString *strSendXML = nil;
NSMutableString *strUsername = nil;
NSMutableString *strPassword = nil;
NSMutableString *strWebURL = nil;
NSMutableString *strSavedGameData = nil;

@implementation MyViewController

@synthesize textField;
@synthesize textFieldpw;
@synthesize textFieldURL;

@synthesize button;
@synthesize buttonMainMenu;

@synthesize label;
@synthesize label2;
@synthesize label3;
@synthesize TBlabel;
@synthesize TBlabel2;
@synthesize TBlabel3;

@synthesize bgImage;
@synthesize string;

@synthesize mainMenuController;
//@synthesize myViewController;

@synthesize window;


//@synthesize ViewController;

+ (void)initialize
{
	//initialize 
	
	NSLog(@"Login View Started.");
	
	strSendXML = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><TalkSpotMobile "];
	strUsername = [[NSMutableString alloc] initWithString:@""];
	strPassword = [[NSMutableString alloc] initWithString:@""];
	strWebURL = [[NSMutableString alloc] initWithString:@""];
	
	strSavedGameData = [[NSMutableString alloc] initWithString:@""];  //saved TempID
	
	//NSString *tempEncodedKey3 = @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><TalkSpotMobile type=\"signin\" email=\"ken@kensblog.com\" password=\"password\" website=\"\" />";

	
}
//___________________________________________________________________________________________

-(id) init {
    if((self = [super init])) {
		
		//		[strSendXML setString:@""];
		//		[strUsername setString:@""];
		//		[strPassword setString:@""];
		//		[strWebURL setString:@""];
		
		NSLog(@"This Sub does not run");
		
		
	}
    return self;
}
//_____________________________________________________________________________end of -(id) init ____

// PARSE RESPONSE FROM XML WEB SERVICE.
// ...

//LOGIN METHOD:

#pragma mark WrapperDelegate methods

- (void)wrapper:(Wrapper *)wrapper didRetrieveData:(NSData *)data
{
    NSString *text = [engine responseAsText];
    if (text != nil)
    {
        //output.text = text;
		NSLog(@"output: %@", text);
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	//save data and parse...
	if (text != nil)
    {
		//parsing response
		NSLog(@"parsing response...");
		
		
		//NSString *string1 = @"The quick brown fox jumped";
		
		NSRange match;
		
		match = [text rangeOfString: @"response=\"success\""];
		
		NSLog (@"match found at index %i", match.location);
		
		NSLog (@"match length = %i", match.length);
		
		//if match.length is greater than 0, then there is a match.
		
		
		if (match.length > 0) {
			// successful login OK!  get the key ID#:
			//split by "  then look for  " tempkey=" and get next value:
			
			int count = 0;
			int intLocofMatch = 0;
			
			NSArray *arr = [text componentsSeparatedByString:@"\""];
			NSString *intSearchString = @" tempkey=";
			
			
			//check fish for kick mode:
			for(int i=0;i<[arr count];i++)
			{
				if([[arr objectAtIndex:i] isEqualToString:intSearchString]) {
					NSLog(@"Found at= %d", i);
					intLocofMatch = i;
					count++;
				}
			}
			if (count == 0) {
				// not found
				NSLog(@"Not found after all");
				
			} else {
				// found
				intLocofMatch = intLocofMatch + 1;
				
				//this is the tempkey
				NSLog(@"Value: %@", [arr objectAtIndex:intLocofMatch]);
				
				//NSLog(@"Found at count= %d", count);
				
				//save to folder...
				
				NSFileManager *fileManagerEM = [NSFileManager defaultManager];
				NSString *docsDirectoryEM = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
				NSString *pathEM = [docsDirectoryEM stringByAppendingPathComponent:@"savedtempkey.txt"];

				NSString *intScoreConversion = [arr objectAtIndex:intLocofMatch];
				
				if([fileManagerEM fileExistsAtPath:pathEM])
				{ 
					//if([intScoreConversion writeToFile: @"savedgame.txt" atomically: YES])
					if([intScoreConversion writeToFile:pathEM atomically: YES])	
					{
						NSLog(@"SAVED OK - YOU ARE LOGGED IN!");
						
					} else 
					{
						NSLog(@"UNABLE TO SAVE");
					}
					
				} else {
					NSLog(@"No file found");
				}
				
				pathEM = nil;
				docsDirectoryEM = nil;		
				fileManagerEM = nil;
				
				[self switchToMainMenu];
				
			}
			
			
			
		}
		

		
	}

	
	
	
}

- (void)wrapperHasBadCredentials:(Wrapper *)wrapper
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bad credentials!" 
                                                    message:@"Bad credentials!"  
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)wrapper:(Wrapper *)wrapper didCreateResourceAtURL:(NSString *)url
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Resource created!" 
                                                    message:[NSString stringWithFormat:@"Resource created at %@!", url]  
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)wrapper:(Wrapper *)wrapper didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                    message:[NSString stringWithFormat:@"Error code: %d!", [error code]]  
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)wrapper:(Wrapper *)wrapper didReceiveStatusCode:(int)statusCode
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status code not OK!" 
                                                    message:[NSString stringWithFormat:@"Status code not OK: %d!", statusCode]
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -



- (void)viewDidLoad {
    // When the user starts typing, show the clear button in the text field.
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    // When the view first loads, display the placeholder text that's in the
    // text field in the label.
    
	//label.text = textField.placeholder;
	
//	label2.text = textFieldpw.placeholder;
//	label3.text = textFieldURL.placeholder;
	
	[button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
	
	[buttonMainMenu addTarget:self action:@selector(actionMainMenu:) forControlEvents:UIControlEventTouchUpInside];
	
	
	//check saved file...
	
	[strSavedGameData setString:@"0"];
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"savedtempkey.txt"];
	
	//NSLog(@"checking for docsDirectory %@",docsDirectory);
	//NSLog(@"check if file exists at path %@",path);
	
	if(![fileManager fileExistsAtPath:path])
	{
		NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/savedtempkey.txt"]];
		[data writeToFile:path atomically:YES];
		NSLog(@"there was no saved temp key file, so we recreated it");
	} else {
		NSLog(@"the temp key file already exists");
		
	}
	
	[strSavedGameData setString:@"1"];
	
	//NSString *filePath = [[NSBundle mainBundle] pathForResource:@"savedgame" ofType:@"txt"];  
	if(![fileManager fileExistsAtPath:path])
	{ 
		// do nothing this file should be here!
		NSLog(@"ERROR");
	} else {
		// file found:
		
		// I don't think we want to do this if the file exists unless we're saving the game for a high score:
		// correction, this just shows what the current high score is:
		
		NSString *myText = [NSString stringWithContentsOfFile:path];  
		if (myText) {  
			//textView.text= myText;  
			NSLog(@"current saved value: hey = %@", myText);
			[strSavedGameData setString:myText];
			
			
		} else {
			NSLog(@"No text found. this should never happen");
		}
		
		
	}
	
	path = nil;
	docsDirectory = nil;		
	fileManager = nil;
	
	
}


- (void)updateString {
	
	//check if string is valid (client-side checK)
	
	// for the demo, assume it is valid for username
	
	//if (isValidUsername == 0) {
		
		// add text for now:
	//	[strUsername appendString:textField.text];
	
	[strUsername setString:textField.text];
	
		//[strUsername appendString:@"|"];
		
		
	//}

	
	
	// Store the text of the text field in the 'string' instance variable.
	self.string = textField.text;
	//self.string = textFieldpw.text;
    // Set the text of the label to the value of the 'string' instance variable.
	//label.text = self.string;
}

- (void)updateStringpw {
	
	[strPassword setString:textFieldpw.text];
	
	
	// Store the text of the text field in the 'string' instance variable.
	self.string = textFieldpw.text;
	//self.string = textFieldpw.text;
    // Set the text of the label to the value of the 'string' instance variable.
	//label2.text = self.string;
}

- (void)updateStringURL {
	
	[strWebURL setString:textFieldURL.text];
	
	// Store the text of the text field in the 'string' instance variable.
	self.string = textFieldURL.text;
	//self.string = textFieldpw.text;
    // Set the text of the label to the value of the 'string' instance variable.
	//label3.text = self.string;
	//label3.text = @"testdata";
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == textField) {
		[textField resignFirstResponder];
        // Invoke the method that changes the greeting.
        [self updateString];
	}
	if (theTextField == textFieldpw) {
		[textFieldpw resignFirstResponder];
        // Invoke the method that changes the greeting.
        [self updateStringpw];
	}
	if (theTextField == textFieldURL) {
		[textFieldURL resignFirstResponder];
        // Invoke the method that changes the greeting.
        [self updateStringURL];
	}
	return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard when the view outside the text field is touched.
    [textField resignFirstResponder];
	[textFieldpw resignFirstResponder];
	[textFieldURL resignFirstResponder];
    // Revert the text field to the previous value.

	NSLog(@"Outside touched");
	//NSLog(@"val: %@", event);
	//NSLog(@"strUsername: %@", strUsername);
	//NSLog(@"textField.text: %@", textField.text);
	
	//check if mutablestring is equal to what was entered.. if it was updateStringX
	
	// if the value is not equal, then that is the updateStringX to run
	
	//set to NSString

	//BOOL result = [string1 isEqualToString:string2];
	BOOL result = [strUsername isEqualToString:textField.text];
	
	if (result == 0) {
		//NSLog(@"Newvalue, get it");
		[self updateString];
	} else {
		//
		NSLog(@"SameValue");
	}

	BOOL result2 = [strPassword isEqualToString:textFieldpw.text];
	
	if (result2 == 0) {
		//NSLog(@"Newvalue, get it");
		[self updateStringpw];
	} else {
		//
		//NSLog(@"SameValue");
	}
	
	BOOL result3 = [strWebURL isEqualToString:textFieldURL.text];
	
	if (result3 == 0) {
		//NSLog(@"Newvalue, get it");
		[self updateStringURL];
	} else {
		//
		//NSLog(@"SameValue");
	}	
	
	
	//textField.text = self.string; 
	//textFieldpw.text = self.string;
	//textFieldURL.text = self.string;
	
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)switchView
{
	
//	MyViewController *vc = [[myViewController alloc] initWithNibName:@"TalkSpotMainMenu" bundle:[NSBundle mainBundle]];
//	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//	[self presentModalViewController:vc animated:YES];
//	[vc release];
						  
}
						  

-(void)actionMainMenu:(id)sender
{
	NSLog(@"Main menu button clicked");
	
	[self switchToMainMenu];
	
	
	
}


-(void)action:(id)sender
{
	
	//button was pressed to Submit
	
	
	//NSString *tempEncodedKey3 = @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><TalkSpotMobile type=\"signin\" email=\"ken@kensblog.com\" password=\"password\" website=\"\" />";
	//gnin\" email=\"ken@kensblog.com\" password=\"password\" website=\"\" />";
	
	//NSString *strConvUsername = [NSString stringWithFormat:@"VAL: %@ ",xValue];
	
	BOOL result = [strUsername isEqualToString:textField.text];
	
	if (result == 0) {
		//NSLog(@"Newvalue, get it");
		[self updateString];
	} else {
		//
		NSLog(@"SameValue");
	}
	
	BOOL result2 = [strPassword isEqualToString:textFieldpw.text];
	
	if (result2 == 0) {
		//NSLog(@"Newvalue, get it");
		[self updateStringpw];
	} else {
		//
		//NSLog(@"SameValue");
	}
	
	BOOL result3 = [strWebURL isEqualToString:textFieldURL.text];
	
	if (result3 == 0) {
		//NSLog(@"Newvalue, get it");
		[self updateStringURL];
	} else {
		//
		//NSLog(@"SameValue");
	}	
	
	//________________________________________________________________________________________
	NSLog(@"UIButton was clicked, submit form as XML if valid");
	
	int intPassedAllVerificationChecks = 0;
	
	//NSLog(@"val: %@", [validateEmail strUsername]);
	NSString *emailRegex = @"[a-zA-Z0-9.\\-_]{2,32}@[a-zA-Z0-9.\\-_]{2,32}\.[A-Za-z]{2,4}";
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	BOOL result5 = [regExPredicate evaluateWithObject:strUsername];
	
	
	BOOL result4 = [strUsername isEqualToString:@""];

	// check values:
	
	if (result4 == 1) {
		// do nothing cant be blank
		intPassedAllVerificationChecks = 1;
		NSLog(@"Username is blank");
		
		UIAlertView* dialogZ = [[UIAlertView alloc] init];
		[dialogZ setDelegate:self];
		[dialogZ setTitle:@"Sign In"];
		[dialogZ setMessage:@"Email Address is blank."];
		[dialogZ addButtonWithTitle:@"Close"];
		//[dialogZ addButtonWithTitle:@"Close"];
		[dialogZ show];
		[dialogZ release];
	} 
	if ((result5 == 0) && (intPassedAllVerificationChecks == 0)) {
		// do nothing failed check
		intPassedAllVerificationChecks = 1;
		NSLog(@"Username is not an e-mail address.");
		
		UIAlertView* dialogZ = [[UIAlertView alloc] init];
		[dialogZ setDelegate:self];
		[dialogZ setTitle:@"Sign In"];
		[dialogZ setMessage:@"Email Address is not a recognized format."];
		[dialogZ addButtonWithTitle:@"Close"];
		//[dialogZ addButtonWithTitle:@"Close"];
		[dialogZ show];
		[dialogZ release];
	}

	BOOL result6 = [strPassword isEqualToString:@""];
	
	if ((result6 == 1) && (intPassedAllVerificationChecks == 0)) {
		// do nothing cant be blank
		intPassedAllVerificationChecks = 1;
		NSLog(@"Password is blank");
		
		UIAlertView* dialogZ = [[UIAlertView alloc] init];
		[dialogZ setDelegate:self];
		[dialogZ setTitle:@"Sign In"];
		[dialogZ setMessage:@"Password is blank."];
		[dialogZ addButtonWithTitle:@"Close"];
		//[dialogZ addButtonWithTitle:@"Close"];
		[dialogZ show];
		[dialogZ release];
	} 
	
	
	
	//disabled for text entry
	if (intPassedAllVerificationChecks == 0) {
		
		NSLog(@"Login Info OK: Attempt Login.");
		// attempt login:
		
	
		//	NSLog(@"UIButton was clicked, submit form as XML");
		//label.text = @"Submit";
		//NSLog(@"strSendXML: %@", strSendXML);
		NSLog(@"strUsername: %@", strUsername);
		NSLog(@"strPassword: %@", strPassword);
		NSLog(@"strWebURL: %@", strWebURL);
		
		//prep XML and send it... depending on response, act accordingly:
		
		//strSendXML: <?xml version="1.0" encoding="UTF-8" ?><TalkSpotMobile   
		
		[strSendXML setString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><TalkSpotMobile "];
		
		[strSendXML appendString:@"type=\"signin\" email=\""];
		[strSendXML appendString:strUsername];
		
		[strSendXML appendString:@"\" password=\""];
		[strSendXML appendString:strPassword];
		
		[strSendXML appendString:@"\" website=\""];
		[strSendXML appendString:strWebURL];
		
		[strSendXML appendString:@"\" />"];	
		
		NSLog(@"strSendXML: %@", strSendXML);
		
		//send it away:
		
		
		
		//NSURL *url = [NSURL URLWithString:address.text];
		NSDictionary *parameters = nil;
		//if ([parameter.text length] > 0)
		//{
			NSArray *keys = [NSArray arrayWithObjects:@"parameter", nil];
			NSArray *values = [NSArray arrayWithObjects:@"parametertext", nil];
			parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
		//}
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		//output.text = @"";
		
		NSURL *newURL = [NSURL URLWithString:@"http://www.talkspot4.com/aspx/blob2/xadmin/xadminmobilewebserver.aspx"];  
		
		if (engine == nil)
		{
			engine = [[Wrapper alloc] init];
			engine.delegate = self;
		}
		
		//sends to wrapper:
		//- (void)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withParameters:(NSDictionary *)parameters textToSend:(NSString *)toSend
		//[engine sendRequestTo:newURL usingVerb:@"POST" withParameters:parameters textToSend:@"TEXTTOSEND"];
		[engine sendRequestTo:newURL usingVerb:@"POST" withParameters:parameters textToSend:strSendXML];
	} else {
		//do not
		NSLog(@"Login not attempted.");
	}


	
	
}


- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

- (void)switchToMainMenu {
	
	//window.hidden = YES;
	
	//works but no Main Menu scene in bg	
	//	for (UIView *view in [self.view subviews]) {
	//		[view removeFromSuperview];
	//		NSLog(@"View: %@", view);
	//	}
	//	
	
	NSLog(@"Running Main Menu Switch");
	
	//test MainMenu
	MainMenuController *aViewController = [[MainMenuController alloc] initWithNibName:@"TalkSpotMainMenu" bundle:[NSBundle mainBundle]];
	self.mainMenuController = aViewController;
	[aViewController release];			
	
	//activate view:
	UIView *controllersView = [mainMenuController view];
	
	[window addSubview:controllersView];
	
	[window makeKeyAndVisible];
	
	////this works for image and view!
	//	
	//	UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"BackgroundMainMenu" ofType:@"png"]];
	//	
	//	bgImage = [[UIImageView alloc] initWithImage:img];
	//	[bgImage setUserInteractionEnabled:NO];	
	//	
	//	//self.view = bgImage;   // wow this replaced the entire view with the image.
	self.view = controllersView;
	
	
	NSLog(@"This is running after visible");
	
}


- (void)dealloc {
	// To adhere to memory management rules, release the instance variables.
    // 'textField' and 'label' are objects in the nib file and are created when the nib
    // is loaded.
	
	//release mutablestrings
	
	//release engine for wrapper
	
	
	[textField release];
	[label release];
	[super dealloc];
}


@end
