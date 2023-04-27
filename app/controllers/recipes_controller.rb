class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def index
        user = current_user
        if user
            recipes = user.recipes
            render json: recipes, status: :created
        else
            render_unauthorized_response
        end
    end

    def create
        user = current_user
        if user
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created
        else
            render_unauthorized_response
        end
    end

    private

    def recipe_params
        params.permit(:user_id, :title, :instructions, :minutes_to_complete)
    end

    def render_not_found_response
        render json: {error: "user not found"}, status: :not_found
    end

    def render_unprocessable_entity(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def current_user
        User.find_by(id: session[:user_id])
    end

    def render_unauthorized_response
        render json: {error: ["Not authorized"]}, status: :unauthorized
    end

end
