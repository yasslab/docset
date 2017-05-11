require "spec_helper"

RSpec.describe Docset::Base do
  let(:tmpdir) { @tmpdir }
  let(:path) { File.join(@tmpdir, 'foo.docset') }

  around do |example|
    Dir.mktmpdir do |dir|
      @tmpdir = dir
      example.run
    end
  end

  describe '.new' do
    specify do
      expect { described_class.new(path) }.to change {
        Dir.exist?(File.join(path))
      }.and change {
        File.exist?(File.join(path, 'Contents', 'Resources', 'docSet.dsidx'))
      }
    end
  end

  describe '#path' do
    let(:docset) { described_class.new(path) }

    specify do
      expect(docset.path).to eq(path)
    end
  end

  describe '#add_content' do
    let(:docset) { described_class.new(path) }
    let(:src_path) { File.join(tmpdir, 'hi') }
    let(:dest_path) { File.join(docset.path, 'Contents', 'greeting', 'hi') }

    before { File.write(src_path, 'hi') }

    specify do
      expect{ docset.add_content(src_path, 'greeting/hi') }.to change {
        File.exist?(dest_path)
      }
      expect(File.read(dest_path)).to eq('hi')
    end
  end

  describe '#add_document' do
    let(:docset) { described_class.new(path) }
    let(:src_path) { File.join(tmpdir, 'hi') }
    let(:dest_path) { File.join(docset.path, 'Contents', 'Resources', 'Documents', 'greeting', 'hi') }

    before { File.write(src_path, 'hi') }

    specify do
      expect{ docset.add_document(src_path, 'greeting/hi') }.to change {
        File.exist?(dest_path)
      }
      expect(File.read(dest_path)).to eq('hi')
    end
  end

  describe '#add_index' do
    let(:docset) { described_class.new(path) }

    specify do
      expect { docset.add_index('name', 'type', 'path') }.not_to raise_error
    end
  end

  describe '#add_plist' do
    let(:docset) { described_class.new(path) }
    let(:plist) { Docset::Plist.new(id: 'id', name: 'name', family: 'rails', js: true) }
    let(:plist_path) { File.join(path, 'Contents', 'Info.plist') }

    specify do
      expect{ docset.add_plist(plist) }.to change { File.exist?(plist_path) }
      expect(File.read(plist_path)).to eq(plist.to_s)
    end
  end

  describe '#write_content' do
    let(:docset) { described_class.new(path) }
    let(:dest_path) { File.join(docset.path, 'Contents', 'greeting', 'hi') }

    specify do
      expect{ docset.write_content('greeting/hi', 'hi') }.to change {
        File.exist?(dest_path)
      }
      expect(File.read(dest_path)).to eq('hi')
    end
  end

  describe '#write_document' do
    let(:docset) { described_class.new(path) }
    let(:dest_path) { File.join(docset.path, 'Contents', 'Resources', 'Documents', 'greeting', 'hi') }

    specify do
      expect{ docset.write_document('greeting/hi', 'hi') }.to change {
        File.exist?(dest_path)
      }
      expect(File.read(dest_path)).to eq('hi')
    end
  end
end
