module Ops
  module Helpers
    GITHUB_ORG_LINK = 'https://github.com/rentpath'.freeze

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

    def version_link(version)
      github_link 'tree', version
    end

    def commit_link(commit)
      github_link 'commit', commit
    end

    def repo_name
      Ops.config[:repo_name] || app_name
    end

    def github_link(resource, subresource)
      unless subresource =~ /^Unknown/
        "<a href='#{GITHUB_ORG_LINK}/#{repo_name}/#{resource}/#{subresource}'>#{subresource}</a>"
      end
    end
  end
end
