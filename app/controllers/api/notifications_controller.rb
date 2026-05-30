module Api
  class NotificationsController < BaseController
    def index
      notifications = current_user.notifications.recent
      unread_count = notifications.unread.count
      render json: {
        data: notifications.as_json(
          only: %i[id title message notification_type public_request_id read created_at]
        ),
        meta: { unread_count: unread_count }
      }
    end

    def mark_read
      notification = current_user.notifications.find(params[:id])
      notification.update!(read: true)
      render json: notification.as_json(only: %i[id read])
    end

    def mark_all_read
      current_user.notifications.unread.update_all(read: true)
      render json: { success: true }
    end

    def unread_count
      count = current_user.notifications.unread.count
      render json: { unread_count: count }
    end
  end
end
