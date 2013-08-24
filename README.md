project name :mls- Localized.string文件合并工具

全名为：MergeLocalizedString

（我的英文不好，大概将就是这个意思吧，记得有一个次和老外工程师用skype沟通，最后总监兼翻译痛苦的对我说：你还是用中文吧，我来帮你翻译）

我管这种代码叫“一锤子代码”，大意就是八百年都用不上一回，但是眼下又非用不可的那种。

比如，网上找不到现成的解决方案，或者找到貌似很美的方案但是自己却搞不定，同事又给不了有效支持，然后老板拿着皮鞭站在身后.... 所以，这时候只能头顶炸药包自己动手写点力所能及的东西；也许已经有很多人做过类似的东西，我找不见啊.....



用法：

./mls old.strings new.strings


说明：

（1）./表示当前目录哦

（2）mls 其实就是项目名称，项目打好包后自己改名为mls就可以了。

（3）合并两个Localized.strings文件，把old.strings文件合并到new.strings文件里。
如果new.strings里包含old.strings里的key,那么就用old.strings里key对应的value来替换new.strings里对应key的value. 

（4）old.strings,new.strings ： localized.sting文件的文件名；

（5）如果合并成功，会在当前目录自动生成一个文件：out.strings   (如果原先已经存在out.strings文件，则该文件会被覆盖)

（6）mac下测试ok，其他的系统没有试过。





