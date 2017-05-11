require 'fileutils'

module Docset
  class Base
    attr_reader :path

    def initialize(path)
      @path = path
      FileUtils.mkdir_p(documents_path)
      @db = IndexDB.new(docset_index_db_path)
      @db.init
    end

    def add_content(from, to)
      dest_path = File.join(contents_path, to)
      FileUtils.mkdir_p(File.dirname(dest_path))
      FileUtils.cp_r(from, dest_path)
    end

    def add_document(from, to)
      dest_path = File.join(documents_path, to)
      FileUtils.mkdir_p(File.dirname(dest_path))
      FileUtils.cp_r(from, dest_path)
    end

    def add_index(name, type, path)
      @db.add_index(name, type, path)
    end

    def add_plist(plist)
      File.write(plist_path, plist.to_s)
    end

    def write_content(to, content)
      dest_path = File.join(contents_path, to)
      FileUtils.mkdir_p(File.dirname(dest_path))
      File.write(dest_path, content)
    end

    def write_document(to, document)
      dest_path = File.join(documents_path, to)
      FileUtils.mkdir_p(File.dirname(dest_path))
      File.write(dest_path, document)
    end

    private

    def contents_path
      File.join(path, 'Contents')
    end

    def docset_index_db_path
      File.join(resources_path, 'docSet.dsidx')
    end

    def documents_path
      File.join(resources_path, 'Documents')
    end

    def plist_path
      File.join(contents_path, 'Info.plist')
    end

    def resources_path
      File.join(contents_path, 'Resources')
    end
  end
end
