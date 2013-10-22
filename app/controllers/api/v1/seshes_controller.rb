class Api::V1::SeshesController < ApplicationController

  version 1

  # GET /seshes
  # GET /seshes.json
  def index
    @seshes = Sesh.all

    render json: @seshes
  end

  # GET /seshes/1
  # GET /seshes/1.json
  def show
    @sesh = Sesh.find(params[:id])

    if @sesh
      expose @sesh
    else
      error! :not_found
    end
  end

  # POST /seshes
  # POST /seshes.json
  def create
    @sesh = Sesh.new(new_sesh_params)

    if @sesh.save
      expose @sesh, status: :created, location: @sesh
    else
      expose error! :invalid_resource, @sesh.errors
    end
  end

  # PATCH/PUT /seshes/1
  # PATCH/PUT /seshes/1.json
  def update
    @sesh = Sesh.find(params[:id])

    unless @sesh
      error! :not_found
      return
    end

    if @sesh.update(editable_sesh_params)
      expose @sesh
    else
      expose error! :invalid_resource, @sesh.errors
    end
  end

  # DELETE /seshes/1
  # DELETE /seshes/1.json
  def destroy
    @sesh = Sesh.find(params[:id])

    if @sesh
      @sesh.destroy
      head :no_content
    else
      error! :not_found
    end
  end

  private

    def new_sesh_params
      params.required(:sesh).permit(:title,
                                    :author_id,
                                    :asset['audio']
                                    )
    end

    def editable_sesh_params
      params.required(:sesh).permit(:title)
    end
end
