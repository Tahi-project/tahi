namespace :styleguide do
  desc "Generate Live Styleguide"
  task generate: :environment  do
    system "rspec spec/features/harvest_styleguide.rb"
    system "ruby populate_styleguide.rb"
  end

  task watch: :environment do
    system('nodemon --exec "ruby populate_styleguide.rb" -w app/views/kss/home/styleguide_template.html.erb populate_styleguide.rb -V')
  end
end
