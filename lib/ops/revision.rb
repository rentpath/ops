require 'yaml'

module Ops
  class Revision
    attr_reader :file_root

    def initialize(new_headers = {}, opts = Ops.config)
      @file_root = opts.file_root.to_s # convert to string in case they pass us a Pathname
      @environment = opts.environment
      @headers = new_headers
    end

    attr_reader :environment

    def headers
      @headers.select { |k, v| k.match(/^[-A-Z_].*$/) }
    end

    def info
      @info ||= build_info.merge(deploy_info)
    end

    def previous_info
      @previous_info ||= previous_build_info.merge(previous_deploy_info)
    end

    private

    def build_info
      info_from_file('BUILD-INFO')
    end

    def previous_build_info
      info_from_file('PREVIOUS-BUILD-INFO')
    end

    def deploy_info
      info_from_file('DEPLOY-INFO')
    end

    def previous_deploy_info
      info_from_file('PREVIOUS-DEPLOY-INFO')
    end

    def info_from_file(name)
      if file_exists?(name)
        parse_info_file(name)
      else
        {name.downcase.gsub('-', '_') => "No #{name} file found"}
      end
    end

    def parse_info_file(filename)
      YAML.safe_load(File.read(File.join(file_root, filename))) if file_exists?(filename)
    end

    def file_exists?(file_name)
      File.exist?(File.join(file_root, file_name))
    end
  end
end
