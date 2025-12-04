# _plugins/list-files.rb
# Generates site.data.file_index for all folders under /files

require 'fileutils'
require 'pathname'

module Jekyll
  class FileIndexer < Generator
    safe true
    priority :low

    def generate(site)
      base_dir = File.join(site.source, "files")
      index = {}

      if Dir.exist?(base_dir)
        Dir.glob("#{base_dir}/**/*", File::FNM_DOTMATCH).each do |path|
          next if File.directory?(path) # skip folders themselves

          rel_path = Pathname.new(path).relative_path_from(Pathname.new(site.source)).to_s
          folder = "/" + Pathname.new(path).dirname.relative_path_from(Pathname.new(site.source)).to_s + "/"

          index[folder] ||= []
          index[folder] << {
            "name" => File.basename(path),
            "path" => "/" + rel_path,
            "size" => "#{File.size(path)} B",
            "date" => File.mtime(path)
          }
        end
      end

      site.data["file_index"] = index
    end
  end
end
