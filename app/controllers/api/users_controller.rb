module Api
  class UsersController < BaseController
    before_action -> { require_permission!("manage_users") }
    before_action :set_user, only: %i[show update destroy]

    def index
      render json: User.order(:role, :name).as_json(only: %i[id name mobile_number role area village_or_ward])
    end

    def show
      render json: @user
    end

    def create
      record = User.new(user_params)
      record.save ? render(json: record, status: :created) : render_model_errors(record)
    end

    def update
      @user.update(user_params) ? render(json: @user) : render_model_errors(@user)
    end

    def destroy
      @user.destroy
      head :no_content
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :mobile_number, :password, :role, :address, :area, :village_or_ward, :rural_or_urban, :preferred_language)
    end
  end
end
