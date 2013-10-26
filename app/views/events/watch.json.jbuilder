@payload.each do |k,v|
  if v['error']
    json.set! k, v
  elsif v['view']
    json.set!(k) { json.partial! v['view'], data: v }
  end
end
