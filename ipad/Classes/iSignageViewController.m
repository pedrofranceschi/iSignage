//
//  iSignageViewController.m
//  iSignage
//
//  Created by iMac on 16/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iSignageViewController.h"
#import "ServerRequest.h"
#import "iSignageAppDelegate.h"
#import "Reachability.h"

@implementation iSignageViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    sessionData = [[NSMutableDictionary alloc] init];
    if ([self internetIsAvailable]) {
        [loginViewUsername becomeFirstResponder];
    } else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No server connection" message:@"Can't connect to the server. Please check your conection and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[alert show];
    }
}

-(BOOL)internetIsAvailable{
	Reachability *r = [Reachability reachabilityWithHostName:@"isignage.heroku.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

- (void)performLogin:(id)sender {
    ServerRequest *request = [[ServerRequest alloc] init];
    NSString *response = [request postRequestWithMethod:@"/idevice/login" andParams:[NSString stringWithFormat:@"username=%@&password=%@", loginViewUsername.text, loginViewPassword.text]];
    
    if ([response rangeOfString:@"INVALID_DATA" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unable to login" message:@"Invalid username and/or password. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[alert show];
    } else {
        NSArray *parser = [[[response componentsSeparatedByString:@"$__$"] lastObject] componentsSeparatedByString:@"|"];
        for(NSString *element in parser) {
            NSArray *secondaryParser = [element componentsSeparatedByString:@":"];
            [sessionData setObject:[secondaryParser objectAtIndex:1] forKey:[secondaryParser objectAtIndex:0]];
        }
        [sessionData retain];
        
        [loginViewUsername resignFirstResponder];
        [loginViewPassword resignFirstResponder];
        
        [self startSession];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationTransitionFlipFromRight];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight 
                            forView:self.view cache:NO];
        [self.view addSubview:homeView];
        [UIView commitAnimations];
        
        NSTimer *checkForNewCommandsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkForNewCommandsTimerCallback) userInfo:nil repeats:YES];
    }
}

- (void)goToCreateAccountView:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationTransitionFlipFromLeft];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft 
                        forView:self.view cache:NO];
    [self.view addSubview:createAccountView];
    [UIView commitAnimations];
}

- (void)backToLoginView:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationTransitionFlipFromRight];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight 
                        forView:self.view cache:NO];
    [createAccountView removeFromSuperview];
    [UIView commitAnimations];
}

