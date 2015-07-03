require 'spec_helper'
require "cancan_matcher"

describe IncomingFilesController do
  include HelperMethods

  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET index" do
    it "assigns all incoming_file as @incoming_files" do
      incoming_file = Factory(:incoming_file, :approval_status => 'A')
      get :index
      assigns(:incoming_files).should eq([incoming_file])
      FileUtils.rm_f 'Test2.exe.txt'
    end

    it "assigns all unapproved incoming_files as @incoming_files when approval_status is passed" do
      incoming_file = Factory(:incoming_file, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:incoming_files).should eq([incoming_file])
      FileUtils.rm_f 'Test2.exe.txt'
    end
  end

  describe "GET show" do
    it "assigns the requested incoming_file as @incoming_file" do
      incoming_file = Factory(:incoming_file)
      get :show, {:id => incoming_file.id}
      assigns(:incoming_file).should eq(incoming_file)
    end
  end

  describe "GET new" do
    it "assigns a new incoming_file as @incoming_file" do
      get :new
      assigns(:incoming_file).should be_a_new(IncomingFile)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new incoming_file" do
        params = Factory.attributes_for(:incoming_file)
        expect {
          post :create, {:incoming_file => params}
        }.to change(IncomingFile.unscoped, :count).by(1)
        flash[:alert].should  match(/File is successfully uploaded/)
        response.should be_redirect
      end

      it "assigns a newly created saving as @incoming_file" do
        params = Factory.attributes_for(:incoming_file)
        post :create, {:incoming_file => params}
        assigns(:incoming_file).should be_a(IncomingFile)
        assigns(:incoming_file).should be_persisted
      end

      it "redirects to the created incoming_file" do
        params = Factory.attributes_for(:incoming_file)
        post :create, {:incoming_file => params}
        response.should redirect_to(:action => :index)
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:incoming_file, :file => nil)
        post :create, {:incoming_file => params}
        response.should render_template("new")
      end
    end
  end

  describe 'DESTROY' do 
    it "should destroy the incoming_file" do 
      incoming_file = Factory(:incoming_file)
      delete :destroy, {:id => incoming_file.id}
      IncomingFile.unscoped.find_by_id(incoming_file.id).should be_nil
    end

    it "should destroy the incoming_file" do 
      incoming_file = Factory(:incoming_file, :status => "I")
      delete :destroy, {:id => incoming_file.id}
      flash[:alert].should  match(/delete is disabled since the file has already been proccessed/)
      IncomingFile.unscoped.find_by_id(incoming_file.id).should_not be_nil
    end
  end

  describe "PUT approve" do
    it "unapproved record can be approved and old approved record will be deleted" do
      @user.role_id = Factory(:role, :name => 'approver').id
      @user.save
      incoming_file1 = Factory(:incoming_file, :approval_status => 'A')
      incoming_file2 = Factory(:incoming_file, :approval_status => 'U', :approved_version => incoming_file1.lock_version, :approved_id => incoming_file1.id)
      put :approve, {:id => incoming_file2.id}
      incoming_file2.reload
      incoming_file2.approval_status.should == 'A'
      IncomingFile.find_by_id(incoming_file1.id).should be_nil
      File.file?(Rails.root.join(ENV['CONFIG_APPROVED_FILE_UPLOAD_PATH'],incoming_file2.file_name)).should == true
      File.file?(incoming_file2.file.path).should == false
    end
  end
end
