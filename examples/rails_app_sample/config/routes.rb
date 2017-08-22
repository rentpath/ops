RailsAppSample::Application.routes.draw do
  mount Ops.new, at: '/ops'
end
