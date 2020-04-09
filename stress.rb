experiments = 7
interval = 3

threads = []

1.upto experiments do |i|
  # File.write('foo.txt', '')
  threads << Thread.new do
    sleep (i-1) * interval
    puts `rspec`
  end
end

threads.each(&:join)


