# _plugins/list-files.rb
require 'pathname'

module Jekyll
  class FileIndexer < Generator
    safe true
    priority :low

    def generate(site)
      base_dir = File.join(site.source, "files")
      index = {}

      return unless Dir.exist?(base_dir)

      Dir.glob("#{base_dir}/**/*").each do |path|
        next if path =~ /\/\.\.?$/ # skip . and ..
        rel_path = Pathname.new(path).relative_path_from(Pathname.new(site.source)).to_s
        folder = "/" + Pathname.new(path).dirname.relative_path_from(Pathname.new(site.source)).to_s + "/"

        index[folder] ||= []

        if File.directory?(path)
          index[folder] << {
            "name" => File.basename(path),
            "path" => "/" + rel_path + "/",
            "size" => "-",
            "date" => File.mtime(path),
            "type" => "folder"
          }
        else
          index[folder] << {
            "name" => File.basename(path),
            "path" => "/" + rel_path,
            "size" => "#{File.size(path)} B",
            "date" => File.mtime(path),
            "type" => "file"
          }
        end
      end

      site.data["file_index"] = index
    end
  end
end
