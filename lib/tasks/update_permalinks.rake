namespace :groupthink do
  desc 'Updates the permalinks.'
  task :update_permalinks => :merb_env do
    Group.all.each do |g|
      g.save
      puts "#{g.name} saved as #{g.grouplink}."
    end
  end
end
