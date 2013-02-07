
def with_temporary_settings(settings, &block)
  originals = {}
  settings.each {|var,value| originals[var] = send var }
  begin
    settings.each { |var,value| set var, value }
    yield
  ensure
    originals.each { |var,value| set var, value }
  end
end
