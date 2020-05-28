require 'rails_helper'

RSpec.describe Location, type: :model do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:link).of_type(:string) }
end
