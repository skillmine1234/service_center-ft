require 'will_paginate/array'

class IncomingFilesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json, :html
  include IncomingFileHelper

  def new
    @incoming_file = IncomingFile.new
  end

  def create
    @incoming_file = IncomingFile.new(params[:incoming_file])
    if @incoming_file.save
      flash[:alert] = "File is successfully uploaded and is pending for approval"
      redirect_to incoming_files_path
    else
      flash[:notice] = @incoming_file.errors.full_messages
      render :new
    end
  end

  def index
    if params[:advanced_search].present?
      incoming_files = find_incoming_files(params).order("id desc")
    else
      incoming_files = (params[:approval_status].present? and params[:approval_status] == 'U') ? IncomingFile.unscoped.where("approval_status =?",'U').order("id desc") : IncomingFile.order("id desc")
    end
    @files_count = incoming_files.count
    @incoming_files = incoming_files.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def view_raw_content
    puts "----- in view_raw_content (incoming_files controller) -----"
    puts "-- starts --"
    @incoming_file = IncomingFile.unscoped.find_by_id(params[:id])
    @file_abs_url = "#{Rails.root}/public#{@incoming_file.file.url}"
    puts "@file_abs_url (check for file path, coming from env var) :- "
    puts @file_abs_url
    puts "-- ends --"
    File.exists?(@file_abs_url) ? @raw_file_content = %x(cat -ne #{@file_abs_url}) : @raw_file_content = nil
    @result = {filename: @incoming_file.file_name, content: @raw_file_content}
    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end

  def show
    @incoming_file = IncomingFile.unscoped.find_by_id(params[:id])
  end

  def destroy
    @incoming_file = IncomingFile.unscoped.find_by_id(params[:id])
    if @incoming_file.status == "N"
      if @incoming_file.destroy
        FileUtils.rm_f @incoming_file.file.path
      end
    else
      flash[:alert] = "delete is disabled since the file has already been proccessed"
    end
    redirect_to incoming_files_path(:approval_status => 'U')
  end

  def approve
    @incoming_file = IncomingFile.unscoped.find(params[:id]) rescue nil 
    IncomingFile.transaction do
      approval = @incoming_file.approve
      if @incoming_file.save and approval.empty?
        move_incoming_file(@incoming_file)
        flash[:alert] = "Incoming File record was approved successfully"
      else
        msg = approval.empty? ? @incoming_file.errors.full_messages : @incoming_file.errors.full_messages << approval
        flash[:alert] = msg
        raise ActiveRecord::Rollback
      end
    end
    redirect_to @incoming_file
  end

  def incoming_file_params
    params.require(:incoming_file).permit(:file, :size_in_bytes, :line_count, :created_by, :updated_by, :status,
                  :lock_version, :file_name, :file_type, :service_name)
  end
end