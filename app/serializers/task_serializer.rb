class TaskSerializer < ActiveModel::Serializer
  attributes :uuid, :name, :project_name, :links

  has_many :timers, serializer: TimerSerializer

  def timers
    object.timers.where(user_id: scope.id).order("created_at ASC")
  end

  def name
    "#{object.name} (#{I18n.t("labels.task.billable.#{object.billable}")})"
  end

  def links
    {
      project: { href: project_path(object.project_id) }
    }
  end
end
