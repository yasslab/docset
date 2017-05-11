require "spec_helper"
require "tmpdir"

RSpec.describe Docset::IndexDB do
  let(:path) { File.join(@tmpdir, 'tmp') }

  around do |example|
    Dir.mktmpdir do |dir|
      @tmpdir = dir
      example.run
    end
  end

  describe ".new" do
    specify do
      expect { Docset::IndexDB.new(path) }.to change { File.exist?(path) }
    end
  end

  describe "#init" do
    let(:index_db) { Docset::IndexDB.new(path) }

    specify do
      expect { index_db.init }.to change {
        db = SQLite3::Database.new(path)
        r = db.execute('select distinct tbl_name from sqlite_master where tbl_name = "searchIndex"')
        r.flatten.include?('searchIndex')
      }.and change { File.exist?(path) }
    end
  end

  describe '#add_index' do
    let(:index_db) { Docset::IndexDB.new(path) }

    before { index_db.init }

    specify do
      expect { index_db.add_index('name', 'Guide', 'path') }.to change {
        db = SQLite3::Database.new(path)
        db.execute('select count(*) from searchIndex where name = "name" and type = "Guide" and path = "path"')
      }.from([[0]]).to([[1]])
    end
  end
end
