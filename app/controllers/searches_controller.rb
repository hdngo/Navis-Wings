class SearchesController < ApplicationController
	def new
	end

	def create
		@search = Search.new(search_params)

		@search.save
		redirect_to @search
	end

	def index
		@searches = Search.all
		render json: @searches
	end
	
	def show
		@search = Search.find(params[:id])
		render json: @search
	end

	private
		def search_params
			params.require(:search).permit(:hashtag, :start_date, :end_date)
		end
end

