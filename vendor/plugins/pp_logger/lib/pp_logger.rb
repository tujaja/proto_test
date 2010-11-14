# PpLogger

require 'pp'

module Kernel

  def pp(*objs)
    stdout_sv = STDOUT.dup
    path = File.join(RAILS_ROOT, 'log', 'out.log')
    fo = File.open(path, 'a')
    STDOUT.reopen(fo)

    objs.each { |obj| PP.pp(obj) }

    STDOUT.reopen(stdout_sv)
    true
  end

  def p(*objs)
    stdout_sv = STDOUT.dup
    path = File.join(RAILS_ROOT, 'log', 'out.log')
    fo = File.open(path, 'a')
    STDOUT.reopen(fo)

    objs.each { |obj| print obj.inspect }
    print "\n"

    STDOUT.reopen(stdout_sv)
    true
  end

end

