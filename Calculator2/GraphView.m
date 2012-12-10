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

- (CGPoint)origin {
    if (!_origin.x) {
        CGPoint originPoint;
        originPoint.x = self.bounds.size.width/2;
        originPoint.y = self.bounds.size.height - self.bounds.size.height/2;
        return originPoint;
    } else return _origin;
}

- (void)setOrigin:(CGPoint)origin {
    if (origin.x != _origin.x || origin.y != _origin.y) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (CGFloat)scale {
    if (!_scale) {
        return  DEFAULT_SCALE;
    }
    else return _scale;
}

- (void)setScale:(CGFloat)scale {
    if (scale != _scale) {
        _scale = scale;
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
