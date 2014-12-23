//
//  ComboBoxView.m
//  ComboBox
//
//  Created by Vikas Jalan on 12/13/12.
//  Copyright 2012 http://www.vikasjalan.com All rights reserved.
//  Conacts on jalanvikas@gmail.com or contact@vikasjalan.com
//
//  Get the latest version from here:
//  https://github.com/jalanvikas/ComboBox
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  * Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  * The name of Vikas Jalan may not be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY VIKAS JALAN "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
//  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
//  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "ComboBoxView.h"

#define COMBO_BOX_TABLE_HOLDER_VIEW_TAG 5001

#define DEFAULT_COMBO_STRING @"Select"

const CGFloat kComboBoxTableHeight = 200;

@interface ComboBoxView() <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *expandCollapseButton;
@property (nonatomic, strong) UILabel *expandCollapseButtonTitle;
@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) UITableView *comboBoxTableView;

@property (nonatomic, assign) CGRect holderViewFrame;
@property (nonatomic, assign) CGFloat maxViewHeight;
@property (nonatomic, assign) NSInteger selectedComboBoxItemIndex;

@property (nonatomic, assign) BOOL shouldShowFirstItemByDefault;
@property (nonatomic, strong) NSString *defaultTitle;

@property (nonatomic, strong) NSArray *comboBoxItems;

#pragma mark - Private Methods

- (void)setupComboBoxView;

- (void)updateComboBoxForSelectedComboBoxItemIndex;

- (void)setTitle:(NSString *)title;

#pragma mark - Action Methods

- (IBAction)expandCollapseButtonClicked:(id)sender;

@end

@implementation ComboBoxView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupComboBoxView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupComboBoxView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupComboBoxView
{
    if (nil == self.holderView)
    {
        self.holderView = [[UIView alloc] initWithFrame:self.bounds];
        [self.holderView setBackgroundColor:[UIColor whiteColor]];
        self.holderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.holderView];
    }
    
    if (nil == self.expandCollapseButton)
    {
        self.expandCollapseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.expandCollapseButton setFrame:self.holderView.bounds];
        [self.expandCollapseButton setBackgroundColor:[UIColor clearColor]];
        self.expandCollapseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.holderView addSubview:self.expandCollapseButton];
        [self.expandCollapseButton addTarget:self action:@selector(expandCollapseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (nil == self.expandCollapseButtonTitle)
    {
        self.expandCollapseButtonTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, (self.holderView.bounds.size.width - 15.0), self.holderView.bounds.size.height)];
        self.expandCollapseButtonTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.holderView addSubview:self.expandCollapseButtonTitle];
    }
    
    if (nil == self.comboBoxTableView)
    {
        self.comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 0.0) style:UITableViewStylePlain];
        [self.comboBoxTableView setDelegate:self];
        [self.comboBoxTableView setDataSource:self];
        [self addSubview:self.comboBoxTableView];
    }
    
    self.shouldShowFirstItemByDefault = YES;
    self.defaultTitle = DEFAULT_COMBO_STRING;
    self.selectedComboBoxItemIndex = -1;
    self.maxViewHeight = kComboBoxTableHeight;
    self.holderViewFrame = self.holderView.frame;
    
    [self.comboBoxTableView setHidden:YES];
    self.comboBoxTableView.backgroundColor = [UIColor clearColor];
    self.comboBoxTableView.layer.cornerRadius = 5.0;
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)updateComboBoxForSelectedComboBoxItemIndex
{
    if (self.shouldShowFirstItemByDefault)
    {
        if (-1 != self.selectedComboBoxItemIndex)
        {
            [self setTitle:[self.comboBoxItems objectAtIndex:self.selectedComboBoxItemIndex]];
        }
    }
    else
    {
        if (-1 != self.selectedComboBoxItemIndex)
        {
            [self setTitle:[self.comboBoxItems objectAtIndex:self.selectedComboBoxItemIndex]];
        }
        else
        {
            [self setTitle:self.defaultTitle];
        }
    }
}

- (void)setTitle:(NSString *)title
{
    [self.expandCollapseButtonTitle setText:title];
}

#pragma mark - Action Methods

