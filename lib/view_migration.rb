module ViewMigration
  def load_view(name, options = {})
    version = options.delete(:version) || 1
    filename = Rails.root.join("db/etc/#{name}/#{version}.sql")
    raise "Cannot find '#{filename}'\n" unless File.exists?(filename)
    execute File.read(filename)
  end

  def drop_view(name)
    execute "DROP VIEW IF EXISTS #{name}"
  end
end
