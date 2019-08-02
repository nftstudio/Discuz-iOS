//
//  publicpmCell.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/10/15.
//  Copyright © 2015年 Cjk. All rights reserved.
//

#import "publicpmCell.h"
#import "FontSize.h"
@implementation publicpmCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 49, 49)];
//    self.headImageView.backgroundColor = [UIColor redColor];
    self.headImageView.image = [UIImage imageNamed:@"消息"];
    [self addSubview:self.headImageView];
    
    CGRect frame = self.headImageView.frame;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 10, 190, 15)];
    self.nameLabel.font = [FontSize forumtimeFontSize14];//13-14
    self.nameLabel.textColor = MAIN_COLLOR;
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-100, 10,90, 15)];
    self.timeLabel.font = [FontSize HomecellmessageNumLFontSize10];//10
    self.timeLabel.textColor = mRGBColor(180, 180, 180);
    [self addSubview:self.timeLabel];
    
    self.contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 25, WIDTH-(frame.size.width+20+10), 45)];
    self.contenLabel.font =  [FontSize forumInfoFontSize12];//12
    self.contenLabel.numberOfLines = 0;
    [self addSubview:self.contenLabel];
    
}

-(void)setdata:(NSDictionary*)dic{
    //    self.contenLabel.text =@"现在的小型SUV市场中竞争激励,价格也是现在的小型SUV市场中竞争激励";
    //    self.nameLabel.text = @"admin";
    //    self.timeLabel.text = @"2015-3-23";
    
    //    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"vdateline"]integerValue]];
    //    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    //    NSString * timeStr = [Utils getDateStringWithDate:[dic objectForKey:@"vdateline"] DateFormat:@"yyyy-MM-dd HH:mm"];
    if ([DataCheck isValidString:[dic objectForKey:@"id"]]) {// 是否是系统消息
        // 是系统消息
        NSString * timeStr = [NSDate timeStringFromTimestamp:[dic objectForKey:@"dateline"] format:@"yyyy-MM-dd"];
        self.timeLabel.text = [timeStr transformationStr];
        NSLog(@"%@",[dic objectForKey:@"dateline"]);
        NSLog(@"%@",[dic objectForKey:@"message"]);
        self.contenLabel.text = [dic objectForKey:@"message"];
        self.nameLabel.text =@"系统消息";
    }
//    NSString * timeStr = [Utils getDateStringWithDate:[dic objectForKey:@"vdateline"] DateFormat:@"yyyy-MM-dd"];
    //    self.timeLable.text = timeStr;
    
    //  时间不用转换  直接写上就行
    //    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    //    content = [content stringByReplacingOccurrencesOfString:@"nbsp;" withString:@" "];
    //
//    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar.php?uid=%@&size=small",BASEURL,[dic objectForKey:@"touid"]]];
//    [self.headImageView sd_setImageWithURL:url placeholderImage:nil];
    
}


+ (NSString *)getDateStringWithDate:(NSString *)dateStr
                         DateFormat:(NSString *)formatString
{
    
    double unixTimeStamp = [dateStr doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:formatString];
    NSString *_date=[_formatter stringFromDate:date];
    
    return _date;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
