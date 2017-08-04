//
//  ViewController.m
//  Project31_objc
//
//  Created by Frank on 2017/8/4.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDefaultTitle];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWebView)];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteWebView)];
    self.navigationItem.rightBarButtonItems = @[delete, add];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setDefaultTitle {
    self.title = @"Multibrowser";
}

- (void)addWebView {
    UIWebView *webView = [UIWebView new];
    webView.delegate = self;
    
    [self.stackView addArrangedSubview:webView];
    
    NSURL *url = [NSURL URLWithString:@"https://github.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    webView.layer.borderColor = [[UIColor blueColor] CGColor];
    [self selectWebView:webView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTapped:)];
    recognizer.delegate = self;
    [webView addGestureRecognizer:recognizer];
}

- (void)selectWebView:(UIWebView*)webView {
    for (UIView *view in self.stackView.arrangedSubviews) {
        view.layer.borderWidth = 0;
    }
    
    self.activeWebView = webView;
    webView.layer.borderWidth = 3;
    
    [self updateUIUsingWebView:webView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.activeWebView != nil) {
        NSURL *url = [NSURL URLWithString:self.addressBar.text];
        if (url != nil) {
            [self.activeWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
    [textField resignFirstResponder];
    
    return YES;
}

- (void)deleteWebView {
    if (self.activeWebView) {
        NSInteger index = [self.stackView.arrangedSubviews indexOfObject:self.activeWebView];
        
        if (index != NSNotFound) {
            [self.stackView removeArrangedSubview:self.activeWebView];
            [self.activeWebView removeFromSuperview];
            
            if (self.stackView.arrangedSubviews.count == 0) {
                [self setDefaultTitle];
            } else {
                if (index == self.stackView.arrangedSubviews.count) {
                    index = self.stackView.arrangedSubviews.count - 1;
                }
                
                UIWebView *newSelectedWebView = self.stackView.arrangedSubviews[index];
                [self selectWebView:newSelectedWebView];
            }
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        self.stackView.axis = UILayoutConstraintAxisVertical;
    } else {
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
    }
}

- (void)updateUIUsingWebView:(UIWebView*)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.addressBar.text = webView.request.URL.absoluteString ?: @"";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == self.activeWebView) {
        [self updateUIUsingWebView:webView];
    }
}

- (void)webViewTapped:(UITapGestureRecognizer*)recognizer {
    UIWebView *selectedWebView = (UIWebView*)recognizer.view;
    [self selectWebView:selectedWebView];
}

@end

