require "io/console"

puts $stdin.tty?
$stdin.noecho do
  puts "done"
end
