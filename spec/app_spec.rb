require File.expand_path '../spec_helper.rb', __FILE__

describe 'fetching valid static asset' do
  it 'should return successfully' do
    get '/static/pwd.js'
    expect(last_response.status).to eq 200
  end
end

describe 'fetching missing static asset' do
  it 'should return unsuccessfully' do
    get '/static/non-existing-file'
    expect(last_response.status).to eq 404
  end
end

describe 'status page' do
  it 'exists' do
    get '/status'
    expect(last_response.status).to eq 200
  end
end

# TODO: get this working once state has moved into a class?
# describe 'github to githubusercontent' do
#   it 'translates url correctly' do
#     content = fetch_doc 'https://github.com/jonocodes/pwder/blob/master/README.md'
#     expect(content).to include('Docker')
#   end
# end
