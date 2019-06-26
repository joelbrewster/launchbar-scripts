require "rexml/document"

class Feedback

  attr_accessor :items
  @@time = Time.now.to_s

  def initialize
    @items = []
  end

  def add_item(opts = {})
    opts[:subtitle] ||= ""
    opts[:icon] ||= {:type => "default", :name => "icon.png"}
    if opts[:uid].nil?
      opts[:uid] ||= opts[:title]
      opts[:uid] += @@time
    end
    opts[:arg] ||= opts[:title]
    opts[:valid] ||= "yes"
    opts[:autocomplete] ||= opts[:title]
    opts[:type] ||= "default"

    @items << opts unless opts[:title].nil?
  end

  def to_xml(items = @items)
    document = REXML::Element.new("items")
    items.each do |item|
      new_item = REXML::Element.new('item')
      new_item.add_attributes({
        'uid'          => item[:uid], 
        'arg'          => item[:arg], 
        'valid'        => item[:valid], 
        'autocomplete' => item[:autocomplete]
      })
      new_item.add_attributes('type' => 'file') if item[:type] == "file"
      
      REXML::Element.new("title", new_item).text    = item[:title]
      REXML::Element.new("subtitle", new_item).text = item[:subtitle]
      unless item[:badge].empty?
        REXML::Element.new("badge", new_item).text = item[:badge]
      end
      REXML::Element.new("alwaysShowsSubtitle", new_item).text = "true"
      # REXML::Element.new("action", new_item).text = "execute.scpt"
      REXML::Element.new("action", new_item).text = "action.sh"
      REXML::Element.new("actionArgument", new_item).text = item[:arg]      
      
      icon = REXML::Element.new("icon", new_item)
      icon.text = item[:icon][:name]
      icon.add_attributes('type' => 'fileicon') if item[:icon][:type] == "fileicon"
      
      document << new_item
    end
    
    document.to_s
  end

end
