class Api::V1::SeshesController < ApplicationController

  version 1

  before_action :get_sesh,            only: [:show, :update, :destroy]
  before_action :authenticate_user!,  only: [:destroy]

  # GET /seshes
  # GET /seshes.json
  def index
    @seshes = Sesh.all

    render json: @seshes
  end

  # GET /seshes/1
  # GET /seshes/1.json
  def show
    if @sesh.is_anonymous
      expose  id:         @sesh.id,
              title:      @sesh.title,
              assets:     { audio_url: @sesh.audio.url }
    else
      expose  id:         @sesh.id,
              title:      @sesh.title,
              author_id:  @sesh.author_id,
              assets:     { audio_url: @sesh.audio.url }
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
    if @sesh.update(editable_sesh_params)
      expose @sesh
    else
      expose error! :invalid_resource, @sesh.errors
    end
  end

  # DELETE /seshes/1
  # DELETE /seshes/1.json
  def destroy
    @sesh.destroy
    head :no_content
  end

  private

    def get_sesh
      if @sesh = Sesh.find(params[:id])
        @sesh
      else
        error! :not_found
      end
    end

    def authenticate_user!
      if params[:authentication_token] != @sesh.author.authentication_token
        error! :unauthenticated
      end
    end

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
