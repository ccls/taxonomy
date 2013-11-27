Taxonomy::Application.routes.draw do
	resources :blast_results
	resources :identifiers, :only => [:index,:show]
	resources :nodes, :only => [:index,:show]
	resources :names, :only => [:index,:show]

	#root :to => 'sunspot#show'
	#resource  :sunspot, :only => [:show]

	root :to => 'sunspot/blast_results#index'
	namespace :sunspot do
		resources :blast_results,:only => :index
	end
end
