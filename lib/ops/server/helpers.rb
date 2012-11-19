module Ops
  module Helpers
    def hostname
      @hostname ||= `/bin/hostname` || 'Unknown'
    end

    def app_name
      @app_name ||= begin
                      dirs = Dir.pwd.split('/')
                      if dirs.last =~ /^\d+$/
                        dirs[-3]
                      else
                        dirs.last
                      end.sub(/\.com$/, '')
                    end
    end

    def environment
      ENV['RAILS_ENV']
    end

    def version_link(version)
      github_link 'tree', version
    end

    def commit_link(commit)
      github_link 'commit', commit
    end

    def github_link(resource, subresource)
      "https://github.com/primedia/#{app_name}/#{resource}/#{subresouce}" unless subresouce =~ /^Unknown/
    end

    def print_detail( object, indent = 0 )
      output = ""
      if object.kind_of? Hash
        output << "{\n"
        output << object.collect { |key, value|
          "  " * indent + "  #{print_detail key} => #{print_detail value, indent+1}"
        }.join(",\n") << "\n"
        output << "  " * indent + "}"
      else
        output << object.inspect
      end
      output
    end
  end
end