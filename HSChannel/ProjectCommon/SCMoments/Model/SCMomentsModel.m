
#import "SCMomentsModel.h"

@implementation SCMomentsModel
#ifdef SC_TP_KEYVALUE_MAPPING
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self updateWithDictionary:dic];
    }
    return self;
}

- (void) updateWithDictionary: (NSDictionary*)dic
{

    if (!_dicParser) {
        
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        
        [self additionParserConfig:config];
        
        _dicParser = [DCKeyValueObjectMapping mapperForClass:self.class andConfiguration:config];
        
    }
    [_dicParser updateObject:self withDictionary:dic];

}

- (void)additionParserConfig:(DCParserConfiguration*)config{
    
}
#endif

- (NSString *)time
{
    return @"1分钟之前";
}

- (NSMutableAttributedString *)likesStr
{
//    NSString *result = @"";
//    for (int i = 0; i < self.likeItemsArray.count; i++) {
//        
//        SCMomentsCellLikeItemModel *like = self.likeItemsArray[i];
//        if (i == 0) {
//            result = [NSString stringWithFormat:@"%@",like.userName];
//        }else {
//            result = [NSString stringWithFormat:@"%@, %@", result, like.userName];
//        }
//        
//    }
//    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
//    NSUInteger position = 0;
//    for (int i = 0; i < self.likeItemsArray.count; i++) {
//        SCMomentsCellLikeItemModel *like = self.likeItemsArray[i];
//        [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)like.userId] range:NSMakeRange(position, like.userName.length)];
//        position += like.userName.length + 2;
//    }
//    return attrStr;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < self.likeItemsArray.count; i++) {
        SCMomentsCellLikeItemModel *model = self.likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        [attributedText appendAttributedString:[self generateAttributedStringWithLikeItemModel:model]];
        ;
    }
    
    return attributedText;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(SCMomentsCellLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}

@end

@implementation SCMomentsCellLikeItemModel

@end

@implementation SCMomentsCellCommentItemModel


@end