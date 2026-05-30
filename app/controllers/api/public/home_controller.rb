module Api
  module Public
    class HomeController < ApplicationController
      def index
        pr_posts = PrPost.where(status: :published).order(published_at: :desc, created_at: :desc).limit(6)
        campaigns = Campaign.where(campaign_status: [:scheduled, :active, :completed]).order(Arel.sql("COALESCE(scheduled_at, created_at) DESC")).limit(6)
        work_dones = WorkDone.where(status: :completed).order(Arel.sql("COALESCE(completed_at, created_at) DESC")).limit(6)

        render json: {
          latest_updates: build_updates(pr_posts, campaigns, work_dones),
          pr_posts: pr_posts.map { |p| serialize_pr_post(p) },
          campaigns: campaigns.map { |c| serialize_campaign(c) },
          work_dones: work_dones.map { |w| serialize_work_done(w) },
          stats: {
            completed_work_count: WorkDone.where(status: :completed).count,
            active_campaign_count: Campaign.where(campaign_status: :active).count,
            resolved_request_count: PublicRequest.where(status: :resolved).count,
            published_pr_count: PrPost.where(status: :published).count
          }
        }
      end

      private

      def build_updates(pr_posts, campaigns, work_dones)
        updates = []

        pr_posts.each do |p|
          updates << update_item(p.id, "pr_post", "समाचार", p.title, p.content, p.display_image_url, p.published_at || p.created_at)
        end

        campaigns.each do |c|
          updates << update_item(c.id, "campaign", "अभियान", c.title, c.description, c.display_image_url, c.scheduled_at || c.created_at)
        end

        work_dones.each do |w|
          updates << update_item(w.id, "work_done", "कार्य", w.title, w.description, w.proof_image_url, w.completed_at || w.created_at)
        end

        updates.sort_by { |u| u[:date] || Time.current }.reverse.first(10)
      end

      def update_item(id, type, type_label, title, excerpt, image_url, date)
        {
          id: id,
          type: type,
          type_label: type_label,
          title: title,
          excerpt: excerpt.to_s.truncate(200, separator: " "),
          image_url: image_url,
          date: date,
          public_url: nil
        }
      end

      def serialize_pr_post(post)
        {
          id: post.id,
          title: post.title,
          content: post.content,
          language: post.language,
          status: post.status,
          published_at: post.published_at,
          created_at: post.created_at,
          image_url: post.display_image_url
        }
      end

      def serialize_campaign(campaign)
        {
          id: campaign.id,
          title: campaign.title,
          description: campaign.description,
          campaign_status: campaign.campaign_status,
          target_area: campaign.target_area,
          target_village: campaign.target_village,
          scheduled_at: campaign.scheduled_at,
          created_at: campaign.created_at,
          image_url: campaign.display_image_url
        }
      end

      def serialize_work_done(work)
        {
          id: work.id,
          title: work.title,
          work_type: work.work_type,
          description: work.description,
          area: work.area,
          village: work.village,
          status: work.status,
          completed_at: work.completed_at,
          proof_image_url: work.proof_image_url,
          created_at: work.created_at
        }
      end
    end
  end
end
