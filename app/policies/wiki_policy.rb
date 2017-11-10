class WikiPolicy < ApplicationPolicy
  def update?
    user_who_can_access_wiki
  end
  
  def destroy?
    user_who_can_access_wiki
  end

  def user_who_can_access_wiki
    record.user_id == user.id || user.admin? || record.collaborating_users.include?(user)
  end
  
  class Scope
    attr_reader :user, :scope
    
    def initialize(user, scope)
      @user = user
      @scope = scope
    end
    
    def resolve
      wikis = []
      if user.admin?
        wikis = scope.all
      else 
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private || wiki.user_id == user.id || wiki.collaborators.include?(user.id)
            wikis << wiki
          end
        end
      end
      wikis
    end
  end
end