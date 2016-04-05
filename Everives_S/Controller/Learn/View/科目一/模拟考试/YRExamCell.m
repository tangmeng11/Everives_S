//
//  YRExamCell.m
//  Everives_S
//
//  Created by 李洪攀 on 16/3/17.
//  Copyright © 2016年 darkclouds. All rights reserved.
//

#import "YRExamCell.h"

#define kDistace 10
@interface YRExamCell ()
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UIView *centerView;
@property (nonatomic, weak) UILabel *menuLabel;
@property (nonatomic, weak) UILabel *msgLabel;
@end
@implementation YRExamCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildUI];
    }
    return self;
}
-(void)buildUI
{
    UIView *backview = [[UIView alloc]init];
    [self addSubview:backview];
    _backView = backview;
    
    UIView *centerview = [[UIView alloc]init];
    [_backView addSubview:centerview];
    _centerView = centerview;
    
    UILabel *menulabel = [[UILabel alloc]init];
    menulabel.textAlignment = NSTextAlignmentCenter;
    menulabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:menulabel];
    _menuLabel = menulabel;
    
    UILabel *msglabel = [[UILabel alloc]init];
    msglabel.textAlignment = NSTextAlignmentLeft;
    msglabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:msglabel];
    _msgLabel = msglabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _backView.frame = CGRectMake(kDistace*2, kDistace, kDistace *2, kDistace*2);
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = _backView.height/2;
    _backView.layer.borderColor = [UIColor blueColor].CGColor;
    _backView.layer.borderWidth = 1;
    
    _centerView.frame = CGRectMake(0, 0, _backView.height/2, _backView.height/2);
    _centerView.center = CGPointMake(_backView.height/2, _backView.height/2);
    _centerView.layer.masksToBounds = YES;
    _centerView.layer.cornerRadius = _centerView.height/2;
//    _centerView.backgroundColor = [UIColor blueColor];
    
    _menuLabel.frame = _backView.frame;
    _menuLabel.layer.masksToBounds = YES;
    _menuLabel.layer.cornerRadius = _menuLabel.height/2;
    _menuLabel.layer.borderColor = [UIColor blueColor].CGColor;
    _menuLabel.layer.borderWidth = 1;
    
    _msgLabel.frame = CGRectMake(CGRectGetMaxX(_backView.frame)+kDistace, 0, kScreenWidth-kDistace*3-CGRectGetMaxX(_backView.frame), 40);
}
-(void)setExamBool:(BOOL)examBool
{
    _examBool = examBool;
}
-(void)setMsgString:(NSString *)msgString
{
    _msgString = msgString;
    if ([@[@"正确",@"错误"] containsObject:msgString]) {
        _menuLabel.hidden = YES;
        _backView.hidden = NO;
        _centerView.hidden = NO;
    }
    _msgLabel.text = msgString;
}
-(void)setMenuString:(NSInteger)menuString
{
    _menuString = menuString;
    NSString *menuMsg;
    if (menuString == 0) {
        menuMsg = @"A";
    }else if (menuString == 1){
        menuMsg = @"B";
    }else if (menuString == 2){
        menuMsg = @"C";
    }else{
        menuMsg = @"D";
    }
    _menuLabel.text = menuMsg;
    _menuLabel.hidden = NO;
    _backView.hidden = YES;
    _centerView.hidden = YES;
}
-(void)setQuest:(YRQuestionObj *)quest
{
    _quest = quest;
    if (self.examBool) {//考试状态
        if (!quest.currentError) {
            if (quest.option.count == 4) {//单选题
                _menuLabel.textColor = [UIColor blackColor];
                _menuLabel.backgroundColor = [UIColor whiteColor];
            }else{
                _centerView.hidden = YES;
            }
            return;
        }
         if (quest.option.count == 4) {//单选题
             NSInteger chooseInt;
             if (quest.chooseAnswer>2) {
                 chooseInt = quest.chooseAnswer==4?3:4;
             }else
                 chooseInt = quest.chooseAnswer;
             if ([quest.option[chooseInt-1] isEqualToString:_msgLabel.text]) {//选项
                 _menuLabel.textColor = [UIColor whiteColor];
                 _menuLabel.backgroundColor = [UIColor lightGrayColor];
             }else{
                 _menuLabel.textColor = [UIColor blackColor];
                 _menuLabel.backgroundColor = [UIColor whiteColor];
             }
         }else{//判断题
             if ([quest.option[quest.chooseAnswer-1] isEqualToString:_msgLabel.text]) {//选项正确
                 _centerView.backgroundColor = [UIColor lightGrayColor];
             }else{
                 _centerView.hidden = YES;
             }
         }
        return;
    }
    if (quest.option.count == 4) {//单选题
        NSInteger chooseInt;
        if (quest.answer>2) {
            chooseInt = quest.answer==4?3:4;
        }else
            chooseInt = quest.answer;
        
        if (quest.currentError) {
            if ([quest.option[chooseInt-1] isEqualToString:_msgLabel.text]) {//选项正确
                _menuLabel.textColor = [UIColor greenColor];
            }else{
                NSInteger errorInt;
                if (quest.chooseAnswer>2) {
                    errorInt = quest.chooseAnswer==4?3:4;
                }else
                    errorInt = quest.chooseAnswer;
                
                if (quest.currentError == 1) {
                    _menuLabel.textColor = [UIColor blackColor];
                }else{
                    if ([quest.option[errorInt-1] isEqualToString:_msgLabel.text]) {//选错的
                        _menuLabel.textColor = [UIColor redColor];
                    }
                }
            }
    
        }else{
            _menuLabel.textColor = [UIColor blackColor];
        }
    }else{//判断题
        if (quest.chooseAnswer) {//选择了
            _centerView.hidden = NO;
            if (quest.chooseAnswer == quest.answer) {//选择正确
                if ([quest.option[quest.chooseAnswer-1] isEqualToString:_msgLabel.text]) {
                    _centerView.backgroundColor = [UIColor greenColor];
                }else{
                    _centerView.hidden = YES;
                }
            }else{//选错了
                if ([quest.option[quest.answer-1] isEqualToString:_msgLabel.text]) {
                    _centerView.backgroundColor = [UIColor greenColor];
                }else{
                    _centerView.backgroundColor = [UIColor redColor];
                }
            }
        }else{//新题
            _centerView.hidden = YES;
        }
    }
}
@end
