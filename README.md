# UINavigationController-SeraphExtension
- An extension for UINavigationController, you can custom push/pop animation. 
- 轻耦合的UINavigationController扩展，可以自定义push/pop动画。

## How to use
- Step 1. add the extension to your project. Just drag the "UINavigationController+SeraphExtension" folder into your xcode
- Step 2. add import in your sourcefile `#import "UINavigationController+SE.h"`
- Step 3. use `- (void)se_pushViewController:(UIViewController *)viewController animated:(BOOL)animated type:(SENavigationControllerAnimationType)type;` to push a viewController instead of `- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated`

## 如何使用
- 步骤 1. 把这个扩展放入项目中。直接拖拽"UINavigationController+SeraphExtension"文件夹到源代码
- 步骤 2. 添加头文件`#import "UINavigationController+SE.h"`
- 步骤 3. 使用方法`- (void)se_pushViewController:(UIViewController *)viewController animated:(BOOL)animated type:(SENavigationControllerAnimationType)type;`来代替系统方法`- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated`

## What else ? / 还有啥？
- you can set animation duration / 你可以设置动画时间

```objective-c
self.navigationController.se_animationDuration = [NSNumber numberWithDouble:0.25]; // need a NSNumber wrapper here
```
- you can set whether to hide bottom bar / 你可以设置是否隐藏tabbar

```objective-c
self.navigationController.se_hidesBottomBarWhenPushed = [NSNumber numberWithBool:NO]; // need a NSNumber wrapper here
```

## Examples / 示例
- System style / 系统风格

![system](http://7xjjcp.com1.z0.glb.clouddn.com/github_UINavigationAnimationSystem.gif)

- Default style - push/pop with UINavigationBar / 与UINavigationBar一起push/pop样式

![default](http://7xjjcp.com1.z0.glb.clouddn.com/github_UINavigationAnimationDefault.gif)

- Fade style / 渐隐样式

![fade](http://7xjjcp.com1.z0.glb.clouddn.com/github_UINavigationAnimationFade.gif)

- Swing style / 风车样式

![swing](http://7xjjcp.com1.z0.glb.clouddn.com/github_UINavigationAnimationSwing.gif)

- Custom style(scale here) / 自定样式(这里是尺寸动画)

![custom](http://7xjjcp.com1.z0.glb.clouddn.com/github_UINavigationAnimationCustom.gif)
