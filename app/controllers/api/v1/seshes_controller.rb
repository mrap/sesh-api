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

    expose @sesh
  end

  # POST /seshes
  # POST /seshes.json
  def create
    @sesh = Sesh.new(params[:sesh])

    if @sesh.save
      render json: @sesh, status: :created, location: @sesh
    else
      render json: @sesh.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /seshes/1
  # PATCH/PUT /seshes/1.json
  def update
    @sesh = Sesh.find(params[:id])

    if @sesh.update(params[:sesh])
      head :no_content
    else
      render json: @sesh.errors, status: :unprocessable_entity
    end
  end

  # DELETE /seshes/1
  # DELETE /seshes/1.json
  def destroy
    @sesh = Sesh.find(params[:id])
    @sesh.destroy

    head :no_content
  end
end
