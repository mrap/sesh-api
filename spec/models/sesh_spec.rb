require 'spec_helper'

describe Sesh do
  let(:user)     { create(:user) }
  subject(:sesh) { create(:sesh) }

  it { should have_fields(:title, :listens_count) }
  it { should have_field(:listeners_ids).with_default_value_of([]) }
  it { should have_field(:listens_count).with_default_value_of(0) }
  it { should have_field(:is_anonymous).with_default_value_of(false) }
  it { should have_field(:favoriters_count).with_default_value_of(0) }
  it { should belong_to(:author) }
  it { should have_and_belong_to_many :favoriters }
  it { should respond_to(:audio) }

  # Validations
  it { should validate_presence_of(:author) }

  context 'when created without a title' do
    subject(:sesh) { create(:sesh, title: nil) }
    it 'should default title to id' do
      sesh.title.should match sesh.id.to_s
    end
  end

  describe 'scopes' do
    before do
      @seshes = []
      @anonymous_sesh = create(:sesh, is_anonymous: true)
      @seshes << @anonymous_sesh
      for i in 1..3 do
        sesh = create(:sesh)
        sesh.update(created_at: DateTime.now.advance(seconds: i))
        @seshes << sesh
      end
    end

    describe '.recent' do
      it 'sorts sesh order from newest to oldest' do
        Sesh.recent.to_a.should eq @seshes.reverse
      end
    end

    describe '.anonymous_only' do
      it 'returns only anonymous seshes' do
        Sesh.anonymous_only.to_a.should eq [@anonymous_sesh]
      end
    end

    describe '.most_favorited' do
      before do
        user2  = create(:user)
        @most_favorited_sesh = @seshes.last
        @second_most_favorited_sesh = @seshes.first
        user.add_sesh_to_favorites(@most_favorited_sesh)
        user2.add_sesh_to_favorites(@most_favorited_sesh)
        user2.add_sesh_to_favorites(@second_most_favorited_sesh)
      end

      it 'orders by most favorited first' do
        Sesh.most_favorited.first.should eq @most_favorited_sesh
        Sesh.most_favorited[1].should eq @second_most_favorited_sesh
      end
    end
  end

  describe 'adding unique_listener_ids' do
    let(:add_listener) { sesh.add_user_id_to_listeners_ids(user.id) }
    before             { add_listener }

    its(:listeners_ids)   { should include user.id }
    its(:listens_count) { should eq 1 }

    context 'when attempting to add a listener twice' do
      let(:double_add) { sesh.add_user_id_to_listeners_ids(user.id) }

      it "does not add to .listener_ids" do
        expect{ double_add }.not_to change{ sesh.listens_count }
      end
    end
  end

end
