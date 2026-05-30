module Api
  class AnalyticsController < BaseController
    def summary
      render json: {
        total_village_count: VillageWard.count,
        total_population_count: PopulationRecord.count,
        supporter_count: PopulationRecord.supporter.count,
        neutral_count: PopulationRecord.neutral.count,
        opposition_count: PopulationRecord.opposition.count,
        rural_population_count: PopulationRecord.rural.count,
        urban_population_count: PopulationRecord.urban.count,
        active_complaints: PublicRequest.where(status: [:new_request, :assigned, :in_progress, :escalated]).count,
        resolved_complaints: PublicRequest.resolved.count,
        critical_complaints: PublicRequest.critical.count,
        campaign_reach: Campaign.count * 100,
        worker_performance: WorkDone.group(:assigned_to).count,
        area_wise_population: PopulationRecord.group(:area).count,
        requests_by_status: PublicRequest.group(:status).count.transform_keys { |key| PublicRequest.statuses.key(key) },
        work_by_status: WorkDone.group(:status).count.transform_keys { |key| WorkDone.statuses.key(key) }
      }
    end
  end
end
