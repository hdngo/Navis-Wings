require 'json'

class SearchesController < ApplicationController
	def new
		redirect_to searches_url
	end

	def create
		p "*" * 100
		@search = Search.new({hashtag: params["hashtag"], start_date: params["start_date"], end_date: params["end_date"]})
		@search.save

		response = HTTParty.get('https://api.instagram.com/v1/tags/pixleememories/media/recent?access_token=1458656326.1fb234f.3ca08ac5039a40ac92cc74d6cf27aa05')
		response_body = JSON.parse(response.body)

		if response_body["data"]

			response_body["data"].each do |result|
				filtered_result_data = filter_data(result)
				@result = Result.create(ig_username: filtered_result_data[:ig_username], content_type: filtered_result_data[:content_type], ig_link: filtered_result_data[:ig_link], image_url: filtered_result_data[:image_url], video_url: filtered_result_data[:video_url], description: filtered_result_data[:description], search_id: @search.id)
				end

				p "is there a next page?"
				if has_next_page_link?(response_body)
					p 'yeah, keep going!'
					paginate(response_body["pagination"]["next_url"], @search.id)
				end
		end
		# @search.test
		# write filters to filter out things by date and hash tag inclusion
		# puts response_body["pagination"]

		render json: response_body["pagination"]
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
# filter by date, filter by tag then check case of date and if not move on and so forth

