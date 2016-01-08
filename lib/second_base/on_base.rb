module SecondBase

  def self.on_base
    original_config = ActiveRecord::Tasks::DatabaseTasks.current_config
    original_configurations = ActiveRecord::Base.configurations
    original_migrations_path = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
    original_db_dir = ActiveRecord::Tasks::DatabaseTasks.db_dir
    ActiveRecord::Tasks::DatabaseTasks.current_config = config
    ActiveRecord::Base.configurations = original_configurations[Railtie.config_key]
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Tasks::DatabaseTasks.migrations_paths = SecondBase::Railtie.fullpath('migrate')
    ActiveRecord::Tasks::DatabaseTasks.db_dir = SecondBase::Railtie.fullpath
    ActiveRecord::Migrator.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
    yield
  ensure
    ActiveRecord::Base.configurations = original_configurations
    ActiveRecord::Tasks::DatabaseTasks.migrations_paths = original_migrations_path
    ActiveRecord::Tasks::DatabaseTasks.db_dir = original_db_dir
    ActiveRecord::Migrator.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths
    ActiveRecord::Tasks::DatabaseTasks.current_config = original_config
    ActiveRecord::Base.establish_connection(original_config)
  end

end