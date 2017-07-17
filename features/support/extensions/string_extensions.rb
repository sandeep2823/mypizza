class String
  ##
  # :category: extensions
  def to_page_class_name
    res = camelcase(:upper).delete(' ')
    res = "#{res}Page" unless res =~ /Page$/
    res
  end

  def to_page_class
    Object.const_get to_page_class_name
  end
end