- (void)performAccountCreation:(id)sender {
    if([createAccountViewFullName.text isEqualToString:@""] || [createAccountViewEmail.text isEqualToString:@""] || [createAccountViewUsername.text isEqualToString:@""] || [createAccountViewPassword.text isEqualToString:@""]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please complete all the fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[alert show];
    } else {
        ServerRequest *request = [[ServerRequest alloc] init];
        NSString *response = [request postRequestWithMethod:@"/idevice/create_account" andParams:[NSString stringWithFormat:@"username=%@&password=%@&full_name=%@&email=%@",
        createAccountViewUsername.text, createAccountViewPassword.text, createAccountViewFullName.text, createAccountViewEmail.text]];
        [request release];
        
        if ([response rangeOfString:@"UNAVAILABLE_USERNAME" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"This username already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
    		[alert show];
        } else if ([response rangeOfString:@"OK" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self backToLoginView:nil];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your account was successfully created!." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
    		[alert show];
        }
    }
}

- (void)startSession {
    ServerRequest *request = [[ServerRequest alloc] init];
    NSString *response = [request postRequestWithMethod:@"/idevice/start_session" andParams:[NSString stringWithFormat:@"user_id=%@", [sessionData objectForKey:@"user_id"]]];
    NSLog(@"%s response: %@", _cmd, response);
    [sessionData setObject:[[[[response componentsSeparatedByString:@"$__$"] lastObject] componentsSeparatedByString:@":"] lastObject] forKey:@"session_id"];
    [sessionData retain];
    NSLog(@"%s session_id: %@", _cmd, [sessionData objectForKey:@"session_id"]);
    
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    [userPreferences setObject:[sessionData objectForKey:@"session_id"] forKey:@"session_id"];
    
    [userPreferences release];
    [request release];
    [response release];
}

- (void)endSession {
    if(![[sessionData objectForKey:@"session_id"] isEqualToString:@""]) {
        ServerRequest *request = [[ServerRequest alloc] init];
        
        NSString *sessionId = [[NSUserDefaults standardUserDefaults] stringForKey:@"session_id"];
        
        NSString *response = [request postRequestWithMethod:@"/idevice/end_session" andParams:[NSString stringWithFormat:@"session_id=%@", sessionId]];
        [request release];
        [response release];
    }
}

- (void)checkForNewCommandsTimerCallback {
    [homeViewActivityIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
    [homeViewActivityIndicator startAnimating];
    [self checkForNewCommands];
}

- (void)checkForNewCommands {
    ServerRequest *request = [[ServerRequest alloc] init];
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] stringForKey:@"session_id"];
    NSString *response = [request postRequestWithMethod:@"/idevice/session_commands" andParams:[NSString stringWithFormat:@"session_id=%@", sessionId]];
    
    if ([response rangeOfString:@"INVALID_DATA" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Invalid command" message:@"Invalid command to run. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[alert show];
    } else {
        NSMutableArray *commandsToRun = [[NSMutableArray alloc] init];
        NSArray *parser = [[[response componentsSeparatedByString:@"$__$"] lastObject] componentsSeparatedByString:@"$|$"];
        for(NSString *command in parser) {
            if (![command isEqualToString:@""]) {
                NSArray *secondaryParser = [command componentsSeparatedByString:@"$/$"];
                NSMutableDictionary *commandProperties = [[NSMutableDictionary alloc] init];
                for(NSString *command_value in secondaryParser) {
                    NSArray *thirdParser = [command_value componentsSeparatedByString:@"$:$"];
                    [commandProperties setObject:[thirdParser objectAtIndex:1] forKey:[thirdParser objectAtIndex:0]];
                }
                [commandsToRun addObject:commandProperties];
            }
        }
        [self runCommands:commandsToRun];
        NSLog(@"%s commandsToRun: %@", _cmd, commandsToRun);
    }
    [homeViewActivityIndicator stopAnimating];
    
    [request release];
    [response release];
}

// - (void)scrollTextTimerCallback {
//     if ([sessionData objectForKey:@"scrolling_text"] == nil || [sessionData objectForKey:@"scroll_position"] == nil) {
//         NSLog(@"%s setting scrolls. ", _cmd);
//         [sessionData setObject:scrollTextViewTextView.text forKey:@"scrolling_text"];
//         [sessionData setObject:@"0" forKey:@"scroll_position"];
//         CGRect _frame = scrollTextViewTextView.frame;
//         _frame.size.width += [scrollTextViewTextView.text sizeWithFont:scrollTextViewTextView.font
//             constrainedToSize:CGSizeMake(9999, 75)
//             lineBreakMode:UILineBreakModeWordWrap].width;// 0.075*([[sessionData objectForKey:@"scrolling_text"] length]);
//         NSLog(@"%s size: %f", _cmd, 0.075*([[sessionData objectForKey:@"scrolling_text"] length]));
//         scrollTextViewTextView.frame = _frame;
//     }
//     
//     int pos = [[sessionData objectForKey:@"scroll_position"] intValue];
//     CGRect _frame = scrollTextViewTextView.frame;
//     _frame.origin.x += (pos*-0.75);
//     scrollTextViewTextView.frame = _frame;
//     
//     NSLog(@"%s bigger? (pos*0.75): %f/frame.size.width: %f", _cmd, (pos*0.75), _frame.size.width/500.0);
//     
//     if ((pos*0.075) > _frame.size.width/50.0) {
//         [sessionData setObject:nil forKey:@"scroll_position"];
//     } else {
//         [sessionData setObject:[NSString stringWithFormat:@"%i", pos+1] forKey:@"scroll_position"];
//     }
// }

- (void)runCommands:(NSMutableArray *)commandsToRun {
    for (NSMutableDictionary *commandOptions in commandsToRun) {
        NSString *key = [commandOptions objectForKey:@"name"];
        NSString *value = [commandOptions objectForKey:@"value"];
        
        NSLog(@"%s key: %@/value: %@", _cmd, key, value);
        
        if ([key isEqualToString:@"change_to_mode"]) {
            int mode = [value intValue];
            if (mode == 1) {
                // Fixed text mode...
                [self removeAllViews];
                [self.view addSubview:fixedTextView];
            } else if (mode == 2) {
                // [self removeAllViews];
                // [self.view addSubview:scrollTextView];
                
                // NSTimer *checkForNewCommandsTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(scrollTextTimerCallback) userInfo:nil repeats:YES];
            } else if (mode == 3) {
                [self removeAllViews];
                [self.view addSubview:imageView];
            }
            
            [sessionData setObject:value forKey:@"mode"];
            [sessionData retain];
        } else if ([key isEqualToString:@"text_to_show"]) {
            // Fixed text mode text.
            
            fixedTextViewTextView.text = value;
        } else if ([key isEqualToString:@"font_size"]) {
            if ([[sessionData objectForKey:@"mode"] isEqualToString:@"1"]) {
                fixedTextViewTextView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:[value floatValue]];
            }
        } else if ([key isEqualToString:@"text_alignment"]) {
            if ([value isEqualToString:@"1"]) {
                fixedTextViewTextView.textAlignment = UITextAlignmentLeft;
            } else if ([value isEqualToString:@"2"]) {
                fixedTextViewTextView.textAlignment = UITextAlignmentCenter;
            } else if([value isEqualToString:@"3"]) {
                fixedTextViewTextView.textAlignment = UITextAlignmentRight;
            }
        } else if ([key isEqualToString:@"text_color"]) {
            NSArray *parser = [value componentsSeparatedByString:@"$!$"];
            UIColor *colorToSet = [UIColor colorWithRed:[[parser objectAtIndex:0] floatValue]/255.0 green:[[parser objectAtIndex:1] floatValue]/255.0 blue:[[parser objectAtIndex:2] floatValue]/255.0 alpha:1];
            if ([[sessionData objectForKey:@"mode"] isEqualToString:@"1"]) {
                fixedTextViewTextView.textColor = colorToSet;
            }
        } else if ([key isEqualToString:@"background_color"]) {
            NSArray *parser = [value componentsSeparatedByString:@"$!$"];
            UIColor *colorToSet = [UIColor colorWithRed:[[parser objectAtIndex:0] floatValue]/255.0 green:[[parser objectAtIndex:1] floatValue]/255.0 blue:[[parser objectAtIndex:2] floatValue]/255.0 alpha:1];
            if ([[sessionData objectForKey:@"mode"] isEqualToString:@"1"]) {
                fixedTextView.backgroundColor = colorToSet;
            }
        } else if ([key isEqualToString:@"image_path"]) {
            NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:value]];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            [imageViewImageView setImage:image];
            [imageData release];
            [image release];
        }
    }
}

- (void)removeAllViews {
    [fixedTextView removeFromSuperview];
    [imageView removeFromSuperview];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    } else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
