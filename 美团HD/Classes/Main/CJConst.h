#ifdef DEBUG
#define MTLog(...) NSLog(__VA_ARGS__)
#else
#define MTLog(...)
#endif

#define MTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MTGlobalBg MTColor(230, 230, 230)


extern NSString * const CJCityDidChangeNotification;
extern NSString * const CJSelectedCityName;


extern NSString * const CJCategoryDidChangeNotification;
extern NSString * const CJSelectedCategory;

extern NSString * const CJCategoryDidChangeNotification;
extern NSString * const CJSelectedCategory;
extern NSString * const CJSelectSubcategoryName;


extern NSString * const CJRegionDidChangeNotification;
extern NSString * const CJSelectedRegion;
extern NSString * const CJSelectSubRegionName;


extern NSString * const CJSortDidChangeNotification;
extern NSString * const CJSelectedSort;