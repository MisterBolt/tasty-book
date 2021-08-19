class CookBookPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        scope.for_public.or(scope.for_specific_followers(user.followings.ids)).or(user.cook_books)
      else
        scope.for_public
      end
    end
  end

  def destroy?
    user && (record.user == user || user.admin?)
  end
end
