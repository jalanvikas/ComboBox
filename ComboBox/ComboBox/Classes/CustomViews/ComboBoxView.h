//
//  ComboBoxView.h
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


@class ComboBoxView;

@protocol ComboBoxViewDelegate <NSObject>

@optional
- (void)expandedComboBoxView:(ComboBoxView *)comboBoxView;
- (void)collapseComboBoxView:(ComboBoxView *)comboBoxView;

@required
- (void)selectedItemAtIndex:(NSInteger)selectedIndex fromComboBoxView:(ComboBoxView *)comboBoxView;

@end



@interface ComboBoxView : UIView

@property (nonatomic, assign) id<ComboBoxViewDelegate> delegate;

#pragma mark - Custom Methods

- (void)setTitleColor:(UIColor *)color;

- (void)setTitleFont:(UIFont *)font;

/*
    This method is used to set the items which combo box can show.
 
@comboItems: NSArray of NSString objects.
 */
- (void)updateWithAvailableComboBoxItems:(NSArray *)comboItems;

/*
    This method should be should be called after setting the comboBoxItems and the index beyound range will be reset to first index.
*/
- (void)updateWithSelectedIndex:(NSInteger)selectedIndex;

- (void)collapseComboBoxView;

- (void)setMaxComboBoxHeight:(CGFloat)maxHeight;

@end
