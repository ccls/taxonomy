class BlastResultsController < ApplicationController
	# GET /blast_results
	# GET /blast_results.json
	def index
		@blast_results = BlastResult.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @blast_results }
		end
	end

	# GET /blast_results/1
	# GET /blast_results/1.json
	def show
		@blast_result = BlastResult.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @blast_result }
		end
	end

#	# GET /blast_results/new
#	# GET /blast_results/new.json
#	def new
#		@blast_result = BlastResult.new
#
#		respond_to do |format|
#			format.html # new.html.erb
#			format.json { render json: @blast_result }
#		end
#	end
#
#	# GET /blast_results/1/edit
#	def edit
#		@blast_result = BlastResult.find(params[:id])
#	end
#
#	# POST /blast_results
#	# POST /blast_results.json
#	def create
#		@blast_result = BlastResult.new(params[:blast_result])
#
#		respond_to do |format|
#			if @blast_result.save
#				format.html { redirect_to @blast_result, notice: 'Blast result was successfully created.' }
#				format.json { render json: @blast_result, status: :created, location: @blast_result }
#			else
#				format.html { render action: "new" }
#				format.json { render json: @blast_result.errors, status: :unprocessable_entity }
#			end
#		end
#	end
#
#	# PUT /blast_results/1
#	# PUT /blast_results/1.json
#	def update
#		@blast_result = BlastResult.find(params[:id])
#
#		respond_to do |format|
#			if @blast_result.update_attributes(params[:blast_result])
#				format.html { redirect_to @blast_result, notice: 'Blast result was successfully updated.' }
#				format.json { head :no_content }
#			else
#				format.html { render action: "edit" }
#				format.json { render json: @blast_result.errors, status: :unprocessable_entity }
#			end
#		end
#	end
#
#	# DELETE /blast_results/1
#	# DELETE /blast_results/1.json
#	def destroy
#		@blast_result = BlastResult.find(params[:id])
#		@blast_result.destroy
#
#		respond_to do |format|
#			format.html { redirect_to blast_results_url }
#			format.json { head :no_content }
#		end
#	end
end
