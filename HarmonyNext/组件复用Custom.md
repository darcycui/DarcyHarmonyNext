组件复用Custom.md
- @Builder
	- 可以定义组件私有函数 仅当前组件可用
	- 可以定义全局函数 所有组件都可用 (推荐)
	- 函数可以带参数
	- 函数内不可以修改入参的值 
	- 函数内遵循UIu
	- 参数传递
		- 引用传递 使用对象字面量传递 (clas类型) 
		- 值传递 其他
 	- 不建议把状态变量传递给@Builder函数 会带来耦合性
	- 1个参数+引用传递 才能触发动态刷新
	- 2个及以上参数 不能触发动态刷新
	- 引用传递 类的所有属性都得赋值(即使有默认值)
	- 可以嵌套多层@Builder函数
	- 可以与@Component stuct嵌套
	- 在子组件child中使用, this-->child

- @LocalBuilder
	- 无论是否使用bind(this) 嵌套关系 与 状态变量的父子关系 始终一致
	- 只能定义组件私有函数 仅当前组件可用
	- 函数内直接使用this访问组件的状态变量(不推荐通过参数传递)
	- 按引用传递的参数 参数名使用```$$```
	- 不能被装饰器使用
	- 在子组件child中使用, this-->parent

- @BuilderParam
	- 用于声明@Builder函数类型的参数
	- 可以使用参数初始化
		- 对象字面量初始化
		- @Builderparam类型 和 Builder函数类型 要一致
		- 可以使用@Builder函数 也可以使用@LocalBuilder函数
	- 可以使用闭包初始化
		- @BuilderParam只有一个
		- @BuilderParam不带参数
	- 可以次用=>函数初始化
		- 使用箭头函数包一层 让this的指向当前组件

- wrapBuilder
	- 用于管理多个全局@Builder函数 (典型做法是将多个函数放入数组中,通过ForEach渲染)
	- 将@Builder函数包装成WrappedBuilder对象,从而可以在UI中使用
	- 只支持全局@Builder函数
	- 只能在当前组件内使用 XXXWrapBuilder.builder()
	- 只能初始化一次.重复初始化不生效


- @Styles
	- 用于修饰函数
	- 封装组件的"通用属性"、"通用事件"，方便复用通用样式(静态样式)
		- widh
		- height
		- backgroundColor
		- padding
		- margin
		- onClick

	- 可以定义为组件私有函数 省略function关键字
	- 可以定义为全局函数 需要function关键字
	- 函数不能声明参数
	- 函数内不能使用 if(true)逻辑
	- 只能在当前文件内使用，不能export

- @Extend
	- 用于修饰函数
	- 封装系统组件的属性、事件、方法，方便复用特定组件的样式
	- 只能定义为全局函数 需要function关键字
	- 函数可以声明参数
	- 参数可以是function 比如：onClick事件
	- 参数可以是状态变量，可以刷新UI
	- 函数内可以调用其他@Extend函数
	- 只能在当前文件使用，不支持export
	- 

- 继承AttributeModifier
	- 封装组件的属性、事件等，方便复用
	- 实现AttributeModifier接口  实现applyNormalAttribute()方法
	- 可以声明属性、构造方法
	- 可以在文件外使用，支持export

- stateStyles
	- 封装组件的动态样式--selector
		- focused
		- normal
		- pressed
		- disabled
		- selected

- @AnimatableExtend
	- 封装 需要跟随动画改变的自定义属性，方便复用

- @Require
	- 设置@Prop @State @Provider @BuilderParam 必须在构造方法初始化

- @Reusable
	- 修饰自定义组件，设置组件可复用
	- 
	- 

