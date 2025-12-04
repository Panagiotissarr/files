require 'find'

module FileIndexGenerator
  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      site.data['file_index'] = {}

      base = site.source

      Find.find(base) do |path|
        next if path.include?("/_") # ignore _plugins, _site, etc.
        next if File.directory?(path)

        rel = path.sub(base + "/", "")

        folder = File.dirname(rel) + "/"
        name   = File.basename(rel)
        size   = File.size(path)
        date   = File.mtime(path)

        site.data['file_index'][folder] ||= []
        site.data['file_index'][folder] << {
          "name" => name,
          "path" => rel,
          "size" => size,
          "date" => date
        }
      end
    end
  end
end
