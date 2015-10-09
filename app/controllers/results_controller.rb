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

	def show_page
		@search = Search.find(params[:id])
		result_offset = params[:result_offset].to_i
		results_subset = @search.results[result_offset..(result_offset + 19)]
		next_page_boolean = false;
		if @search.results.length > result_offset + 10
			next_page_boolean = true;
		end
		
		# results.map!{ |result| result.to_json}
		# next_media_set = results[page_num]
		# render json: {search_id: @search.id, page: page_num, next_results: next_media_set}
		render json: {search_id: @search.id, results: results_subset, next_page: next_page_boolean}
	end

	private
		def result_params
			params.require(:result).permit(:ig_username, :tag_time, :type, :ig_link, :image_url, :video_url, :description)
		end
end
