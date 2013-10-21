require 'spec_helper'

describe Api::V1::SeshesController do

  default_version 1
  let(:content_body) { response.parsed_body['response'] }

  describe 'fetching a sesh' do
    before { @sesh = create(:sesh) }

    context 'when params match valid sesh' do
      before(:each) { get :show, id: @sesh.id }
      subject { response }

      its(:status) { should eq 200 }
      it { should be_singular_resource }

      it 'should provide the title' do
        content_body['title'].should_not be_nil
      end

      it 'should provide the author' do
        content_body['author_id'].should_not be_nil
      end

      it 'should provide url to audio'
    end
  end
end
