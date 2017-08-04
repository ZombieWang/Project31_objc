//
//  ViewController.h
//  Project31_objc
//
//  Created by Frank on 2017/8/4.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressBar;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak) UIWebView *activeWebView;
@end

