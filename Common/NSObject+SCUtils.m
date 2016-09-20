@implementation NSObject (SCUtils)

char defaultAssociatedKey;

- (void) setAssociatedObject: (id)associatedObject {
    [self setAssociatedObject:associatedObject forKey:&defaultAssociatedKey];}

- (id) associatedObject {
    return [self associatedObjectForKey:&defaultAssociatedKey];
}

- (void) setAssociatedObject: (id)object forKey: (void*)key {
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN);
}

- (id) associatedObjectForKey: (void*)key {
    return objc_getAssociatedObject(self, key);
}
@end
