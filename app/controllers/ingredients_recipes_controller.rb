class IngredientsRecipesController < ApplicationController
    before_action :permit_params, only: :create
    
    def create
        byebug
    end

    def destroy

    end

    private 

    def permit_params
        #params.require()
    end
end