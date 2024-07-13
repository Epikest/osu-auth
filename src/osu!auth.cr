require "baked_file_system"
require "colorize"

class FileStorage
	extend BakedFileSystem
	
	bake_folder "../resources"
end

# Embed the working osu!auth.dll from the resources folder
osu_auth = FileStorage.get("osu!auth.dll")

# Extract the osu! game path from the Start Menu shortcut
osu_path = `wmic path win32_shortcutfile where "name='#{ENV["APPDATA"].gsub("\\", "\\\\")}\\\\Microsoft\\\\Windows\\\\Start Menu\\\\Programs\\\\osu!.lnk'" get target`.split("\n").find do |line|
	line.includes?("osu!.exe")
end.try do |line|
	line.strip.gsub("\\osu!.exe", "")
end || ""

# Extract the osu! game path from the registry (sometimes it's not accurate)
# osu_path = `reg query "HKLM\\SOFTWARE\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall" /s /f "osu!" /t REG_SZ`.split("\n").find do |line|
# 	line.includes?("DisplayIcon")
# end.try do |line|
# 	line.split("REG_SZ")[1].strip.gsub("\\osu!.exe", "")
# end || ""

# Hold the console open so the user can read the output
at_exit do
	print "Press any key to close..."
	STDIN.raw &.read_char
end

begin
	if Dir.exists?(osu_path)
		puts "Located directory: #{osu_path}"
	else
		puts "Could not locate osu! directory.".colorize(:red)
		exit 1
	end

	if File.exists?("#{osu_path}\\.require_update")
		File.delete("#{osu_path}\\.require_update")
		puts "Successfully deleted .require_update.".colorize(:green)
	else
		puts ".require_update not present, skipping."
	end
	
	if !File.exists?("#{osu_path}\\_staging")
		File.write("#{osu_path}\\_staging", "")
		puts "Successfully created _staging.".colorize(:green)
	else
		puts "_staging already created, skipping."
	end

	if !File.exists?("#{osu_path}\\osu!auth.dll.backup")
		File.rename("#{osu_path}\\osu!auth.dll", "#{osu_path}\\osu!auth.dll.backup")
		puts "Backed up #{File.size("#{osu_path}\\osu!auth.dll.backup")} bytes from current osu!auth.dll.".colorize(:green)
		File.write("#{osu_path}\\osu!auth.dll", osu_auth.read)
		puts "Successfully written #{osu_auth.size} bytes to osu!auth.dll.".colorize(:green)
	else
		print "A previous version of osu!auth.dll is currently backed up, overwrite? [y/N] ".colorize(:yellow)

		loop do
			case gets.not_nil!.strip.downcase[0]?
			when 'y'
				File.delete("#{osu_path}\\osu!auth.dll.backup")
				File.rename("#{osu_path}\\osu!auth.dll", "#{osu_path}\\osu!auth.dll.backup")
				File.write("#{osu_path}\\osu!auth.dll", osu_auth.read)
				puts "Successfully written #{osu_auth.size} bytes to osu!auth.dll".colorize(:green)
				break
			else
				puts "Abort."
				break
			end
		end
	end
rescue err
	STDERR.puts err.message.colorize(:red)
	exit 1
end
