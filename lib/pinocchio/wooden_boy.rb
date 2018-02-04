require 'yaml'

class Pinocchio::WoodenBoy
  #attr_accessor :lies

  def initialize
    @lies = []
  end

  def learn(lie_path)
    lie_yaml = YAML.load(File.read(lie_path))

    url_separated_params = lie_yaml['url'].split('?')
    params_if_any        = url_separated_params.size == 2 ? Hash[url_separated_params.last.split('&').map{|p| p.split('=')}] : {}
    lie      = Pinocchio::Lie.new({
      url:              url_separated_params.first,
      params:           params_if_any,
      method:           lie_yaml['method'],
      ignorable_params: lie_yaml['ignorable_params'],
      response: {
        code:         lie_yaml['response']['code'],
        content_type: lie_yaml['response']['Content-Type'],
        body:         lie_yaml['response']['body']
      }
    })
     # puts "+" * 20
     # p lie
     # puts "+" * 20
    @lies << lie
  end

  def answer(request_lie)
     # p "-" * 20
     # p request_lie
     # p "-" * 20
    @lies.select do |lie|
      lie == request_lie
    end.first
  end

  def call(env)
    begin
      pinocchio_answer = answer( convert_request_to_lie(env) )
      # p "~" * 15
      # p pinocchio_answer
      # p "~" * 15
      if pinocchio_answer
        convert_lie_to_response(pinocchio_answer)
      else
        [404, {'Content-Type' => 'text/html'}, ["Oops. I know nothing about: #{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}"]]
      end
    rescue => error
      # TODO Use the LOG, Luke!
      puts "Error on request[#{env["PATH_INFO"]}]: #{error.inspect}"
      return [500, {'Content-Type' => 'text/html'}, [error.inspect]]
    end
  end

  private
  def convert_request_to_lie(env)
    # p "-" * 20
    # p env
    # p "-" * 20
    Pinocchio::Lie.new({
      method:  env['REQUEST_METHOD'],
      url:     env['REQUEST_PATH'],
      params:  Hash[env['QUERY_STRING'].split('&').map{|p| p.split('=')}]
    })
  end

  def convert_lie_to_response(lie)
    content_type = lie.response[:content_type] || 'text/plain'
    body = convert_body_according_to_content_type(content_type, lie.response[:body])
    [ lie.response[:code], {'Content-Type' => content_type}, [body] ]
  end

  def convert_body_according_to_content_type(content_type, body)
    case content_type
    when /json/
      body.to_json
    else
      body
    end
  end
end
