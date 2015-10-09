class InstagrabsWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false

	def perform(next_page_url, search_id, hashtag, search_start_date, search_end_date)
		paginate(next_page_url, search_id, hashtag, search_start_date, search_end_date)
	end

	def contains_hashtag?(text, hashtag)
	  text.downcase.include?(hashtag)
	end

	def falls_within_date_range?(date, start_date, end_date)
	  if(start_date.to_i <= date.to_i && date.to_i <= end_date.to_i)
	    return true
	  else
	    return false
	  end
	end	

	def has_next_page_link?(response_body)
		response_body["pagination"]["next_url"] ? true : false
	end

	def caption_empty?(result)
	 result["caption"]["text"] ? false : true
	end

	def is_a_video?(result)
		result["type"] == "video"
	end

	 def filter_data(result, hashtag, search_start_date, search_end_date)
	  filtered_data = {ig_username: result["user"]["username"], content_type: result["type"], image_url: result["images"]["standard_resolution"]["url"], "ig_link": result["link"]}

	  if caption_empty?(result)
	    filtered_data[:description] = ""
	  else
	    created_time = result["caption"]["created_time"].concat("000")
	    filtered_data[:description] = result["caption"]["text"]
	    if contains_hashtag?(filtered_data[:description], hashtag)
	      if falls_within_date_range?(created_time, search_start_date, search_end_date)
	        filtered_data[:tag_time] = created_time
	      end
	    else
	      comments = result["comments"]["data"].select {|comment| comment['from']['username'] == filtered_data[:ig_username]}
	      comments.each do |comment|

	        if contains_hashtag?(comment["text"], hashtag)
	          p comment["text"]
	          filtered_data[:tag_time] = comment["created_time"].concat("000")
	          break
	        end
	      end

	    end
	  end

	  if is_a_video?(result)
	    filtered_data[:video_url] = result["videos"]["standard_resolution"]["url"]
	  else
	    filtered_data[:video_url] = ""
	  end
	  filtered_data
	end

	def paginate(next_page_url, search_id, hashtag, search_start_date, search_end_date)
		response = HTTParty.get(next_page_url)

		response_body = JSON.parse(response.body)

			response_body["data"].each do |result|
				filtered_result_data = filter_data(result, hashtag, search_start_date, search_end_date)
				@result = Result.create(ig_username: filtered_result_data[:ig_username], content_type: filtered_result_data[:content_type], ig_link: filtered_result_data[:ig_link], image_url: filtered_result_data[:image_url], video_url: filtered_result_data[:video_url], description: filtered_result_data[:description], search_id: search_id)
			end

			if has_next_page_link?(response_body)
				paginate(response_body["pagination"]["next_url"], search_id, hashtag, search_start_date, search_end_date)
			else
				return
			end
	end
end