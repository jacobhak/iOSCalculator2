//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jacob Håkansson on 2012-11-22.
//  Copyright (c) 2012 Jacob Håkansson. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.userIsEnteringNumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.display2.text = [self.display2.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsEnteringNumber = YES;
        NSString *newDisplay2 = [self.display2.text stringByAppendingString:@" "];
        self.display2.text = [newDisplay2 stringByAppendingString:self.display.text];
    }

}
- (IBAction)pointPressed:(UIButton *)sender {
    if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
        [self digitPressed:sender];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsEnteringNumber = NO;
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsEnteringNumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    NSString *newDisplay2 = [self.display2.text stringByAppendingString:@" "];
    self.display2.text = [newDisplay2 stringByAppendingString:operation];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = @"0";
    self.display2.text = @"";
}
@end
