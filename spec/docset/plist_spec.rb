require "spec_helper"
require "nokogiri"

RSpec.describe Docset::Plist do
  describe '#to_s' do
    let(:doc) { Nokogiri(plist.to_s) }

    def value(key)
      doc.xpath(%{//key[text()="#{key}"]/following::*}).first
    end

    let(:plist) { Docset::Plist.new(id: 'id', name: 'name', family: 'rails') }

    specify do
      aggregate_failures do
        expect(value('CFBundleIdentifier').to_s).to eq('<string>id</string>')
        expect(value('CFBundleName').to_s).to eq('<string>name</string>')
        expect(value('DocSetPlatformFamily').to_s).to eq('<string>rails</string>')
        expect(value('isJavaScriptEnabled').to_s).to eq('<true/>')
      end
    end

    context 'js enabled' do
      let(:plist) { Docset::Plist.new(id: 'id', name: 'name', family: 'rails', js: true) }

      specify do
        expect(value('isJavaScriptEnabled').to_s).to eq('<true/>')
      end
    end

    context 'js disabled' do
      let(:plist) { Docset::Plist.new(id: 'id', name: 'name', family: 'rails', js: false) }

      specify do
        expect(value('isJavaScriptEnabled')).to eq(nil)
      end
    end
  end
end
