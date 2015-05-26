class ExtensionsController < ApplicationController
  def status
    @extensions = Extension.status    
    respond_to do |format|
      format.json { render json: @extensions }
      format.xml
    end
  end
  
  def peers
    @peers = Extension.peers
    respond_to do |format|
      format.json { render json: @peers }
      format.xml
    end
  end
end
