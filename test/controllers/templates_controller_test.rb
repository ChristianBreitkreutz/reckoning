# frozen_string_literal: true

require 'test_helper'

class TemplatesControllerTest < ActionDispatch::IntegrationTest
  describe 'unauthorized' do
    it 'redirects with unauthorized error when trying to get templates' do
      get '/template/blank'

      assert_response :found
      assert_equal I18n.t(:'devise.failure.unauthenticated'), flash[:alert]
    end
  end

  describe 'happy path' do
    let(:will) { users :will }

    before do
      sign_in will
    end

    it 'shows the requested template' do
      get '/template/blank'

      assert_response :ok
    end
  end
end
