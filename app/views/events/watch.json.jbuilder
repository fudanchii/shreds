@payload.each do |k,v|
  if v['error'] then
    json.set! k, v
  elsif v['view'] then
    json.set! k do
      json.partial! v['view'], data: v
    end
  end
end
