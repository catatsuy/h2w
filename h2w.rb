# -*- coding: utf-8 -*-

# h2w.rb
# web http://www.catatsuy.org/
# twitter http://twitter.com/catatsuy
# facebook http://www.facebook.com/catatsuy
# mail catatsuy@catatsuy.org
#
# Copyright 2012, KANEKO Tatsuya
# Free to use and abuse under the MIT license.
# http://www.opensource.org/licenses/mit-license.php
filename = ARGV[0]
user_file = open(filename)#ユーザーのデータ

pre_fla = 0

while text = user_file.gets do
  text.chomp!
  if text =~ /↑/u
    next
  end
  text.gsub!(/<strong>/u, "\'\'")
  text.gsub!(/<\/strong>/u, "\'\'")
  text.gsub!(/&gt;/u, "<")
  text.gsub!(/&lt;/u, ">")
  text.gsub!(/<del>/u, "%%")
  text.gsub!(/<\/del>/u, "%%")
  
  if text =~ /<ol.+?<li>/u
    text.sub!(/<ol.+?<li>/u, "\+")
    text.gsub!(/<\/li><li>/u, "\n\+")
  end

  if text =~ /<ul .+<li>/u
    text.sub!(/<ul .+<li>/u, "\-")
    text.gsub!(/<\/li><li>/u, "\n\-")
  end
  
  if text =~ /<h(\d)>(.+)<a\s.*/u
    ast = '*'
    ti = $1.to_i - 1
    text = ast.to_s * ti + $2.to_s
  end
  
  if pre_fla == 1
    text = " " + text
  end
  if text =~ /<pre.*?>(.+)/u
    text = " " + $1.to_s
    pre_fla = 1
  end
  if text =~ /(.*)<\/pre>/u
    text = $1
    pre_fla = 0
  end

  if text =~ /<p>(.+)<\/p>/u
    text = $1
  end

  loop do
  if text =~ /(.*?)<a.*?href=\"(\S+?)\".*?>(.+?)<\/a>(.*)/u
    text = $1 + "\[\[" + $3 + ":" + $2 + "\]\]" + $4
  else
    break
  end
  end
  
  if text =~ /<dl.*?><dt>(.*)<\/dd><\/dl>/u
    text = ":" + $1
    text.gsub!(/<\/dd><dt>/, "\n:")
    text.gsub!(/<\/dt><dd>/, "|")
  end
  
  print text , "\n"

end

user_file.close
