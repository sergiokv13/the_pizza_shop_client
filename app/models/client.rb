class Client < ApplicationRecord
	require 'net/http'

	def self.set_menu
		#Non pizza menu
		uri = URI('http://localhost:3000/non_pizzas')
		response =  Net::HTTP.get(uri) # => String
		@non_pizzas = JSON.parse response
		#Pizza types menu
		uri = URI('http://localhost:3000/pizza_types')
		response =  Net::HTTP.get(uri) # => String
		@pizza_types = JSON.parse response
		#Cheeses menu
		uri = URI('http://localhost:3000/cheeses')
		response =  Net::HTTP.get(uri) # => String
		@cheeses = JSON.parse response
		#Sizes menu
		uri = URI('http://localhost:3000/sizes')
		response =  Net::HTTP.get(uri) # => String
		@sizes = JSON.parse response
		#Crusts menu
		uri = URI('http://localhost:3000/crusts')
		response =  Net::HTTP.get(uri) # => String
		@crusts = JSON.parse response
		#Sauces menu
		uri = URI('http://localhost:3000/sauces')
		response =  Net::HTTP.get(uri) # => String
		@sauces = JSON.parse response
		#Ingredients
		uri = URI('http://localhost:3000/ingredients')
		response =  Net::HTTP.get(uri) # => String
		@ingredients = JSON.parse response
	end


	def self.non_pizza_order
		uri = URI.parse("http://localhost:3000/dishes")
		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request["Accept"] = "application/json"
		request.body = JSON.dump({
		  "dish" => {
		    "non_pizza_id" => @non_pizzas.sample["id"].to_s
		  }
		})

		req_options = {
		  use_ssl: uri.scheme == "https",
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end
		puts "Non pizza ordered"
		puts JSON.parse response.body
	end

	def self.pizza_order
		#PIZZA Election
						uri = URI('http://localhost:3000/pizzas')
						request = Net::HTTP::Post.new(uri)
						request.content_type = "application/json"
						request["Accept"] = "application/json"
						request.body = JSON.dump({
						  "pizza" => {
						    "pizza_type_id" => @pizza_types.sample["id"].to_s,
						    "cheese_id" =>  @cheeses.sample["id"].to_s,
						    "size_id" => @sizes.sample["id"].to_s,
						    "sauce_id" => @sauces.sample["id"].to_s,
						    "crust_id" => @crusts.sample["id"].to_s
						  }
						})

						req_options = {
						  use_ssl: uri.scheme == "https",
						}
						response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
						    http.request(request)
						end
						pizza = JSON.parse response.body
						#Add ingredients
						
						#Pizza Order
						uri = URI.parse("http://localhost:3000/dishes")
						request = Net::HTTP::Post.new(uri)
						request.content_type = "application/json"
						request["Accept"] = "application/json"
						request.body = JSON.dump({
						  "dish" => {
						    "pizza_id" => pizza["id"].to_s
						  }
						})

						req_options = {
						  use_ssl: uri.scheme == "https",
						}

						response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
						  http.request(request)
						end
						puts "Pizza ordered"
						puts JSON.parse response.body
	end


	def self.client_iteration
		Client.set_menu
		while(true)
			#random number of clients
			clients_number = [*1..3].sample
			#iteration between clients
			(1..clients_number).each do
				#random number of products
				products_number = [*1..3].sample
				#iteration for the orders
				(1..products_number).each do
					if [true, false].sample
						#NON PIZZA ORDER
						Client.non_pizza_order
					else
						#PIZZA ORDER
						Client.pizza_order
					end
				end
			end

			#Every randon n seconds delay
			sleep([*10..20].sample)
		end
	end

end
