Factory.define(:animal) do |f|
  f.sequence(:name) {|n| "Fake Animal Name #{n}"}
  f.image(File.new(Rails.root.to_s + "/test/animal_images/arbitrary_image.jpg"))
end


Factory.define(:match) do |f|
  f.association :opponent_1, :factory => :animal
  f.association :opponent_2, :factory => :animal
end

Factory.define(:battle) do |f|
  f.association :winner, :factory => :animal
  f.association :loser, :factory => :animal
  f.association :match
end

Factory.define(:comment) do |f|
  f.comment "Technically the porcupine is superior because bla bla bla..."
  f.association :commentable_id, :factory => :match
  f.commentable_type "Match"
end

Factory.define(:user) do |f|
  f.sequence(:username) {|n| "fake_username_#{n}"}
end
  