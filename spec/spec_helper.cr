require "spec"
require "baked_file_system"

class FileStorage
	extend BakedFileSystem
	
	bake_folder "../resources"
end

module Osu
	PATH = "./test"
	AUTH = FileStorage.get("osu!auth.dll")	
end

if Dir.exists?(Osu::PATH)
	Dir.new(Osu::PATH).each_child { |child| File.delete("#{Osu::PATH}/#{child}") }
	Dir.delete(Osu::PATH)
end

Dir.mkdir Osu::PATH
File.write("#{Osu::PATH}\\.require_update", "")
File.write("#{Osu::PATH}\\osu!auth.dll", "test")
