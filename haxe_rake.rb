require 'rexml/document'

# runs a command and says "y" to any questions
def run(command)
  IO.popen(command, "r+") do |f|
    f.puts "y"
    puts f.gets
  end
end

class XmlFile

  attr_accessor :path
  
  def open
    @xmldoc = REXML::Document.new(File.read(@path))
  end
  
  def save
    f = File.open(@path, 'w')
    @xmldoc.write f, 2
    f.close
  end
  
end

class IntellijProjectFile < XmlFile
  
  def initialize
  end
  
  def add_dependency(dependency)
    libname = "#{dependency.name}-#{dependency.version}"
    libpath = "file://#{dependency.path}"
    
    # check if the dependency exists in the xml already
    xmlel = @xmldoc.elements["*/component/library[@name='#{libname}']"]
    if xmlel != nil
      return
    end
    
    # adds it to the xml
    libtable = @xmldoc.elements["*/component[@name='libraryTable']"]
    if libtable == nil
      libtable = @xmldoc.elements["project"].add_element "component", {"name" => "libraryTable"}
    end
    library_tag = libtable.add_element "library", {"name" => libname, "type" => "Haxe"}
    classes = library_tag.add_element "CLASSES"
    sources = library_tag.add_element "SOURCES"
    classes.add_element "root", {"url" => libpath}
    sources.add_element "root", {"url" => libpath}
  end
  
end

class IntellijModuleFile < XmlFile
  
  def add_dependency(dependency)
    libname = "#{dependency.name}-#{dependency.version}"
    libpath = "file://#{dependency.path}"
    
    # check if the dependency exists in the xml already
    xmlel = @xmldoc.elements["*/component/orderEntry[@name='#{libname}']"]
    if xmlel != nil
      return
    end
    
    # adds it to the xml
    modrootmgr = @xmldoc.elements["*/component[@name='NewModuleRootManager']"]
    ordentry_tag = modrootmgr.add_element "orderEntry", {"name" => libname, "type" => "library", "level" => "project"}
  end
  
end

# a single haxe dependency
class Dependency
  attr_accessor :name
  attr_accessor :version
  
  def install
    run "haxelib install #{@name} #{@version}"
  end
  
  def load
    run "haxelib set #{@name} #{@version}"
  end
  
  def print
    puts "#{@name} #{@version}"
  end
  
  def path
    out = IO.popen("haxelib config")
    libroot = out.readlines[0]
    libroot.strip!
    commaver = @version.gsub(".",",")
    File.join(libroot, @name, commaver)
  end

end

# A build target
class Target
  attr_accessor :name
  attr_accessor :tasks

  def initialize
    @tasks = []
  end

  def declare
    task @name do
      @tasks.each do |t|
        t.run
      end
    end
  end

  def add_task(task)
    @tasks.push(task)
  end
end

# A build task
class Task
end

# An hxml build task
class HxmlTask < Task

  attr_accessor :file
  attr_accessor :flags
  attr_accessor :working_dir

  def initialize
    @file = ""
    @flags = ""
    @working_dir = ""
  end

  def run
      Dir.chdir(@working_dir) do
        sh "haxe #{@file} #{@flags}"
      end
  end
end

class Targets
  def initialize
  end

  def target(name, &body)
    target = TargetDsl.new
    target.name = name
    target.declare
  end
end

class TargetDsl < Target
  def initialize
  end

  def name(n)
    name = n
  end

  def hxml(file, flags, working_dir)
    task = HxmlTask.new
    task.file = file
    task.flags = flags
    task.working_dir = working_dir
    add_task(task)
  end
end

def targets(&body)
  t = Targets.new
  t.instance_eval(&body)
end

# specifies the dependency DSL
class Dependencies
  
  def initialize
    @dependencies = []
  end
  
  def dependency(name, version)
    dep = Dependency.new()
    dep.name = name
    dep.version = version
    @dependencies.push(dep)
  end
  
  def process(&deps)
    instance_eval &deps
  end
 
  def each(&block)
    @dependencies.each &block
  end
  
  def [](key)
    @dependencies[key]
  end
 
end

$dependencies = Dependencies.new

def dependencies(&deps)
  $dependencies.process(&deps)
end

# specifies the intellij dsl
class Intellij

  attr_accessor :dependencies

  def initialize
    @projects = []
  end

  def process(&body)
    instance_eval &body
  end

  def project(path)
    proj = IntellijProjectFile.new
    proj.path = path
    @projects.push(proj)
  end

  def open_all
    @projects.each do |p|
      p.open
    end
  end

  def project_module(path)
    mod = IntellijModuleFile.new
    mod.path = path
    @projects.push(mod)
  end

  def add_dependency(dependency)
    @projects.each do |p|
      p.add_dependency dependency
    end
  end

  def save_all
    @projects.each do |p|
      p.save
    end
  end

end

$intellij = Intellij.new

def intellij(&body)
  $intellij.process(&body)
end


####################
# RAKE STUFF      ##
####################

flags = ""
target = "neko"

#
# Processes command line attributes. Current options are:
#
# debug=true: Enables debug flags for lime
#
if ENV["debug"] == "true"
  flags = "-debug -DHX_DEBUG"
end

# ---------------------------------------------------------
# SUBTASKS
# ---------------------------------------------------------
# Those are not called directly through the command line, unless
# you really want to.
#

#
# Updates the intellij file with the project dependencies
#
task :intellij do

  $intellij.open_all
  $dependencies.each do |d|
    $intellij.add_dependency d
  end

  $intellij.save_all
end

#
# Installs all the dependencies and ensures that they are
# loaded
#
task :install_dependencies do
  $dependencies.each do |d|
    d.install
    d.load
  end
end

#
# Checks if the target argument was set, and if so, sets the target variable
# accordingly.
#
task :process_target, [:target] do |t, args|
  if args.target != nil
    target = args.target
  end
end

#
# Runs tests with line number resolver
#
task :test_line do
  Dir.chdir("src") do
    sh "./test.sh"
  end
end

# ---------------------------------------------------------
# Main Tasks
# ---------------------------------------------------------
# You should call those through the command line

#
# Installs and loads all the dependencies set above.
# Will also update the intellij file
#
task :dependencies => [:install_dependencies, :intellij] do
end

#
# Compiles the game, without running it.
#
task :compile, [:target] => :process_target do
  Dir.chdir("src/main") do
    sh "lime build #{flags} #{target}"
  end
end

#
# Compiles and runs the main game
#
task :run, [:target] => :process_target do
  Dir.chdir("src/main") do
    sh "lime test #{flags} #{target}"
  end
end

#
# Compiles unit tests without running
#
task :test_compile, [:target] => :process_target do
  Dir.chdir("src/test") do
    sh "lime build #{flags} #{target}"
  end
end

#
# Runs unit tests
#
task :test, [:target] => :process_target do
  sh "haxe test.neko.hxml #{flags}"
end

task :default, [:target] => [:dependencies, :compile]