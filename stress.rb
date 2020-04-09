experiments = 1
interval = 70

threads = []

1.upto experiments do |i|
  f = File.open('foo.txt')
  f.close
  threads << Thread.new do
    sleep (i-1) * interval
    puts `rspec`
  end
end

threads.each(&:join)


