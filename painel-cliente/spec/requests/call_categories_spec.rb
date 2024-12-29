require 'rails_helper'

RSpec.describe 'CallCategories', type: :request do
  describe 'GET /index' do
    context 'não autenticado' do
      it 'redireciona para login' do
        get '/call_categories'
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(302)
      end
    end

    context 'autenticado' do
      it 'retorna resposta sucesso se administrador' do
        user = create(:user, identification: 55_149_912_026, role: :administrator)
        login_as(user)
        get '/call_categories'
        expect(response).to have_http_status(:success)
      end

      it 'retorna resposta de erro se cliente' do
        user = create(:user, identification: 55_149_912_026, role: :client)
        login_as(user)
        get '/call_categories'
        expect(response).to redirect_to root_path
        expect(response).to have_http_status(302)
      end
    end
  end
end
