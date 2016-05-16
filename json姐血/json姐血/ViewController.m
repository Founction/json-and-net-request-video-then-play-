//
//  ViewController.m
//  json姐血
//
//  Created by 李胜营 on 16/5/16.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

static NSString *ID = @"reuse";
@interface ViewController ()

/* videos */
@property (strong, nonatomic) NSMutableArray * videos;
/* <#信息#> */
@property (strong, nonatomic) NSDictionary * dic;

@end

@implementation ViewController

- (NSMutableArray *)videos
{
    if (_videos == nil)
    {
        _videos = [NSMutableArray array];
    }

    return _videos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //在get方法的时候，拼接请求参数
    NSString *httpUrl = @"http://120.25.226.186:32812/video";

    //0.设置请求路径
//    NSURL *url = [NSURL URLWithString:url];
    NSURL *url = [NSURL URLWithString: httpUrl];
    //1.根据url创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData *data, NSError *connectionError){
        
        NSLog(@"%@",data);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.videos = dic[@"videos"];
        [self.tableView reloadData];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark tableview数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    NSDictionary *video = self.videos[indexPath.row];
    cell.textLabel.text = video[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时长：%@", video[@"length"]];
    
    //获得下载路径，为当前路径加上图片名称
    NSString *path = [NSString stringWithFormat:@"http://120.25.226.186:32812/%@",video[@"image"]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}
#pragma -mark tableview 代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *video = self.videos[indexPath.row];
    NSString *urlStr = [@"http://120.25.226.186:32812" stringByAppendingPathComponent:video[@"url"]];
    
    //创建播放控制器
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
    
    AVPlayerViewController *pvc = [[AVPlayerViewController alloc] init];
    pvc.player = [AVPlayer playerWithURL:[NSURL URLWithString:urlStr]];
    [pvc.player play];
    NSLog(@"%@",urlStr);
    [self presentViewController:vc animated:YES completion:nil];
    
    

}
@end
