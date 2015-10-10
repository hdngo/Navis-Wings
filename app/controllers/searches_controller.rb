require 'json'

class SearchesController < ApplicationController
	def new
		redirect_to searches_url
	end

	def create
		@search = Search.new({hashtag: params[:hashtag], start_date: params[:start_date], end_date: params[:end_date]})
		@search.save

		response = HTTParty.get("//api.instagram.com/v1/tags/#{params[:hashtag]}/media/recent?access_token=#{ENV['IG_TOKEN']}")A
		response_body = JSON.parse(response.body)

		hashtag = params[:hashtag].dup.prepend('#')
		if response_body["data"]

			response_body["data"].each do |result|
				filtered_result_data = filter_data(result, hashtag, @search.start_date, @search.end_date)
				@result = Result.create(ig_username: filtered_result_data[:ig_username], tag_time: filtered_result_data[:tag_time], content_type: filtered_result_data[:content_type], ig_link: filtered_result_data[:ig_link], image_url: filtered_result_data[:image_url], video_url: filtered_result_data[:video_url], description: filtered_result_data[:description], search_id: @search.id)
				end

				next_page_boolean = false
				if has_next_page_link?(response_body)
					next_page_boolean = true
					InstagrabsWorker.perform_async(response_body["pagination"]["next_url"], @search.id, hashtag, @search.start_date, @search.end_date)
				end
		end

		render json: {search_id: @search.id, results: @search.results, next_page: next_page_boolean}
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

