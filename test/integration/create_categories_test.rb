require 'test_helper'

class ListCategoriesTest < ActionDispatch::IntegrationTest

	def setup
    @user = User.create(username: "tester", email: "tester@email.com", password: "password", admin: true)
	end

	test "get new category form and create category" do
	  sign_in_as(@user, "password")
	  get new_category_path
	  assert_template 'categories/new'
	  assert_difference 'Category.count', 1 do
	    post categories_path, params: {category: {name: "bookss"}}
	    follow_redirect!
    end
    assert_template 'categories/index'
    assert_match "bookss", response.body
  end

  test "invalid category submission results in failure" do
  	sign_in_as(@user, "password")
  	get new_category_path
	  assert_template 'categories/new'
	  assert_no_difference 'Category.count' do
	    post categories_path, params: {category: {name: " "}}
    end
    assert_template 'categories/new'
    assert_select 'h2.alert-title'
    assert_select 'div.alert-body'
  end
		
end