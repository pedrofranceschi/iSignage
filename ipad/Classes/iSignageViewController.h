//
//  iSignageViewController.h
//  iSignage
//
//  Created by iMac on 16/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iSignageViewController : UIViewController {
    
    // Global
    NSMutableArray *sessionData;
    
    // Login view
    IBOutlet UITextField *loginViewUsername, *loginViewPassword;
    
    // Home View
    IBOutlet UIView *homeView;
    IBOutlet UIActivityIndicatorView *homeViewActivityIndicator;
    
    // Fixed Text View
    IBOutlet UIView *fixedTextView;
    IBOutlet UITextView *fixedTextViewTextView;
    
    // Scroll Text View
    IBOutlet UIView *scrollTextView;
    IBOutlet UITextView *scrollTextViewTextView;
    
    // Image View
    IBOutlet UIView *imageView;
    IBOutlet UIImageView *imageViewImageView;
    
    // Create Account View
    IBOutlet UIView *createAccountView;
    IBOutlet UITextField *createAccountViewFullName, *createAccountViewEmail, *createAccountViewUsername, *createAccountViewPassword;
    
}

- (void)performLogin:(id)sender;
- (void)goToCreateAccountView:(id)sender;
- (void)backToLoginView:(id)sender;
- (void)performAccountCreation:(id)sender;

// Global
@property (nonatomic, retain) NSMutableArray *sessionData;

// Login view
@property (nonatomic, retain) IBOutlet UITextField *loginViewUsername, *loginViewPassword;

// Home View
@property (nonatomic, retain) IBOutlet UIView *homeView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *homeViewActivityIndicator;

// Fixed Text View
@property (nonatomic, retain) IBOutlet UIView *fixedTextView;
@property (nonatomic, retain) IBOutlet UITextView *fixedTextViewTextView;

// Scroll Text View
@property (nonatomic, retain) IBOutlet UIView *scrollTextView;
@property (nonatomic, retain) IBOutlet UITextView *scrollTextViewTextView;

// Image View
@property (nonatomic, retain) IBOutlet UIView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewImageView;

// Create Account View
@property (nonatomic, retain) IBOutlet UIView *createAccountView;
@property (nonatomic, retain) IBOutlet UITextField *createAccountViewFullName, *createAccountViewEmail, *createAccountViewUsername, *createAccountViewPassword;

@end

