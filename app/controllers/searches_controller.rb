require 'json'

class SearchesController < ApplicationController
	def new
		redirect_to searches_url
	end

	def create
		p "*" * 100
		@search = Search.new({hashtag: params["hashtag"], start_date: params["start_date"], end_date: params["end_date"]})
		@search.save

		response = HTTParty.get('https://api.instagram.com/v1/tags/snow/media/recent?access_token=1458656326.1fb234f.3ca08ac5039a40ac92cc74d6cf27aa05')
		response_body = JSON.parse(response.body)

		if response_body["data"]

			response_body["data"].each do |result|
				filtered_result_data = filter_data(result)
				@result = Result.create(ig_username: filtered_result_data[:ig_username], content_type: filtered_result_data[:content_type], ig_link: filtered_result_data[:ig_link], image_url: filtered_result_data[:image_url], video_url: filtered_result_data[:video_url], description: filtered_result_data[:description], search_id: @search.id)
				end

				p "is there a next page?"
				if has_next_page_link?(response_body)
					p 'yeah, keep going!'
					InstagrabsWorker.perform_async(response_body["pagination"]["next_url"], @search.id)
					# paginate(response_body["pagination"]["next_url"], @search.id)
				end
		end
		# @search.test
		# write filters to filter out things by date and hash tag inclusion
		# puts response_body["pagination"]
		# load more button in the background 
		# rails does have a background job
		#sidekiq

		# make first request, start background job,return the first 20, , go back to client
		# create a load more button if there is a next page
		# click the load button and hit a second route in the controller that will make a request that renders the images/videos without storing them because the background job is already going
		# next route for 20 doesnt need to know instagram api, it hits your database
		# could have a function click first - my . separate functions. hit initial route to call the function thatd does the paging n pass in records
		# function for calling and function for posting
		# 1st call process return to function that calls get more and return
		render json: @search.results
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

