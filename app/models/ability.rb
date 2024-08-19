# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, shop_id = nil)
    # Define abilities for the user here. For example:
    #
    return unless user.present?

    cannot :read, :all
    cannot :create, :all
    cannot :update, :all
    cannot :destroy, :all
    can :read, Shop

    if shop_id.nil?
      can :create, Shop
      return
    end
    shop = Shop.find(shop_id)
    shop_employee = user.shop_employees.find_by(shop_id: shop.id)
    case shop_employee.role
    when 'owner'
      can :manage, Shop, id: shop.id
      can :manage, ShopEmployee, shop_id: shop.id
      can :manage, Product, shop_id: shop.id
      can :manage, Work, shop_id: shop.id
      can :manage, ProductWork, work: { shop_id: shop.id }
      can :manage, DetailsOfWork, shop_employee: { shop_id: shop.id }
      can :manage, Prototype
      can :manage, Group
      can :create, User
    when 'employee'
      can :create, Shop
      can :read, ShopEmployee, id: shop_employee.id
      can :read, Product, shop_id: shop.id
      can :read, Work, shop_id: shop.id
      can :read, ProductWork, work: { shop_id: shop.id }
      can :read, DetailsOfWork, shop_employee: { shop_id: shop.id }
      can :read, Prototype
      can :read, Group
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
