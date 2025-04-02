目的： 解决状态变量过多带来的复杂性
MVVM
- Model：数据层 业务逻辑层
	- repository
		- http
		- database
		- sp
- View：UI呈现  
	- views 内部组件 
		- 持有ViewModel中的状态 
		- 只能在当前页面使用
	- shared 共享组件 
		- 不持有ViewModel 
		- 可以在多个页面使用
- ViewModel：管理UI状态与交互逻辑
	- 将Model层的数据转化为UI层需要的状态
	- 将UI层的交互传递到数据层
	- 可以存储UI页面的辅助数据 页面滑动位置、选中状态、是否显示等



