module Ops
  module Server
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
    end
  end
end
