module Policy
  extend ActiveSupport::Concern

  module ClassMethods
    def set_policy_class(klass)
      @policy_class = klass
    end

    def policy_class
      @policy_class
    end

    def authorize(viewer, action)
      policy_class.send("#{action}?", viewer)
    end
  end

  included do
    set_policy_class "#{self.name}Policy".constantize
  end

  def authorize(viewer, action)
    policy_class.new(viewer, self).send("#{action}?")
  end

  private
  
  def policy_class
    self.class.policy_class
  end
end