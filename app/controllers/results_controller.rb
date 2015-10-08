class ResultsController < ApplicationController
	def create
		@search = Search.find(params[:search_id])
		@result = @search.results.create(search_params)
	end

	# def show
	# 	@search = Search.find(params[:search_id])
	# 	@result = @search.results.find(params[:id])
	# 	render json: @result
	# end

	def index
		@search = Search.find(params[:search_id])
		render json: @search.results
	end

	private
		def result_params
			params.require(:result).permit(:ig_username, :tag_time, :type, :ig_link, :image_url, :video_url, :description)
		end
end
