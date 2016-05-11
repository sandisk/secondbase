namespace :db do
  namespace :second_base do
    task :drop do
      SecondBase.on_base { Rake::Task['db:drop'].execute }
    end

    namespace :migrate do
      task :reset => ['db:second_base:drop', 'db:second_base:create', 'db:second_base:migrate']
    end
  end
end

%w{
  drop
}.each do |name|
  task = Rake::Task["db:#{name}"] rescue nil
  next unless task
  task.enhance do
    Rake::Task["db:load_config"].invoke
    Rake::Task["db:second_base:#{name}"].invoke
  end
end