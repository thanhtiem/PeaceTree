# == Schema Information
#
# Table name: positions
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :position do
    name { "MyString" }
    description { "MyText" }
  end
end
