require 'rails_helper'

describe MessagesController do
  let(:group) { create(:group) }
  context 'when user is signed in' do
    login_user

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
              post :create, params: { group_id: group, message: attributes_for(:message) }
            }.to change(Message, :count).by(1)
          end

          it 'redirects to group_messages_path' do
            post :create, params: { group_id: group, message: attributes_for(:message) }
            expect(response).to redirect_to group_messages_path
          end

          it 'sets flash[:notice]' do
            post :create, params: { group_id: group, message: attributes_for(:message) }
            expect(flash[:notice]).to be_present
          end
        end

        context 'when json is requested' do
          it 'saves the new message in the database' do
            expect{
              post :create, params: { group_id: group, message: attributes_for(:message), format: :json }
            }.to change(Message, :count).by(1)
          end

          it 'does not render template' do
            post :create, params: { group_id: group, message: attributes_for(:message), format: :json }
            expect(@template).to be_nil
          end
        end
      end

      context 'when message is not saved' do
        it 'does not save the new message in the database' do
          expect{
            post :create, params: { group_id: group, message: { body: '', image: '' } }
            }.not_to change(Message, :count)
        end

        it 'renders the :index template' do
          post :create, params: { group_id: group, message: { body: '', image: '' } }
          expect(response).to render_template :index
        end

        it 'sets flash[:alert]' do
          post :create, params: { group_id: group, message: { body: '', image: '' } }
          expect(flash[:alert]).to be_present
        end
      end
    end
  end

  context 'when user is not signed in' do
    subject { response }
    describe 'GET #index' do
      it 'redirects to new user session path' do
        get :index, params: { group_id: group }
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'redirects to new user session path' do
        post :create, params: { group_id: group }
        is_expected.to redirect_to new_user_session_path
      end
    end
  end
end
