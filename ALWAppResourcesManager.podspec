Pod::Spec.new do |s|
  s.name             = 'ALWAppResourcesManager'
  s.version          = '0.1.0'
  s.summary          = 'Tool to manage application common resources, also to provide resources management methods for other pods.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
该组件可用于统一管理App的字体、图片、音频、视频、bundle等资源文件。如字体等部分资源需要在主工程中添加，则需在主工程中注册该组件，并提供相应代理方法。建议将资源文件统一放于Assets文件夹中，并分门别类；bundle资源请直接放于Bundles文件夹根目录下，其他资源文件可建立子文件夹。其他组件可以创建本类的子类并重写currentMainBundle方法，即可复用其他方法用于读取组件内资源。
                       DESC

  s.homepage         = 'https://github.com/ALongWay/ALWAppResourcesManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lisong' => '370381830@qq.com' }
  s.source           = { :git => 'https://github.com/ALongWay/ALWAppResourcesManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'ALWAppResourcesManager/Classes/**/*'
  
  s.resource_bundles = {
     'ALWAppResourcesManagerComponent' => ['ALWAppResourcesManager/Assets/Images/*', 'ALWAppResourcesManager/Assets/Audios/*', 'ALWAppResourcesManager/Assets/Videos/*', 'ALWAppResourcesManager/Assets/Others/*', 'ALWAppResourcesManager/Assets/Bundles/*.bundle']
  }

end