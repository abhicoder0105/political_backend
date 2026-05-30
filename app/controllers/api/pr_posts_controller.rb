module Api
  class PrPostsController < BaseController
    before_action -> { require_permission!("manage_pr") }
    before_action :set_pr_post, only: %i[show update destroy]

    def index
      render json: PrPost.order(created_at: :desc).map { |p| serialize(p) }
    end

    def show
      render json: serialize(@pr_post)
    end

    def create
      record = PrPost.new(pr_post_params.merge(user: current_user))
      record.uploaded_image.attach(params[:uploaded_image]) if params[:uploaded_image].present?
      record.media_files.attach(params[:media_files]) if params[:media_files].present?
      record.save ? render(json: serialize(record), status: :created) : render_model_errors(record)
    end

    def update
      @pr_post.uploaded_image.attach(params[:uploaded_image]) if params[:uploaded_image].present?
      @pr_post.uploaded_image.purge if params[:remove_image] == "true" && !params[:uploaded_image].present?
      @pr_post.update(pr_post_params) ? render(json: serialize(@pr_post)) : render_model_errors(@pr_post)
    end

    def destroy
      @pr_post.destroy
      head :no_content
    end

    private

    def set_pr_post
      @pr_post = PrPost.find(params[:id])
    end

    def pr_post_params
      params.require(:pr_post).permit(:title, :content, :language, :status, :scheduled_at, :published_at, :image_url)
    end

    def serialize(post)
      post.as_json.merge(
        image_url: post.display_image_url,
        has_uploaded_image: post.uploaded_image.attached?,
        media_urls: post.media_files.attached? ? post.media_files.map { |f| url_for(f) } : []
      )
    end
  end
end