- (IBAction)expandCollapseButtonClicked:(id)sender
{
    CGFloat comboBoxTableHeight = (([self.comboBoxTableView isHidden])?(MIN(self.maxViewHeight, ([self.comboBoxItems count] * self.holderViewFrame.size.height))):0.0f);
    CGRect comboBoxTableFrame = CGRectMake(self.expandCollapseButton.frame.origin.x, 0.0, self.expandCollapseButton.frame.size.width, comboBoxTableHeight);
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = ((0 < comboBoxTableHeight)?comboBoxTableHeight:self.holderViewFrame.size.height);
    if (comboBoxTableHeight > 0)
    {
        [self.holderView setFrame:self.holderViewFrame];
        [self.comboBoxTableView setFrame:CGRectMake(self.comboBoxTableView.frame.origin.x, self.comboBoxTableView.frame.origin.y, self.comboBoxTableView.frame.size.width, 0.0)];
        
        [self bringSubviewToFront:self.comboBoxTableView];
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if (nil != keyWindow)
        {
            CGRect frm = [self.holderView convertRect:self.holderView.frame toView:keyWindow];
            frm.origin.y += self.holderView.bounds.size.height + 2;
            
            UIView *comboBoxTableHolderView = [[UIView alloc] initWithFrame:keyWindow.bounds];
            [comboBoxTableHolderView setTag:COMBO_BOX_TABLE_HOLDER_VIEW_TAG];
            [comboBoxTableHolderView setBackgroundColor:[UIColor clearColor]];
            [comboBoxTableHolderView addSubview:self.comboBoxTableView];
            [keyWindow addSubview:comboBoxTableHolderView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            [tapGesture setDelegate:self];
            [comboBoxTableHolderView addGestureRecognizer:tapGesture];
            
            comboBoxTableFrame.origin = frm.origin;
            [self.comboBoxTableView setFrame:frm];
            
            if ((comboBoxTableFrame.origin.y + comboBoxTableFrame.size.height) > keyWindow.bounds.size.height)
            {
                comboBoxTableFrame.origin.y = (frm.origin.y - comboBoxTableFrame.size.height - frm.size.height - 4);
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(expandedComboBoxView:)])
            [self.delegate expandedComboBoxView:self];
    }
    else
    {
        [self.expandCollapseButtonTitle setHidden:NO];
        [self bringSubviewToFront:self.holderView];
        
        if ([self.delegate respondsToSelector:@selector(collapseComboBoxView:)])
            [self.delegate collapseComboBoxView:self];
    }
    
    [self.comboBoxTableView reloadData];
    
    [self.comboBoxTableView setHidden:((0 < comboBoxTableHeight)?NO:[self.comboBoxTableView isHidden])];
    if (![self.comboBoxTableView isHidden])
        [[self superview] bringSubviewToFront:self];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.comboBoxTableView setFrame:comboBoxTableFrame];
                     }completion:^(BOOL finished){
                         [self.comboBoxTableView setHidden:((0 < comboBoxTableHeight)?NO:YES)];
                         [self.holderView setFrame:self.holderViewFrame];
                         if ([self.comboBoxTableView isHidden])
                         {
                             UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                             if (nil != keyWindow)
                             {
                                 UIView *comboBoxTableHolderView = [keyWindow viewWithTag:COMBO_BOX_TABLE_HOLDER_VIEW_TAG];
                                 if (nil != comboBoxTableHolderView)
                                 {
                                     [comboBoxTableHolderView removeFromSuperview];
                                 }
                             }
                         }
                     }];
}

#pragma mark - Custom Methods

- (void)setTitleColor:(UIColor *)color
{
    [self.expandCollapseButtonTitle setTextColor:color];
}

- (void)setTitleFont:(UIFont *)font
{
    [self.expandCollapseButtonTitle setFont:font];
}

- (void)setPromptMessage:(NSString *)message
{
    if ((nil != message) && (0 < [message length]))
    {
        self.shouldShowFirstItemByDefault = NO;
        self.defaultTitle = message;
    }
}

