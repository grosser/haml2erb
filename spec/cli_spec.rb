describe "CLI" do
  before :all do
    ENV["PATH"] = "#{File.join(File.dirname(__FILE__),"..","bin")}:#{ENV["PATH"]}"
  end

  def run(command, options={})
    result = `#{command}`
    raise "FAILED #{command} : #{result}" if $?.success? == !!options[:fail]
    result
  end

  def write(file, content)
    run "mkdir -p #{File.dirname(file)}"
    File.open(file, 'w'){|f| f.write content }
  end

  around do |example|
    dir = "spec/tmp"
    run "rm -rf #{dir}"
    run "mkdir #{dir}"
    Dir.chdir dir do
      example.run
    end
  end

  it "prints help" do
    result = run "haml2erb --help"
    result.should include("Convert files from haml 2 erb.")
  end

  it "does nothing without arguments" do
    result = run "haml2erb"
    result.should == ""
  end

  it "prints version" do
    result = run "haml2erb --version"
    result.should =~ /\d+\.\d+\.\d+/
  end

  it "converts a single file" do
    file = "xxx.html.haml"
    write(file, ".foo")
    run "haml2erb #{file}"
    File.exist?(file).should == false
    File.read("xxx.html.erb").should == "<div class='foo'>\n</div>\n"
  end

  it "converts a folder" do
    file = "folder/xxx.html.haml"
    write(file, ".foo")
    run "haml2erb folder"
    File.exist?(file).should == false
    File.read("folder/xxx.html.erb").should == "<div class='foo'>\n</div>\n"
  end

  it "converts a folder with trailing slash" do
    file = "folder/xxx.html.haml"
    write(file, ".foo")
    run "haml2erb folder/"
    File.exist?(file).should == false
    File.read("folder/xxx.html.erb").should == "<div class='foo'>\n</div>\n"
  end

  it "converts in sub-folder" do
    file = "folder/sub/xxx.html.haml"
    write(file, ".foo")
    run "haml2erb folder"
    File.exist?(file).should == false
    File.read("folder/sub/xxx.html.erb").should == "<div class='foo'>\n</div>\n"
  end
end
