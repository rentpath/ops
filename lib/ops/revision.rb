module Ops
  class Revision
    def initialize(new_headers={}, opts = Ops.config)
      @file_root = opts.file_root.to_s # convert to string in case they pass us a Pathname
      @environment = opts.environment
      @headers = new_headers
    end

    def version_or_branch
      @version ||= if version_file?
                     File.read(version_file).chomp.gsub('^{}', '')
                   elsif environment == 'development' && `git branch` =~ /^\* (.*)$/
                     $1
                   else
                     'Unknown (VERSION file is missing)'
                   end
    end

    # TODO make this nicer looking - probably extract into multiple methods
    def previous_versions
      return @previous_versions if @previous_versions
      @previous_versions = []
      path = File.absolute_path(file_root)
      dirs = file_root.split('/')
      if dirs.last =~ /^\d+$/
        Dir["#{path}/../*"].each do |dir|
          next if dir =~ /#{dirs.last}$/
          version = File.join(dir, 'VERSION')
          revision = File.join(dir, 'REVISION')
          if File.exists?(version) && File.exists?(revision)
            @previous_versions << { version: File.read(version).chomp.gsub('^{}', ''),
              revision: File.read(revision).chomp,
              time: File.stat(revision).mtime }
          end
        end
      end
      @previous_versions.sort!{ |a, b| a[:time] <=> b[:time] }
    end

    def file_root
      @file_root
    end

    def environment
      @environment
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
                         File.stat(version_file).mtime
                       elsif environment == 'development'
                         'Live'
                       else
                         'Unknown (VERSION file is missing)'
                       end
    end

    def last_commit
      @last_commit ||= if revision_file?
                         File.read(revision_file).chomp
                       elsif environment == 'development' && `git show` =~ /^commit (.*)$/
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
