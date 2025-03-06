require 'rails_helper'

RSpec.describe 'Assets Compilation', type: :feature do
  it 'compiles CSS assets' do
    visit root_path
    expect(page).to have_css('link[href*="application.css"]')
  end

  it 'compiles JavaScript assets' do
    visit root_path
    expect(page).to have_css('script[src*="application.js"]')
  end
end

RSpec.describe 'Hello World', type: :feature do
  it 'displays the hello world message' do
    visit '/'
    expect(page).to have_content('Hello, world!')
  end
end
