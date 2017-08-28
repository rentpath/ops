require 'spec_helper'

RSpec.describe Ops::Revision do
  subject { described_class.new(headers) }
  let(:headers) { {} }

  describe '#headers' do
    context 'With Headers provided' do
      let(:headers) { { 'ABC' => '123', 'hidden' => 'x' } }

      it 'should be present' do
        expect(subject.headers).to eql('ABC' => '123')
      end
    end

    context 'Without Headers provided' do
      it 'should be present' do
        expect(subject.headers).to eql({})
      end
    end
  end

  describe '#info' do
    context 'When BUILD-INFO and DEPLOY-INFO not found' do
      let(:settings) { double('settings', file_root: 'none', environment: 'test') }
      let(:expected) do
        {
          'build_info' => 'No BUILD-INFO file found',
          'deploy_info' => 'No DEPLOY-INFO file found'
        }
      end

      subject { described_class.new(headers, settings) }

      it 'message should indicate that files not found' do
        expect(subject.info).to eql(expected)
      end
    end

    context 'When BUILD-INFO and DEPLOY-INFO found' do
      let(:expected) do
        {
          'build_number' => 112,
          'deploy_date' => '2017-08-25 16:49:20',
          'git_commit' => 'b2055296a4b35f54058771766b4b7bcdf6c95a6d',
          'version' => '20170825-112-b205529'
        }
      end

      it 'build and deploy info will exist' do
        expect(subject.info).to eql(expected)
      end
    end
  end

  describe '#previous_info' do
    context 'When PREVIOUS-BUILD-INFO and PREVIOUS-DEPLOY-INFO not found' do
      let(:settings) { double('settings', file_root: 'none', environment: 'test') }

      let(:expected) do
        {
          'previous_build_info' => 'No PREVIOUS-BUILD-INFO file found',
          'previous_deploy_info' => 'No PREVIOUS-DEPLOY-INFO file found'
        }
      end

      subject { described_class.new(headers, settings) }

      it 'message should indicate that files not found' do
        expect(subject.previous_info).to eql(expected)
      end
    end

    context 'When PREVIOUS-BUILD-INFO and PREVIOUS-DEPLOY-INFO found' do
      let(:expected) do
        {
          'build_number' => 111,
          'deploy_date' => '2017-08-25 09:41:27',
          'git_commit' => '53a8dc9652ee7e81a6019a2a066ee8d3941b30d2',
          'version' => '20170825-111-53a8dc9'
        }
      end

      it 'build and deploy previous_info will exist' do
        expect(subject.previous_info).to eql(expected)
      end
    end
  end
end
