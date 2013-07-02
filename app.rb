require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:///blog.db"

module Blog
  class App < Sinatra::Application
    get "/" do
      @posts = Post.order("created_at DESC")
      erb :"posts/index"
    end

    get "/posts/new" do
      @title = "New Post"
      @post = Post.new
      erb :"posts/new"
    end

    post "/posts" do
      @post = Post.new(params[:post])
      if @post.save
        redirect "posts/#{@post.id}"
      else
        erb :"posts/new"
      end
    end

    get "/posts/:id" do
      @post = Post.find(params[:id])
      @title = @post.title
      erb :"posts/show"
    end

    get "/posts/:id/edit" do
      @post = Post.find(params[:id])
      @title = "Edit Form"
      erb :"posts/edit"
    end

    put "/posts/:id" do
      @post = Post.find(params[:id])
      if @post.update_attributes(params[:post])
        redirect "/posts/#{@post.id}"
      else
        erb :"posts/edit"
      end
    end

    delete "/posts/:id" do
      @post = Post.find(params[:id]).destroy
      redirect "/"
    end

    get "/about" do
      @title = "About Me"
      erb :"pages/about"
    end

  end
end


class Post < ActiveRecord::Base

end

helpers do
  # If @title is assigned, add it to the page's title.
  def title
    if @title
      "#{@title} -- My Blog"
    else
      "My Blog"
    end
  end

  def post_show_page?
    request.path_info =~ /\/posts\/\d+$/
  end

  def delete_post_button(post_id)
    erb :_delete_post_button, locals: { post_id: post_id}
  end

  # Format the Ruby Time object returned from a post's created_at method
  # into a string that looks like this: 06 Jan 2012
  def pretty_date(time)
   time.strftime("%d %b %Y")
  end

end 