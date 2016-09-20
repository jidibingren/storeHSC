
// 给一个不可修改的类（系统类）添加成员
@interface NSObject (SCUtils)
//set and get associatedObject for key
- (void) setAssociatedObject: (id)object forKey: (void*)key;
- (id) associatedObjectForKey: (void*)key;
//set and get associatedObject for default key
@property id associatedObject;
@end
