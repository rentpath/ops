Rails3::Application.routes.draw do
  mount Ops.new, :at => "/ops"
end
