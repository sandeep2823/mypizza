## DataMagic namespace for monkey patching
module DataMagic
  ##
  # :category: extensions
  #
  # Works like the existing data_for but instead of blowing up if the key is missing returns the data found in +default+
  def data_for_or_default(key, default = {}, additional = {})
    if key.is_a?(String) && key.match(%r{/})
      filename, record = key.split('/')
      DataMagic.load("#{filename}.yml")
    else
      record = key.to_s
      DataMagic.load(the_file) unless DataMagic.yml
    end

    data = DataMagic.yml[record]
    data = default.dup unless data
    additional.key?(record) ? prep_data(data.merge(additional[record]).clone) : prep_data(data)
  end

  def data_for?(key)
    if key.is_a?(String) && key.match(%r{/})
      filename, record = key.split('/')
      DataMagic.load("#{filename}.yml")
    else
      record = key.to_s
      DataMagic.load(the_file) unless DataMagic.yml
    end
    DataMagic.yml.key? record
  end
end

## YmlReader namespace for monkey patching
module YmlReader
  ##
  # :category: extensions
  #
  # Loads the requested file.  It will look for the file in the
  # directory specified by a call to the yml_directory= method.
  # uses load_erb
  def load(filename)
    @yml = YAML.load_erb "#{yml_directory}/#{filename}"
  end
end
