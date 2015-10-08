# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@first_search = Search.create(hashtag: "snow", start_date: DateTime.now(), end_date: DateTime.now())
@first_search.save

@first_result = Result.create(ig_username: 'harveydngo', tag_time: DateTime.now(), content_type: "avideo", ig_link: "http://instagram.com/harveydngo", image_url: "", video_url: "http://youtube.com", description: "this is a test video but not really", search_id: 1)
@first_result.save