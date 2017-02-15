task all_specs: :environment do
  Rake::Task['spec'].invoke
end

task default: :all_specs
