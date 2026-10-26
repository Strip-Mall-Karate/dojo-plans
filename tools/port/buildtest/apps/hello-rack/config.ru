run lambda { |env| [200, {"Content-Type" => "text/plain"}, [ENV.fetch("GREETING", "hello")]] }
