require 'sqlite3'

module Docset
  class IndexDB
    def initialize(file)
      @db = SQLite3::Database.new(file)
      @db.busy_timeout(5000)
    end

    def init
      @db.execute_batch(<<~SQL)
        DROP TABLE IF EXISTS searchIndex;
        CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);
        CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);
      SQL
    end

    def add_index(name, type, path)
      @db.prepare("INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?, ?, ?);") do |stmt|
        stmt.execute([name, type, path])
      end
    end
  end
end
