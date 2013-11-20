
require 'active_support/core_ext'

module URLHelper
  def makeURLS
    str_name = self.class.to_s.downcase
    str_name = str_name[0...(str_name.index("controller"))].singularize

    #DO NOT LIKE THIS
    # WHERE TO GRAB THIS ADDRESS FROM?
    base_url = "http://0.0.0.0.3000"

    #BETTER WAY TO GRAB THE NAMES
    method_names = [  "#{str_name.pluralize}",
                      "new_#{str_name}",
                      "edit_#{str_name}",
                      "#{str_name}"
                    ]

    method_names.each do |name|
      self.class_eval do
        define_method("#{name}_url") do |*ids|
          "#{base_url}/#{name}" << (ids.empty? ? "" : "/#{ids.join("&")}")
        end
        define_method("#{name}_path") do |*ids|
          "/#{name}" << (ids.empty? ? "" : "/#{ids.join("&")}")
        end
      end
    end
  end


  def make_urls(path_prefixes)
    #DO NOT LIKE THIS
    # WHERE TO GRAB THIS ADDRESS FROM?
    base_url = "http://0.0.0.0.3000"

    path_prefixes.each do |name|
      self.class_eval do
        define_method("#{name}_url") do |*ids|
          "#{base_url}/#{name}" << (ids.empty? ? "" : "/#{ids.join("&")}")
        end
        define_method("#{name}_path") do |*ids|
          "/#{name}" << (ids.empty? ? "" : "/#{ids.join("&")}")
        end
      end
    end
  end

  def resource(name)
    path_prefixes = [ name,
                      "new_#{name}",
                      "edit_#{name}"
                    ]
    make_urls(path_prefixes)
  end

  def resources(name, &proc)
    path_prefixes = [ name,
                      name.pluralize,
                      "new_#{name}",
                      "edit_#{name}"
                    ]
    make_urls(path_prefixes)


  end

end