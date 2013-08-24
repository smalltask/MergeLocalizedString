project name :mls- Localized.string文件合并工具
全名为：MergeLocalizedString
（我的英文不好，大概将就是这个意思吧，记得有一个次和老外工程师用skype沟通，最后总监兼翻译痛苦的对我说：你还是用中文吧，我来帮你翻译）

用法：
./mls old.strings new.strings

说明：
（1）./表示当前目录哦
（2）mls 其实就是项目名称，项目打好包后自己改名为mls就可以了。
（2）合并两个Localized.strings文件，把old.strings文件合并到new.strings文件里。
如果new.strings里包含old.strings里的key,那么就用old.strings里key对应的value来替换new.strings里对应key的value. 
（3）old.strings,new.strings ： localized.sting文件的文件名；
（4）如果合并成功，会在当前目录自动生成一个文件：out.strings   (如果原先已经存在out.strings文件，则该文件会被覆盖)
（4）mac下测试ok，其他的系统没有试过。





