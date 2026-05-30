module Api
  module Public
    class WorkDonesController < ApplicationController
      def show
        work = WorkDone.where(status: :completed).find(params[:id])
        render json: {
          id: work.id,
          title: work.title,
          work_type: work.work_type,
          category: work.category,
          description: work.description,
          area: work.area,
          village: work.village,
          status: work.status,
          completed_at: work.completed_at,
          budget: work.budget,
          image_url: work.display_image_url,
          created_at: work.created_at
        }
      end
    end
  end
end
