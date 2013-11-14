module EtcMigration
  def migrate_etc(from: nil, to: nil)
    drop_etc version: from
    yield if block_given?
    load_etc version: to
  end

  def reload_etc(version: nil, &block)
    migrate_etc from: version, to: version, &block
  end

  def load_etc(version: nil)
    raise "Must specify version" unless version
    execute File.read(Rails.root.join 'db', 'etc', "#{version}.sql")
    say "loaded db/etc/#{version}.sql", true
  end

  def drop_etc(version: nil)
    raise "Must specify version" unless version
    views = File.read(Rails.root.join 'db', 'etc', "#{version}.sql").scan(/CREATE\s+(OR REPLACE\s+)?VIEW\s+(?<name>[^\s]+)\s+AS/).flatten
    views.reverse.each do |view|
      execute "DROP VIEW IF EXISTS #{view}"
    end
    say "dropped db/etc/#{version}.sql", true
  end
end
