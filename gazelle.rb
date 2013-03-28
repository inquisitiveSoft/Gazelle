#!/usr/bin/ruby

directory = ARGV[0]
secondArgument = ARGV[1]
clear = FALSE

if directory == "--clear"
	directory = secondArgument
	clear = TRUE
end


if !directory
	puts "Creates a .gz for each .html, .css and .js file within a folder\n	usage: gazelle [--clear] <directory>\n"
	exit
end

if directory[0,1] != "/"
	directory = File.expand_path(directory, Dir.pwd)
end

if !File.exists?(directory) || !File.directory?(directory)
	puts "Couldn't find the directory: #{directory}\n"
	exit
end

puts directory

numberOfFiles = 0

Dir.glob(directory + "/**/**.{html,js,css}").each do | path |
	if path.match(/(.*("|'))/)
		print "Skipped file: #{File.basename(path)}"
		next
	end

	gzipPath = path + ".gz";

	if !clear
		originalFile = File.open(path, "r")
		gzipFile = nil
		gzipFile = File.open(gzipPath, "r") if File.exists?(gzipPath) && !File.directory?(gzipPath)
		
		if originalFile && (!gzipFile || originalFile.mtime > gzipFile.mtime)
			system("gzip --stdout --best --force \"#{path}\" > \"#{gzipPath}\"")
			numberOfFiles += 1
		end

		originalFile.close
		gzipFile.close if gzipFile
	elsif File.exists?(gzipPath) && !File.directory?(gzipPath)
		begin
			File.delete(gzipPath)
			numberOfFiles += 1
		rescue
			print "Couldn't remove the file: #{gzipPath}"
		end
	end
end 


if !clear
	puts numberOfFiles > 0 ? "   Created gzip files for #{numberOfFiles} files\n" : "   No files to update\n"
else
	puts numberOfFiles > 0 ? "   Removed #{numberOfFiles} gzip files\n" : "   Didn't find any .gz files to remove\n"
end
