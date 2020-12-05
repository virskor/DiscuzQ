# 关于编辑器这是一个很重要的组件，所以除了的代码中的注释，这里还需要理清一些逻辑，也便自己后面更新

## 工具栏
编辑器的工具栏，基础控件包含 表情，图片上传，附件上传。但是如果编辑器在markdown模式下，则拓展了discuzToolbarMarkdownItems。这里需要注意，非markdown模式下，我们是不会用到formater处理编辑中的文字的。后面我们会描述如何安全的拓展一个工具栏，或者formater。


## 编辑器交互逻辑
用户在编辑的过程中，会产生DiscuzEditorData 模型的数据，里面除了包含编辑器内容，实际上还包含了最终会被用于提交到服务端对的数据信息。所以，编辑器其实从头到尾，就是在用户的操作过程中，生成DiscuzEditorData模型的数据，最终通过DiscuzEditorDataFormater完成数据的双向转化。tojson 或者 fromJson。  
这样一来，当要增加字段的时候，首先要考虑更新 DiscuzEditorData 包含的数据，其次在增加要拓展的toolbar或者处理逻辑。 格式化数据的时候，则要在DiscuzEditorDataFormater中进行。

### 首先说明EditorState
编辑的过程中，并不会生成 DiscuzEditorData，而是在更新EditorState，只有在一些条件下，才会触发onChanged，这个时候得到DiscuzEditorData。所以，需要注意 state/editorState.dart中托管的数据。但是值得注意的是，EditorState却又不会完整的托管编辑器的内容。这样的设计看起来是乱糟糟，但是是有原因的。

先说说 EditorState 托管的东西，他们分别是用户上传的图片数据，和用户数上传的附件数据。这么一说你应该猜到为什么会分离这些数据成状态了，因为在编辑器不同的组件传递这些数据，代价太大，因为我们不知道这些数据长度将会是怎么样，如果很长，在不停的传递的时候，就会有性能代价。


## 格式化数据
首先 DiscuzEditorDataFormater 和其他的Formater实际上有区别，这是用来格式化数据的，而其他的formater则是将用户输入的字符串数据，parse成一个flutter widget，这样便完成了编辑器用户点击表情，编辑器呈现表情，或者可视化的编辑markdown数据。  
DiscuzEditorDataFormater只会有2个方法，他们分别将外部数据 处理成DiscuzEditorData，或者将DiscuzEditorData转化为用于提交的外部数据的格式。  
