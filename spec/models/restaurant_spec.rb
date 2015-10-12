require 'rails_helper'

# RSpec.describe Restaurant, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

describe Restaurant, type: :model do
  it { is_expected.to have_many :reviews }
end
