require "./spec_helper"

describe "osu!auth" do
	it "should locate the osu! directory" do
		Dir.exists?(Osu::PATH).should be_truthy
	end

	it "should delete .require_update if it exists" do
		if File.exists?("#{Osu::PATH}\\.require_update")
			File.delete("#{Osu::PATH}\\.require_update")
		end
		File.exists?("#{Osu::PATH}\\.require_update").should be_falsey
	end

	it "should create _staging if it doesn't exist" do
		if !File.exists?("#{Osu::PATH}\\_staging")
			File.write("#{Osu::PATH}\\_staging", "")
		end
		File.exists?("#{Osu::PATH}\\_staging").should be_truthy
	end

	it "should backup and write osu!auth.dll" do
		if !File.exists?("#{Osu::PATH}\\osu!auth.dll.backup")
			File.rename("#{Osu::PATH}\\osu!auth.dll", "#{Osu::PATH}\\osu!auth.dll.backup")
			File.write("#{Osu::PATH}\\osu!auth.dll", Osu::AUTH.read)
		end
		File.size("#{Osu::PATH}\\osu!auth.dll").should eq(Osu::AUTH.size)
		File.exists?("#{Osu::PATH}\\osu!auth.dll.backup").should be_truthy
	end
end
