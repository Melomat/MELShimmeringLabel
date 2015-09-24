//
//  MELShimmeringLabel.m
//  Sapporo2
//
//  Created by Matthias Mellouli on 2015-09-22.
//  Copyright © 2015 dh. All rights reserved.
//

#import "MELShimmeringLabel.h"

@interface MELShimmeringLabel ()

@property (strong, nonatomic) UILabel *maskingLabel;
@property (strong, nonatomic) CAGradientLayer *maskingGradient;

@end

@implementation MELShimmeringLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initMask];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initMask];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMask];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskingLabel.frame = self.bounds;
    [self applyGradient];
}

/**
 *  Initialization of the mask made by adding a Label having a masking gradient
 *  as a subview. 
 *  By animating the gradient position, we will be able to produce the 
 *  'slide to unlock' effect
 */
-(void)initMask {
    
    self.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    self.maskingLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.maskingLabel.textColor = [UIColor whiteColor];
    self.maskingLabel.font = self.font;
    self.maskingLabel.highlighted = NO;
    self.maskingLabel.highlightedTextColor = [UIColor clearColor];
    self.maskingLabel.shadowColor = [UIColor clearColor];
    self.maskingLabel.shadowOffset = self.shadowOffset;
    self.maskingLabel.text = self.text;
    [self addSubview:self.maskingLabel];
}

/**
 *  Creation of the gradient depending on the size of the text, and creation 
 *  of the animation to move the gradient.
 */
- (void)applyGradient {
    if (self.maskingGradient) {
        [self.maskingGradient removeAllAnimations];
        [self.maskingGradient removeFromSuperlayer];
        self.maskingGradient = nil;
    }
    self.maskingGradient = [CAGradientLayer layer];
    self.maskingGradient.frame = self.bounds;
    self.maskingGradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:1.0 alpha:0.95].CGColor, (id)[UIColor clearColor].CGColor];
    self.maskingGradient.startPoint = CGPointMake(0.0f, 1.0f);
    self.maskingGradient.endPoint = CGPointMake(1.0f, 1.0f);

    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnim.fromValue = [NSNumber numberWithFloat:self.frame.size.width * -0.5];
    maskAnim.toValue = [NSNumber numberWithFloat:CGRectGetWidth(self.bounds) * 1.5];
    maskAnim.repeatCount = MAXFLOAT;
    maskAnim.duration = 2.0f;
    [self.maskingGradient addAnimation:maskAnim forKey:@"slideAnim"];
    self.maskingLabel.layer.mask = self.maskingGradient;
    
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.maskingLabel.text = text;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.maskingLabel.font = font;
}

@end
