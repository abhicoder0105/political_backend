module Api
  module Admin
    class ProfilesController < BaseController
      before_action :set_profile

      def show
        render json: profile_json
      end

      def update
        @profile.photo.attach(params[:photo]) if params[:photo].present?
        if @profile.update(profile_params)
          render json: profile_json
        else
          render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_profile
        @profile = Profile.first_or_initialize
      end

      def profile_params
        params.require(:profile).permit(:name, :title, :party, :constituency, :department, :biography, :political_experience, :focus_areas, :contact_info, :photo)
      end

      def profile_json
        {
          id: @profile.id,
          name: @profile.name,
          title: @profile.title,
          party: @profile.party,
          constituency: @profile.constituency,
          department: @profile.department,
          biography: @profile.biography,
          political_experience: parse_list(@profile.political_experience),
          focus_areas: parse_list(@profile.focus_areas),
          contact_info: parse_hash(@profile.contact_info),
          photo_url: @profile.photo.attached? ? url_for(@profile.photo) : nil
        }
      end

      def parse_list(value)
        return [] if value.blank?
        value.is_a?(String) ? value.split("\n").map(&:strip).reject(&:blank?) : value
      end

      def parse_hash(value)
        return {} if value.blank?
        return value unless value.is_a?(String)
        JSON.parse(value) rescue {}
      end
    end
  end
end