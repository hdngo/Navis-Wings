require 'json'

class SearchesController < ApplicationController
	def new
		redirect_to searches_url
	end

	def create
		p "*" * 100
		@search = Search.new({hashtag: params["hashtag"], start_date: params["start_date"], end_date: params["end_date"]})
		@search.save

		response = HTTParty.get('https://api.instagram.com/v1/tags/snow/media/recent?access_token=1458656326.1fb234f.3ca08ac5039a40ac92cc74d6cf27aa05&max_tag_id=1090757953623701075')
		responseBody = JSON.parse(response.body)
		@search.test
		# write filters to filter out things by date and hash tag inclusion
		# puts responseBody["pagination"]

		render json: responseBody["pagination"]
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

