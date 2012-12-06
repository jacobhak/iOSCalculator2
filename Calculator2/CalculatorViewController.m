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

- (void) updateDisplay2:(NSString *)string {
    //NSString *newDisplay2 = [self.display2.text stringByAppendingString:@" "];
    self.display2.text = [CalculatorBrain descriptionOfProgram:self.brain.program];//[newDisplay2 stringByAppendingString:string];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.userIsEnteringNumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsEnteringNumber = YES;
    }

}
- (IBAction)pointPressed:(UIButton *)sender {
    if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
        [self digitPressed:sender];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateDisplay2:self.display.text];
    self.userIsEnteringNumber = NO;
}
- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsEnteringNumber) {
        [self enterPressed];
    }
    [self.brain pushVariable:[sender currentTitle]];
    [self updateDisplay2:[sender currentTitle]];
    
}
- (IBAction)testPressed:(UIButton *)sender {
    NSDictionary *dict;
    if ([[sender currentTitle] isEqualToString:@"test1"]) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:2],@"x",
                [NSNumber numberWithDouble:4],@"y",nil];
    } else if ([[sender currentTitle] isEqualToString:@"test2"]) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:2],@"x",
                [NSNumber numberWithDouble:3],@"y",nil];
    } else if ([[sender currentTitle] isEqualToString:@"nilTest"]) dict = nil;
    NSString * str = @"";
    NSSet *set =[CalculatorBrain variablesUsedInProgram:self.brain.program];
    for (NSString *v in set) {
        str = [[str stringByAppendingString:v] stringByAppendingString:@" = "];
        if (dict) str = [str stringByAppendingString:[[dict valueForKey:v]description]];
        else str = [str stringByAppendingString:@"0"];
        str = [str stringByAppendingString:@" "];
    }
    self.display3.text = str;
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:dict];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsEnteringNumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    [self updateDisplay2:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (IBAction)undoPressed {
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = @"0";
    self.display2.text = @"";
}
@end
