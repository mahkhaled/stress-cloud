experiments = 2
interval = 3

threads = []

1.upto experiments do |i|
  threads << Thread.new do
    sleep (i-1) * interval
    puts `rspec`
  end
end

threads.each(&:join)


