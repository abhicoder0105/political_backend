module Api
  module Public
    class PrPostsController < ApplicationController
      def index
        posts = PrPost.where(status: :published).order(published_at: :desc, created_at: :desc)
        render json: posts.map { |p| serialize(p) }
      end

      def show
        post = PrPost.where(status: :published).find(params[:id])
        render json: serialize(post)
      end

      private

      def serialize(post)
        {
          id: post.id,
          title: post.title,
          content: post.content,
          language: post.language,
          published_at: post.published_at,
          created_at: post.created_at,
          image_url: post.display_image_url
        }
      end
    end
  end
end