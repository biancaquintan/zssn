FactoryBot.define do
  factory :user do
    name { "Jena" }
    gender { "Female" }
    age { 25 }
  end

  factory :user2 do
    name { "Fred" }
    gender { "Male" }
    age { 31 }
  end

end