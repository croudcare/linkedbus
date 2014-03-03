require 'pathname'

module LinkedBus::Pid

  def self.write(pidfile = './tmp/pids/linkedbus.pid')
    FileUtils.mkdir_p Pathname.new(pidfile).dirname
    File.open(pidfile, 'w') do |f|
      f.puts Process.pid
    end
  end


end