Flutter自己写插件

新建flutter插件 android工程找不到io.flutter.plugin等插件是因为没有把flutter.jar依赖加进去
1、local.properties里增加 flutter_sdk
2、build.gradle里增加flutter.jar依赖库
//获取local.properties配置文件
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
localPropertiesFile.withReader('UTF-8') {
reader -> localProperties.load(reader)
}
}
//获取flutter的sdk路径
def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}
dependencies {
implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
compileOnly files("$flutterRoot/bin/cache/artifacts/engine/android-arm/flutter.jar")
compileOnly 'androidx.annotation:annotation:1.1.0'
}
再同步build之后，即可使用

自己新建插件步骤：
1、File-》new flutter project选择 Plugin，把包名等信息编辑之后完成
2、以上操作
3、自动生成的项目名.dart即为外部调用入口
4、android下生成的plugin即为会自动注册到generateplugin下的plugin入口
5、默认是MethodChannel的调用方法，如果需要EventChannel，需在里面直接增加EventChannel并注册监听，EventChannel的name不要跟MethodChannel的名字一致
6、项目名.drat 可增加单例模式，初始化MethodChannel 和 EventChannel
7、MethodChannel方法调用比较简单，不再赘述，下面主要讲一下EventChannel
8、EventChannel需要定义监听，监听到的信息做区分，然后分发到应用层去
9、需初始化的时候注册监听
eventchannel.receiveBroadcastStream().listen(_onEvent,onErroro:_onError)

_onEvent(Object event){
//处理返回的值进行分发
} _onError(Object error){}

9、用到StreamController
T可以是任何数据类型，map，对象均可以
  StreamController<T> _getStringStreamController =   StreamController.broadcast();

Stream<T> get getStringResp => _getStringStreamController .stream;

10、发送数据则在以上_onEvent中
用_getStringStreamController .add(传过来的值)

11、在客户端，initState中 则 单例项目名 类 .getStringResp.listener((event){
//此时event 跟以上add的值内容一模一样
})
12、至此EventChannel的使用结束
13参考实例





