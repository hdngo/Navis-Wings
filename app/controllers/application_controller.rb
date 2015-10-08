class ApplicationController < ActionController::API
  helper_method :has_next_page_link?, :caption_empty?, :is_a_video?, :filter_data
  # protect_from_forgery with: :exception
   before_action :allow_cross_origin_requests

   def preflight
       render nothing: true
   end

   def has_next_page_link?(response_body)
    response_body["pagination"]["next_url"] ? true : false
   end

   def caption_empty?(result)
    result["caption"]["text"].length < 1
   end

   def is_a_video?(result)
    result["type"] == "video"
   end

   def filter_data(result)
    filtered_data = {ig_username: result["user"]["username"], content_type: result["type"], image_url: result["images"]["standard_resolution"]["url"], "ig_link": result["link"]}

    if caption_empty?(result)
      filtered_data[:description] = nil
    else
      filtered_data[:description] = result["caption"]["text"]
    end

    if is_a_video?(result)
      filtered_data[:video_url] = result["videos"]["standard_resolution"]["url"]
     else
      filtered_data[:video_url] = nil
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
