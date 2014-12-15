//
//  MainViewController.m
//  ComboBox
//
//  Created by Vikas Jalan on 12/13/12.
//  Copyright 2012 http://www.vikasjalan.com All rights reserved.
//  Conacts on jalanvikas@gmail.com or contact@vikasjalan.com
//
//  Get the latest version from here:
//  https://github.com/jalanvikas/ComboBox
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

#import "MainViewController.h"
#import "ComboBoxView.h"

@interface MainViewController () <ComboBoxViewDelegate>

@property (nonatomic, weak) IBOutlet ComboBoxView *comboBox;

@property (nonatomic, strong) ComboBoxView *comboBox1;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableArray *values = [NSMutableArray arrayWithObjects:@"First object", @"Second object", @"Third object", @"Fourth object", @"Fifth object", nil];
    
    [self.comboBox setTitleColor:[UIColor blackColor]];
    [self.comboBox updateWithAvailableComboBoxItems:values];
    
    if (nil == self.comboBox1)
    {
        self.comboBox1 = [[ComboBoxView alloc] initWithFrame:CGRectMake(40, 40, 180, 40)];
        [self.comboBox1 setDelegate:self];
        [self.view addSubview:self.comboBox1];
    }
    
    [self.comboBox1 setTitleColor:[UIColor redColor]];
    [self.comboBox1 updateWithAvailableComboBoxItems:values];
    [self.comboBox1 updateWithSelectedIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ComboBoxViewDelegate Methods

- (void)expandedComboBoxView:(ComboBoxView *)comboBoxView
{
    
}

- (void)collapseComboBoxView:(ComboBoxView *)comboBoxView
{
    
}

- (void)selectedItemAtIndex:(NSInteger)selectedIndex fromComboBoxView:(ComboBoxView *)comboBoxView
{
    
}

@end
