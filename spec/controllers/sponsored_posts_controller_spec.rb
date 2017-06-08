require 'rails_helper'
include RandomData

RSpec.describe SponsoredPostsController, type: :controller do
  
  let(:my_topic) { Topic.create!(name:  RandomData.random_sentence, description: RandomData.random_paragraph) }
  
  let(:my_sponpost) { my_topic.sponsored_posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 10) }
  
  describe "GET show" do
    it "returns http success" do
      get :show, topic_id: my_topic.id, id: my_sponpost.id
      expect(response).to have_http_status(:success)
    end
    it "renders the #show view" do 
      get :show, topic_id: my_topic.id, id: my_sponpost.id
      expect(response).to render_template :show
    end
    it "assigns my_sponpost to @sponsored_post" do 
      get :show, topic_id: my_topic.id, id: my_sponpost.id
      expect(assigns(:sponsored_post)).to eq(my_sponpost)
    end
  end

  describe "GET new" do
    it "returns http success" do
      get :new, topic_id: my_topic.id
      expect(response).to have_http_status(:success)
    end

    it "renders the #new view" do
      get :new, topic_id: my_topic.id
      expect(response).to render_template :new
    end

    it "instantiates @sponsored_post" do
      get :new, topic_id: my_topic.id
      expect(assigns(:sponsored_post)).not_to be_nil
    end
  end

  describe "POST create" do
    it "increases the number of Post by 1" do
      expect{post :create, topic_id: my_topic.id, sponsored_post: {title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 10}}.to change(SponsoredPost,:count).by(1)
    end

    it "assigns the new post to @sponsored_post" do
      post :create, topic_id: my_topic.id, sponsored_post: {title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 10}
      expect(assigns(:sponsored_post)).to eq SponsoredPost.last
    end

    it "redirects to the new post" do
      post :create, topic_id: my_topic.id, sponsored_post: {title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 10}
      expect(response).to redirect_to [my_topic, SponsoredPost.last]
    end
  end
  
  describe "GET edit" do
    it "returns http success" do
      get :edit, topic_id: my_topic.id, id: my_sponpost.id
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #edit view" do 
      get :edit, topic_id: my_topic.id, id: my_sponpost.id
      expect(response).to render_template :edit
    end
    
    it "assigns post to be updated to @sponsored_post" do 
      get :edit, topic_id: my_topic.id, id: my_sponpost.id
      post_instance = assigns(:sponsored_post)
      
      expect(post_instance.id).to eq my_sponpost.id
      expect(post_instance.title).to eq my_sponpost.title
      expect(post_instance.body).to eq my_sponpost.body
    end
  end
  
  describe "PUT update" do 
    it "updates the post with extracted attributes" do 
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      new_price = 11
      
      put :update, topic_id: my_topic.id, id: my_sponpost.id, my_sponpost: {title: new_title, body: new_body, price: new_price}
      
      updated_post = assigns(:my_sponpost)
      expect(updated_post.id).to eq my_sponpost.id
      expect(updated_post.title).to eq new_title
      expect(updated_post.body).to eq new_body
      expect(updated_post.price).to eq new_price
    end
    
    it "redirects to the upated post" do 
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      new_price = 11
      
      put :update, topic_id: my_topic.id, id: my_sponpost.id, my_sponpost: {title: new_title, body: new_body, price: new_price}
      expect(response).to redirect_to [my_topic, my_sponpost]
    end
  end
  
  describe "DELETE destroy" do 
    it "deleted the post" do 
      delete :destroy, topic_id: my_topic.id, id: my_sponpost.id
      count = SponsoredPost.where({id: my_sponpost.id}).size
      expect(count).to eq 0
    end
    
    it "redirects to topics show" do 
      delete :destroy, topic_id: my_topic.id, id: my_sponpost.id
      expect(response).to redirect_to my_topic
    end
  end
end