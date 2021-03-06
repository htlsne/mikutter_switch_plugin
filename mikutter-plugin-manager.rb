#! /usr/bin/env ruby
PREFIX_DISABLE = "__disabled__"
LENGTH_PREFIX_DISABLE = PREFIX_DISABLE.length

Dir.chdir(Dir.home + "/.mikutter/plugin")

class String
    def is_integer?
        self.to_i.to_s == self
    end
end

def get_plugin_arr
    arr_disabled = Dir.glob(PREFIX_DISABLE + "*").select {|f| !File.file?(f)}
    arr_enabled = Dir.glob("*").select {|f| !File.file?(f)} - arr_disabled
    return [arr_enabled, arr_disabled]
end

def show_plugins(arr_enabled, arr_disabled)
    puts "Enabled plugins:"
    arr_enabled.each_with_index do |plugin, i|
        printf("%2d %s\n", i, plugin)
    end
    puts
    puts "Disabled plugins:"
    arr_disabled.each_with_index do |plugin, i|
        printf("%2d %s\n", i, plugin)
    end
end

arr_enabled, arr_disabled = get_plugin_arr()
show_plugins(arr_enabled, arr_disabled)
puts

puts "Type 'h' to see help."
loop do
    print "command> "
    input = gets.chomp
    operation, argument = input.split()
    argument_int = argument.to_i

    case operation
    when "h", "help"
        puts "h, help:"
        puts "  See this help."
        puts "e, enable [plugin number]:"
        puts "  Enable plugin numberd [plugin number]."
        puts "d, disable [plugin number]:"
        puts "  Disable plugin numberd [plugin number]."
        puts "s, show:"
        puts "  Show plugin list."
        puts "q, quit, exit:"
        puts "  Quit this program."
    when "e", "enable"
        if argument.is_integer? and 0 <= argument_int \
                and argument_int < arr_disabled.length
            plugin_name = arr_disabled[argument_int]
            File.rename(plugin_name, \
                        plugin_name[LENGTH_PREFIX_DISABLE, plugin_name.length - 1])
            puts "Enabled " \
                + plugin_name[LENGTH_PREFIX_DISABLE, plugin_name.length - 1]
            sleep 1

            arr_enabled, arr_disabled = get_plugin_arr()
            show_plugins(arr_enabled, arr_disabled)
            puts
        else
            puts "Invalid argument"
        end
    when "d", "disable"
        if argument.is_integer? and 0 <= argument_int \
                and argument_int < arr_enabled.length
            plugin_name = arr_enabled[argument_int]
            File.rename(plugin_name, PREFIX_DISABLE + plugin_name)
            puts "Disabled " + plugin_name
            sleep 1

            arr_enabled, arr_disabled = get_plugin_arr()
            show_plugins(arr_enabled, arr_disabled)
            puts
        else
            puts "Invalid argument"
        end
    when "s", "show"
        show_plugins(arr_enabled, arr_disabled)
    when "q", "quit", "exit"
        exit
    else
        puts "Invalid command."
    end
end
