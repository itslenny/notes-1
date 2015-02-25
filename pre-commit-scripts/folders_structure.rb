
format_error = false

def puts_formating_errors(folders, prefix="\t")
  if prefix == "\t" && !folders.empty?
    puts "\033[33mFormatting Errors:\033[0m"
  end

  folders.each do |folder_name, sub_folders|
    puts "#{prefix}\033[31m#{folder_name}\033[0m"
    puts_formating_errors(sub_folders, prefix + "\t")
  end
end

folder_errors = {}

def check_lesson(lesson, day_name, week_name, folder_errors)
  day_regex = Regexp.new("#{week_name}\/#{day_name}\/(.*)")
  lesson_name = lesson.match(day_regex)[1]
  unless lesson_name =~ /d(awn|usk)\_(\w+\_)*\w+/
    if folder_errors[week_name] 
      if folder_errors[week_name][day_name]
        folder_errors[week_name][day_name][lesson_name] = {}
      else
        folder_errors[week_name]["#{day_name}/#{lesson_name}"] = {}
      end
    elsif folder_errors["#{week_name}/#{day_name}"]
      folder_errors["#{week_name}/#{day_name}"][lesson_name] = {}
    else
      folder_errors[lesson] = {}
    end
  end
end

def check_day(day, week_name, folder_errors)
    week_regex = Regexp.new("#{week_name}\/(.*)")
    day_name = day.match(week_regex)[1]
    unless day_name =~ /^day_\d_(\w+\_)*\w+$/
      if(folder_errors[week_name])
        folder_errors[week_name][day_name] ||= {}
      else
        folder_errors["#{week_name}/#{day_name}"] = {}
      end
    end
    Dir.glob("#{day}/*").each do |fldr|
        check_lesson(fldr, day_name, week_name, folder_errors)
    end
end


def check_week(week_name, folder_errors)
  unless week_name =~ /^week\_(\d{2})\_(\w+\_)*\w+$/
    folder_errors[week_name] = {}
  end

  Dir.glob("#{week_name}/day*").each do |day|
    check_day(day, week_name, folder_errors)
  end
end




Dir.glob("week*").each do |week_name|
  check_week(week_name, folder_errors)
end

puts_formating_errors(folder_errors)
