
  require 'rubygems'
  require 'sequel'
  require 'fileutils'
  require 'yaml'


  		puts "Building refresh layout"
		File.open("source/_layouts/refresh.html", "w") do |f|
	    f.puts <<EOF    
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="refresh" content="0;url={{ page.refresh_to_post_id }}.html" />
</head>
</html>
EOF
		end

		DB = Sequel.connect(:adapter => 'mysql', :user => 'root', :host => 'localhost', :database => 'html5',:password=>'frog')
		puts DB.tables

		QUERY = "select  node.nid, node.title, node_revisions.body, node.created, node.status, f.name as format, u.dst \
		     from node \
		          join node_revisions on node.vid = node_revisions.vid \
		          join filter_formats f on node_revisions.format = f.format \
		          left join url_alias u on concat('node/', node.nid) = u.src \
		     where (node.type = 'blog' OR node.type = 'story' OR node.type = 'article')"

	     DB[QUERY].each do |post|

	        # Get required fields and construct Jekyll compatible name
	        node_id = post[:nid]
	        # puts node_id
	        title = post[:title]
	        puts title
	        content = post[:body]
	        # puts content
	        created = post[:created]
	        format = post[:format].strip.downcase == 'textile' ? 'textile' : 'markdown'
	        dst  = post[:dst] || nil
	        time = Time.at(created)
	        is_published = post[:status] == 1
	        published = is_published ? nil : false
	        dir = "source"
	        posts_dir = "#{dir}/_posts"
	        slug = title.strip.downcase.gsub(/(&|&amp;)/, ' and ').gsub(/[\s\.\/\\]/, '-').gsub(/[^\w-]/, '').gsub(/[-_]{2,}/, '-').gsub(/^[-_]/, '').gsub(/[-_]$/, '')
	        name = time.strftime("%Y-%m-%d-") + slug + '.' + format
	        # puts name

	        tag_query = "select distinct node.nid, type, td.name \
	                     from node \
	                          join term_node tn on node.nid = tn.nid \
	                          join term_data td on tn.tid = td.tid \
	                     where node.nid = #{node_id} order by node.nid"
	        tags = []
	        DB[tag_query].each do |tag|
	          stripped_tag = tag[:name].gsub /"/, '|'
	          tags.push stripped_tag
	        end
	        tag_list = tags.length == 0 ? nil : tags
	        
	        puts tag_list

	        # Write out the data and content to file
	        File.open("#{posts_dir}/#{name}", "w") do |f|
	          f.puts "---"
	          f.puts "layout: post"
	          f.puts "title: \"#{title}\"" 
	          f.puts "date: #{time}" 
	          f.puts "comments: true"
	          f.puts "categories: #{tag_list}"
	          f.puts "---"
	          f.puts content
	        end

	        # Make a file to redirect from the old Drupal URL
	        if is_published
	          FileUtils.mkdir_p(dir + "/node/#{node_id}")
	          File.open(dir + "/node/#{node_id}/index.md", "w") do |f|
	            f.puts "---"
	            f.puts "layout: refresh"
	            f.puts "refresh_to_post_id: /blog/#{time.strftime("%Y/%m/%d/") + slug}/index"
	            f.puts "---"
	          end
	          if dst
	            FileUtils.mkdir_p("#{dir}/#{dst}")
	            File.open("#{dir}/#{dst}/index.md", "w") do |f|
	              f.puts "---"
	              f.puts "layout: refresh"
	              f.puts "refresh_to_post_id: /blog/#{time.strftime("%Y/%m/%d/") + slug}/index"
	              f.puts "---"
	            end
	          end
	        end
	      end