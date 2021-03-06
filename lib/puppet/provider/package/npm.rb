# https://github.com/puppetlabs/puppetlabs-nodejs/blob/4ecf9f29639e936b6b1c92b6c2d99eddc3612767/lib/puppet/provider/package/npm.rb

require 'puppet/provider/package'

Puppet::Type.type(:package).provide :npm, :parent => Puppet::Provider::Package do
  desc "npm is package management for node.js. This provider only handles global packages."

  has_feature :versionable

  optional_commands :npm => 'npm'

  def self.npmlist
    begin
      output = npm('list', '--json', '--global')
      # ignore any npm output lines to be a bit more robust
      output = PSON.parse(output.lines.select{ |l| l =~ /^((?!^npm).*)$/}.join("\n"))
      @npmlist = output['dependencies'] || {}
    rescue Exception => e
      Puppet.debug("Error: npm list --json command error #{e.message}")
      @npmlist = {}
    end
  end

  def npmlist
    self.class.npmlist
  end

  def self.instances
    @npmlist ||= npmlist
    @npmlist.collect do |k,v|
      new({:name=>k, :ensure=>v['version'], :provider=>'npm'})
    end
  end

  def query
    list = npmlist

    if list.has_key?(resource[:name]) and list[resource[:name]].has_key?('version')
      version = list[resource[:name]]['version']
      { :ensure => version, :name => resource[:name] }
    else
      { :ensure => :absent, :name => resource[:name] }
    end
  end

  def latest
    if /#{resource[:name]}@([\d\.]+)/ =~ npm('outdated', '--global',  resource[:name])
      @latest = $1
    else
      @property_hash[:ensure] unless @property_hash[:ensure].is_a? Symbol
    end
  end

  def update
    resource[:ensure] = @latest
    self.install
  end

  def install
    if resource[:ensure].is_a? Symbol
      package = resource[:name]
    else
      package = "#{resource[:name]}@#{resource[:ensure]}"
    end

    if resource[:source]
      npm('install', '--global', resource[:source])
    else
      npm('install', '--global', package)
    end
  end

  def uninstall
    npm('uninstall', '--global', resource[:name])
  end
end
