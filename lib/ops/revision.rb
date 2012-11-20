module Ops
  class Revision
    def initialize(new_headers={}, opts = Ops.config)
      @file_root = opts.file_root.to_s # convert to string in case they pass us a Pathname
      @environment = opts.environment
      @headers = new_headers
    end

    def version_or_branch
      @version ||= if version_file?
                     chomp(version_file).gsub('^{}', '')
                   elsif development? && `git branch` =~ /^\* (.*)$/
                     $1
                   else
                     'Unknown (VERSION file is missing)'
                   end
    end

    def previous_versions
      @previous_versions ||= get_previous_by_time
    end

    def get_previous_by_time
      get_previous_versions.sort { |a, b| a[:time] <=> b[:time] }
    end

    def get_previous_versions
      Dir["#{path}/../*"].each_with_object([]) do |dir, array|
        next if dir =~ /#{current_dir}$/
        version, revision = File.join(dir, 'VERSION'), File.join(dir, 'REVISION')
        array << stats_hash(version: version, revision: revision) if File.exists?(version) && File.exists?(revision)
      end
    end

    def path
      File.absolute_path file_root
    end

    def current_dir
      file_root.split('/').last
    end

    def stats_hash(files)
      { version:  get_version(files[:version]),
        revision: get_revision(files[:revision]),
        time:     get_time(files[:revision]) }
    end

    def get_version(file)
      chomp(file).gsub('^{}', '')
    end

    def get_revision(file)
      chomp file
    end

    def chomp(file)
      File.read(file).chomp
    end

    def get_time(file)
      File.stat(file).mtime
    end

    def file_root
      @file_root
    end

    def environment
      @environment
    end

    def development?
      environment == 'development'
    end

    def version_file
      @version_file ||= File.join(file_root, 'VERSION')
    end

    def version_file?
      File.exists? version_file
    end

    def revision_file
      @revision_file ||= File.join(file_root, 'REVISION')
    end

    def revision_file?
      File.exists? revision_file
    end

    def deploy_date
      @deploy_date ||= if version_file?
                         get_time version_file
                       elsif development?
                         'Live'
                       else
                         'Unknown (VERSION file is missing)'
                       end
    end

    def last_commit
      @last_commit ||= if revision_file?
                         chomp revision_file
                       elsif development? && `git show` =~ /^commit (.*)$/
                         $1
                       else
                         'Unknown (REVISION file is missing)'
                       end
    end

    def headers
      @headers.select{|k,v| k.match(/^[-A-Z_].*$/) }
    end
  end
end
