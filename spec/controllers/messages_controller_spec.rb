require 'rails_helper'

describe MessagesController do
  context 'when user is signed in' do
    login_user
    let(:group) { create(:group) }

    describe 'GET #index' do
      before do
        get :index, params: { group_id: group }
      end

      it 'assigns requested value to @group' do
        expect(assigns(:group)).to eq group
      end

      it 'has @groups as an array' do
        expect(assigns(:groups)).to match_array []
      end

      it 'has @members as an array' do
        expect(assigns(:members)).to match_array []
      end

      it 'has @messages as an array' do
        expect(assigns(:messages)).to match_array []
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end
    end

    describe 'POST #create' do
      context 'when message is saved' do
        context 'when html is requested' do
          it 'saves the new message in the database' do
            expect{
              post :create,params: { group_id: group, message: attributes_for(:message) }
            }.to change(Message, :count).by(1)
          end
        end

        context 'when json is requested' do
        end
      end

      context 'when message is not saved' do
      end
    end
  end

  context 'when user is not signed in' do
    describe 'GET #index' do
    end

    describe 'POST #create' do
    end
  end
end
