//
//  GraphView.m
//  Calculator2
//
//  Created by Jacob Håkansson on 2012-12-07.
//  Copyright (c) 2012 Jacob Håkansson. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
@property (nonatomic) CGPoint origin;

@end

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;

#define DEFAULT_SCALE 20;
#define DEFAULT_ORIGIN_KEY_X @"GraphView.origin.x"
#define DEFAULT_ORIGIN_KEY_Y @"GraphView.origin.y"
#define DEFAULT_SCALE_KEY @"GraphView.scale"

- (CGPoint)origin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat x = [defaults floatForKey:DEFAULT_ORIGIN_KEY_X];
    CGFloat y = [defaults floatForKey:DEFAULT_ORIGIN_KEY_Y];
    CGPoint originPoint;
    if (x && y) {
        originPoint.x = x;
        originPoint.y = y;
        self.origin = originPoint;
    } else if (!_origin.x || !x) {
        originPoint.x = self.bounds.size.width/2;
        originPoint.y = self.bounds.size.height - self.bounds.size.height/2;
        self.origin = originPoint;
    }
    return _origin;
}

- (void)setOrigin:(CGPoint)origin {
    if (origin.x != _origin.x || origin.y != _origin.y) {
        _origin = origin;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:origin.x forKey:DEFAULT_ORIGIN_KEY_X];
        [defaults setFloat:origin.y forKey:DEFAULT_ORIGIN_KEY_Y];
        [defaults synchronize];
        [self setNeedsDisplay];
    }
}

- (CGFloat)scale {
    CGFloat defaultScale = [[NSUserDefaults standardUserDefaults] floatForKey:DEFAULT_SCALE_KEY];
    if (defaultScale) {
        return defaultScale;
    }else if (!_scale) {
        self.scale = DEFAULT_SCALE;
        return  _scale;
    }
    else return _scale;
}

- (void)setScale:(CGFloat)scale {
    if (scale != _scale) {
        _scale = scale;
        [[NSUserDefaults standardUserDefaults] setFloat:scale forKey:DEFAULT_SCALE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged)||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged)||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        translation.x += self.origin.x;
        translation.y += self.origin.y;
        if (translation.x ==0) {
            translation.x = 1;
        }
        self.origin = translation;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

-(void)tripleTap:(UITapGestureRecognizer *)gesture {
    self.origin = [gesture locationOfTouch:0 inView:self];
}

- (void)setup {
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    [[UIColor blackColor] setStroke];
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    float step = 1/self.scale;
    for (float i = -rect.origin.x; i < rect.size.width/self.scale; i +=step) {
        float x = i- self.origin.x/self.scale;
        float x2 = (i+step)- self.origin.x/self.scale; //* self.scale;
        float y = [self.dataSource valueForGraphView:self atPoint:x];
        float y2 = [self.dataSource valueForGraphView:self atPoint:x2];
        y2 *= self.scale;
        y *= self.scale;
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, i*self.scale, self.origin.y -y);
        CGContextAddLineToPoint(context,(i+step)*self.scale, self.origin.y - y2);
        CGContextStrokePath(context);
    }

}


@end
