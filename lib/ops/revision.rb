module Ops
  class Revision
    def initialize(new_headers={}, opts = Ops.config)
      @file_root = opts.file_root
      @headers = new_headers
    end

    def version_or_branch
      @version ||= if File.exists?(version_file)
                     File.read(version_file).chomp.gsub('^{}', '')
                   elsif environment == 'development' && `git branch` =~ /^\* (.*)$/
                     $1
                   else
                     'Unknown (VERSION file is missing)'
                   end
    end

    def previous_versions
      return @previous_versions if @previous_versions
      @previous_versions = []
      dirs = Dir.pwd.split('/')
      if dirs.last =~ /^\d+$/
        Dir["../*"].each do |dir|
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

    def version_file
      @version_file ||= File.join(@file_root, 'VERSION')
    end

    def deploy_date
      @deploy_date ||= if File.exists?(version_file)
        File.stat(version_file).mtime
      elsif environment == 'development'
        'Live'
      else
        'Unknown (VERSION file is missing)'
      end
    end

    def last_commit
      @last_commit ||= if File.exists?(revision_file)
        File.read(revision_file).chomp
      elsif environment == 'development' && `git show` =~ /^commit (.*)$/
        $1
      else
        'Unknown (REVISION file is missing)'
      end
    end

    def revision_file
      @revision_file ||= File.join(@file_root, 'REVISION')
    end

    def headers
      @headers.select{|k,v| k.match(/^[-A-Z_].*$/) }
    end
  end
end
