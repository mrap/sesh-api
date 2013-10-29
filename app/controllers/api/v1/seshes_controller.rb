class Api::V1::SeshesController < ApplicationController

  before_action :get_sesh,            only: [:show, :update, :destroy, :favorite]
  before_action :authenticate_author!,  only: [:update, :destroy]

  # GET /seshes
  # GET /seshes.json
  def index
    @seshes = Sesh.all

    render json: @seshes
  end

  # GET /seshes/1
  # GET /seshes/1.json
  def show
    # implicit :get_sesh
  end

  # POST /seshes
  # POST /seshes.json
  def create
    @sesh = Sesh.new(new_sesh_params)
    authenticate_author!

    if @sesh.save
      @sesh
    else
      render status: :invalid_resource
    end
  end

  # PATCH/PUT /seshes/1
  # PATCH/PUT /seshes/1.json
  def update
    if @sesh.update(editable_sesh_params)
      @sesh
    else
      render status: :invalid_resource
    end
  end

  # DELETE /seshes/1
  # DELETE /seshes/1.json
  def destroy
    @sesh.destroy
    head :no_content
  end

  def favorite
    if @favoriter = User.find_by(authentication_token: params[:favoriter_authentication_token])
      @favoriter.add_sesh_to_favorites(@sesh)
      render :show
    else
      render status: :unauthorized
    end
  end

  private

    def get_sesh
      if @sesh = Sesh.find(params[:id])
        @sesh
      else
        render json: { status: 404 }
      end
    end

    def authenticate_author!
      error! :unauthenticated if params[:auth_token] != @sesh.author.authentication_token
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
