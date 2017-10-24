class WikiPolicy < ApplicationPolicy
  def update?
    user_who_can_access_wiki
  end
  
  def destroy?
    user_who_can_access_wiki
  end

  def user_who_can_access_wiki
    record.user_id == user.id || user.admin?
  end
end