- (void)updateWithAvailableComboBoxItems:(NSArray *)comboItems
{
    self.comboBoxItems = comboItems;
    if (self.shouldShowFirstItemByDefault && (-1 == self.selectedComboBoxItemIndex))
    {
        if (0 < [self.comboBoxItems count])
        {
            self.selectedComboBoxItemIndex = 0;
        }
    }
    
    [self updateComboBoxForSelectedComboBoxItemIndex];
}

- (void)updateWithSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex < [self.comboBoxItems count])
    {
        self.selectedComboBoxItemIndex = selectedIndex;
    }
    else if (self.shouldShowFirstItemByDefault)
    {
        if (0 < [self.comboBoxItems count])
        {
            self.selectedComboBoxItemIndex = 0;
        }
        else
        {
            self.selectedComboBoxItemIndex = -1;
        }
    }
    else
    {
        self.selectedComboBoxItemIndex = -1;
    }
    
    [self updateComboBoxForSelectedComboBoxItemIndex];
}

- (void)updateForViewFrameChanged
{
    self.holderViewFrame = self.bounds;
    
    if (nil != self.holderView)
    {
        self.holderView.frame = self.bounds;
    }
    
    if (nil != self.expandCollapseButton)
    {
        [self.expandCollapseButton setFrame:self.holderView.bounds];
    }
    
    if (nil != self.expandCollapseButtonTitle)
    {
        self.expandCollapseButtonTitle.frame = CGRectMake(15.0, 0.0, (self.holderView.bounds.size.width - 15.0), self.holderView.bounds.size.height);
    }
    
    if (nil == self.comboBoxTableView)
    {
        self.comboBoxTableView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.comboBoxTableView.frame.size.height);
    }
    self.holderViewFrame = self.holderView.frame;
}

- (void)collapseComboBoxView
{
    if (![self.comboBoxTableView isHidden])
        [self expandCollapseButtonClicked:nil];
}

- (void)setMaxComboBoxHeight:(CGFloat)maxHeight
{
    self.maxViewHeight = maxHeight;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.holderViewFrame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellTitle = @"";
    if (self.shouldShowFirstItemByDefault)
    {
        cellTitle = [self.comboBoxItems objectAtIndex:indexPath.row];
    }
    else
    {
        if (0 == indexPath.row)
        {
            cellTitle = self.defaultTitle;
        }
        else
        {
            cellTitle = [self.comboBoxItems objectAtIndex:(indexPath.row - 1)];
        }
    }
    [self setTitle:cellTitle];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self expandCollapseButtonClicked:nil];
    
    if ([self.delegate respondsToSelector:@selector(selectedItemAtIndex:fromComboBoxView:)])
    {
        if (self.shouldShowFirstItemByDefault)
        {
            [self.delegate selectedItemAtIndex:indexPath.row fromComboBoxView:self];
        }
        else
        {
            [self.delegate selectedItemAtIndex:(indexPath.row - 1) fromComboBoxView:self];
        }
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((self.shouldShowFirstItemByDefault)?[self.comboBoxItems count]:([self.comboBoxItems count] + 1));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"comboBoxItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [[cell textLabel] setTextColor:[self.expandCollapseButtonTitle textColor]];
        [[cell textLabel] setFont:[self.expandCollapseButtonTitle font]];
    }
    
    NSString *cellTitle = @"";
    if (self.shouldShowFirstItemByDefault)
    {
        cellTitle = [self.comboBoxItems objectAtIndex:indexPath.row];
        [cell setAccessoryType:(([[self.expandCollapseButtonTitle text] isEqualToString:cellTitle])?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone)];
    }
    else
    {
        if (0 == indexPath.row)
        {
            cellTitle = self.defaultTitle;
        }
        else
        {
            cellTitle = [self.comboBoxItems objectAtIndex:(indexPath.row - 1)];
            [cell setAccessoryType:(([[self.expandCollapseButtonTitle text] isEqualToString:cellTitle])?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone)];
        }
    }
    
    [[cell textLabel] setText:cellTitle];
    return cell;
}

#pragma mark - UIGestureRecognizer Methods

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateEnded == gesture.state)
    {
        [self expandCollapseButtonClicked:nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint(self.comboBoxTableView.frame, [touch locationInView:[self.comboBoxTableView superview]]))
    {
        return NO;
    }
    
    return YES;
}

@end
