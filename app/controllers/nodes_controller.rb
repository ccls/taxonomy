class NodesController < ApplicationController

	# GET /nodes
	# GET /nodes.json
	def index
		params[:parent_taxid] ||= 1
		@node = Node.where(:taxid => params[:parent_taxid]).first
#		@descendants = @node.descendants
		@ancestors = @node.ancestors
		@nodes = @node.children

#
#	based on the way that I'm using this, it may be better to use "show" rather than "index"
#

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @nodes }
		end
	end

	# GET /nodes/1
	# GET /nodes/1.json
	def show
		@node = Node.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json do
				render json: { :id => @node.id, :name => @node.scientific_name.to_s, :taxid => @node.taxid,
					:left => @node.lft, :right => @node.rgt, :depth => @node.depth,
					:children => @node.children.collect{|n| 
						{ :id => n.id, :name => n.scientific_name.to_s, :taxid => n.taxid }  } }
#						{ :id => n.id, :name => n.scientific_name.to_s, :taxid => n.taxid,
#							:left => n.lft, :right => n.rgt, :depth => n.depth }  } }
			end
		end
	end

#	# GET /nodes/new
#	# GET /nodes/new.json
#	def new
#		@node = Node.new
#
#		respond_to do |format|
#			format.html # new.html.erb
#			format.json { render json: @node }
#		end
#	end
#
#	# GET /nodes/1/edit
#	def edit
#		@node = Node.find(params[:id])
#	end
#
#	# POST /nodes
#	# POST /nodes.json
#	def create
#		@node = Node.new(params[:node])
#
#		respond_to do |format|
#			if @node.save
#				format.html { redirect_to @node, notice: 'Node was successfully created.' }
#				format.json { render json: @node, status: :created, location: @node }
#			else
#				format.html { render action: "new" }
#				format.json { render json: @node.errors, status: :unprocessable_entity }
#			end
#		end
#	end
#
#	# PUT /nodes/1
#	# PUT /nodes/1.json
#	def update
#		@node = Node.find(params[:id])
#
#		respond_to do |format|
#			if @node.update_attributes(params[:node])
#				format.html { redirect_to @node, notice: 'Node was successfully updated.' }
#				format.json { head :no_content }
#			else
#				format.html { render action: "edit" }
#				format.json { render json: @node.errors, status: :unprocessable_entity }
#			end
#		end
#	end
#
#	# DELETE /nodes/1
#	# DELETE /nodes/1.json
#	def destroy
#		@node = Node.find(params[:id])
#		@node.destroy
#
#		respond_to do |format|
#			format.html { redirect_to nodes_url }
#			format.json { head :no_content }
#		end
#	end
end
