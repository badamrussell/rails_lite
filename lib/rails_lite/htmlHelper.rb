require 'erb'

module HTMLHelper

  def link_to(name, address)
    <<-END
    <a href="#{address}" name="#{name}">#{name}</a>
    END
  end

  def button_to(name, address, method)
    <<-END
    <form action="#{address}" method="post">
    <input type="hidden" name="_method" value="#{method[:method] || "" }">
    <input type="submit" name="#{name}" id="#{name}">
    </form>
    END
  end

end