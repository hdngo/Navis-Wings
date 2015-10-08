require 'json'

class SearchesController < ApplicationController
	def new
		redirect_to searches_url
	end

	def create
		p params
		@search = Search.new({hashtag: params["hashtag"]})
		@search.save
		redirect_to 'index'
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

