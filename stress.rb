experiments = 1
interval = 70

threads = []

1.upto experiments do |i|
  File.write('foo.txt', '')
  threads << Thread.new do
    sleep (i-1) * interval
    puts `rspec`
  end
end

threads.each(&:join)


