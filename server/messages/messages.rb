#Todas as classes herdadas de JSONable respondem aos métodos #to_json e #from_json!

#classe pai de todas as mensagens enviadas ao cliente
class Message < JSONable
  
  def initialize(controller,action,parameters={})
    @controller = controller
    @action = action
    @params = parameters
  end
    
  def each
    self.instance_variables.each do |v|
      puts "Message#each: #{v}"
      yield v, self.instance_variable_get(v)
    end
  end
  
  def html_escaped(str)
    CGI::escapeHTML(str)
  end    
end
