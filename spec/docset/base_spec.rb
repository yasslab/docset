require "spec_helper"
require "fileutils"

RSpec.describe Docset::Base do
  let(:tmpdir) { @tmpdir }
  let(:path) { File.join(@tmpdir, 'foo.docset') }

  around do |example|
    Dir.mktmpdir do |dir|
      @tmpdir = dir
      example.run
    end
  end

  shared_examples 'copy file or directory' do |method|
    context 'copy file' do
      let(:src_path) { File.join(tmpdir, 'hi') }

      before { File.write(src_path, 'hi') }

      specify do
        dest_path = File.join(base_dir, 'greeting', 'hi')
        expect{ docset.public_send(method, src_path, 'greeting/hi') }.to change {
          File.exist?(dest_path)
        }.and change { File.read(dest_path) rescue nil }.to('hi')
      end

      specify do
        dest_path = File.join(base_dir, 'hi')
        expect{ docset.public_send(method, src_path) }.to change {
          File.exist?(dest_path)
        }.and change { File.read(dest_path) rescue nil }.to('hi')
      end
    end

    context 'copy dir' do
      let(:src_path) { File.join(tmpdir, 'foo/bar/hi') }

      before do
        FileUtils.mkdir_p(File.dirname(src_path))
        File.write(src_path, 'hi')
      end

      specify do
        dest_path = File.join(base_dir, 'foo', 'bar', 'hi')
        expect{ docset.public_send(method, File.join(tmpdir, 'foo')) }.to change {
          File.exist?(dest_path)
        }.and change { File.read(dest_path) rescue nil }.to('hi')
      end

      specify do
        dest_path = File.join(base_dir, 'foo2', 'bar2', 'bar', 'hi')
        expect{ docset.public_send(method, File.join(tmpdir, 'foo'), 'foo2/bar2') }.to change {
          File.exist?(dest_path)
        }.and change { File.read(dest_path) rescue nil }.to('hi')
      end
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
    let(:base_dir) { File.join(path, 'Contents') }

    it_behaves_like 'copy file or directory', :add_content
  end

  describe '#add_document' do
    let(:docset) { described_class.new(path) }
    let(:base_dir) { File.join(path, 'Contents', 'Resources', 'Documents') }

    it_behaves_like 'copy file or directory', :add_document
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
