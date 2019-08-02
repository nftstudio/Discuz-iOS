//
//  ImagePickerView.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/9.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "ImagePickerView.h"

@interface ImagePickerView() <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *pickerCT;

@end

@implementation ImagePickerView


-(void)openSheet {
    
    //在这里呼出下方菜单按钮项
     UIActionSheet *action = [[UIActionSheet alloc]
                      initWithTitle:nil
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles: @"拍照", @"从手机相册获取",nil];
     [action showInView:self.navigationController.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        DLog(@"取消");
    }
    
    switch (buttonIndex) {
            
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}
//开始拍照
-(void)takePhoto {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        self.pickerCT.sourceType = sourceType;
        [self present];
    } else {
        DLog(@"模拟其中无法打开照相机，请在真机中使用");
    }
}

- (void)present {
    [self.navigationController presentViewController:self.pickerCT animated:YES completion:nil];
}

//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController * )picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
            UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            if (self.finishPickingBlock) {
                self.finishPickingBlock(image);
            }
        }];
    }
    
}

//打开本地相册
-(void)LocalPhoto {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    self.pickerCT.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self present];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIImagePickerController *)pickerCT {
    if (_pickerCT == nil) {
        _pickerCT = [[UIImagePickerController alloc]init];
        _pickerCT.delegate = self;
        _pickerCT.allowsEditing = YES;
    }
    return _pickerCT;
}
@end
