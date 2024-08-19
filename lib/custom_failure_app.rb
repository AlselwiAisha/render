# # lib/custom_failure_app.rb

class CustomFailureApp < Devise::FailureApp

  def respond

    if request.controller_class.to_s.start_with? 'V1::'

      json_failure

    else

      super

    end

  end



  def json_failure

    self.status = 401

    self.content_type = 'application/json'

    self.response_body = { error: 'Authentication failed' }.to_json

  end

end

