module Api
  class RolePermissionsController < BaseController
    before_action -> { require_permission!("manage_permissions") }

    def index
      render json: RolePermission.includes(:permission).order(:role, :permission_id).as_json(include: :permission)
    end

    def create
      record = RolePermission.new(role_permission_params)
      record.save ? render(json: record.as_json(include: :permission), status: :created) : render_model_errors(record)
    end

    def destroy
      record = RolePermission.find(params[:id])
      record.destroy
      head :no_content
    end

    private

    def role_permission_params
      params.require(:role_permission).permit(:role, :permission_id)
    end
  end
end
