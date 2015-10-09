class ApplicationController < ActionController::API
  helper_method :paginate, :has_next_page_link?, :caption_empty?, :is_a_video?, :filter_data
  # protect_from_forgery with: :exception
   before_action :allow_cross_origin_requests

   def preflight
    render nothing: true
   end

   # def paginate(next_page_url, search_id)
   #  response = HTTParty.get(next_page_url)
   #  response_body = JSON.parse(response.body)

   #  response_body["data"].each do |result|
   #    filtered_result_data = filter_data(result)
   #    @result = Result.create(ig_username: filtered_result_data[:ig_username], content_type: filtered_result_data[:content_type], ig_link: filtered_result_data[:ig_link], image_url: filtered_result_data[:image_url], video_url: filtered_result_data[:video_url], description: filtered_result_data[:description], search_id: search_id)
   #    end

   #    p "is there a next page?"
   #    if has_next_page_link?(response_body)
   #      p 'yeah, keep going!'
   #      paginate(response_body["pagination"]["next_url"], search_id)
   #    else
   #      return
   #    end
   # end

   def has_next_page_link?(response_body)
    response_body["pagination"]["next_url"] ? true : false
   end

   def caption_empty?(result)
    result["caption"]["text"] ? false : true
   end

   def is_a_video?(result)
    result["type"] == "video"
   end

   def filter_data(result)
    filtered_data = {ig_username: result["user"]["username"], content_type: result["type"], image_url: result["images"]["standard_resolution"]["url"], "ig_link": result["link"]}

    if caption_empty?(result)
      filtered_data[:description] = ""
    else
      filtered_data[:description] = result["caption"]["text"]
    end

    if is_a_video?(result)
      filtered_data[:video_url] = result["videos"]["standard_resolution"]["url"]
     else
      filtered_data[:video_url] = ""
    end
    filtered_data
   end

   private
     def allow_cross_origin_requests
      p "hello" * 100
       headers['Access-Control-Allow-Origin'] = '*'
       headers['Access-Control-Request-Method'] = '*'
       headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
       headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
       headers['Access-Control-Max-Age'] = '1728000'
     end
end
