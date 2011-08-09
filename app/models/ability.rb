class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == "user"
      # User can read everything on the site
      can :read, :all
      
      # User can only update their account. User cannot create or destroy account.
      can :manage, User, :id => user.id
      
      # User can only create and destroy their own prayer requests
      can [:create, :destroy], Prayer, :user_id => user.id
      
      # User cannot edit, update, or destroy Groups
      can [:join, :leave], Group
      cannot [:create, :update, :destroy], Group
    else
      can :read, :all
    end
    
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
