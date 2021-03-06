require 'rails_helper'

RSpec.describe List, :type => :model do
  it { should have_many :todos }
  it { should belong_to :user }
end
