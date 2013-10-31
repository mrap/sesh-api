class Api::V1::SeshesController < ApplicationController

  before_action :get_sesh,            only: [:show, :update, :destroy, :favorite, :add_listener]
  before_action :authenticate_author!, only: [:update, :destroy]

  # GET /seshes
  # GET /seshes.json
  def index
    @seshes = Sesh.all
    @seshes = @seshes.recent if params[:sort_options].include? "recent"
    @seshes = @seshes.anonymous_only if params[:sort_options].include? "anonymous_only"
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
    return unless authenticate_author!

    if  @sesh.save
      render status: :created
    else
      render nothing: true, status: :invalid_resource
    end
  end

  # PATCH/PUT /seshes/1
  # PATCH/PUT /seshes/1.json
  def update
    if @sesh.update(editable_sesh_params)
      render status: :accepted
    else
      render status: :invalid_resource
    end
  end

  # DELETE /seshes/1
  # DELETE /seshes/1.json
  def destroy
    @sesh.destroy
    render status: :accepted
  end

  def favorite
    if @favoriter = User.find_by(authentication_token: params[:favoriter_authentication_token])
      @favoriter.add_sesh_to_favorites(@sesh)
      render status: :accepted
    else
      render status: :unauthorized
    end
  end

  def add_listener
    if @sesh.add_user_id_to_listeners_ids(params[:listener_id])
      render status: :accepted
    else
      render nothing: true, status: :bad_request
    end
  end

  private

    def get_sesh
      unless @sesh = Sesh.find(params[:id])
        render nothing: true, status: :not_found
        return false
      end
    end

    def authenticate_author!
      unless params[:auth_token] == @sesh.author.authentication_token
        render nothing: true, status: :unauthorized
        return false
      else
        return true
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
