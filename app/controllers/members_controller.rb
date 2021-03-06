class MembersController < ApplicationController

  def index
    @members = Member.all.order(rank: :asc)
    @peopleImages = PeopleImage.all

    # current members data
    @kim_andrezza = Member.filterByRank(0,false)
    @visiting_scholars = Member.filterByRank(1,true)
    @postdocs = Member.filterByRank(2,true)
    @phd_students = Member.filterByRank(3,true)
    msc_students = Member.filterByRank(4,true)
    undergrad_students = Member.filterByRank(5,true)    
    @msc_undergrad_students = msc_students + undergrad_students

    # former members data
    @former_grad_students = FormerMember.filterMembers(:phd_student, :msc_student)
    @former_postdocs = FormerMember.filterMembers(:postdoc, nil)
    @former_visiting_scholars = FormerMember.filterMembers(:visiting_scholar, nil)
    @former_undergrad_students = FormerMember.filterMembers(:undergrad_student, nil)
  end

  def show
    id = params[:id]
    @member = Member.find_by_id(id)
    if @member == nil
      flash[:danger] = "Member not found"
      redirect_to members_path
    end
  end

  def new
    # only renders 'new' view
  end

  def edit
    id = params[:id]
    @member = Member.find_by_id(id)
    if @member == nil
      flash.now[:danger] = "Member not found"
      redirect_to members_path
    end
  end

  def create
    # generates a temporary password and create user
    temp_password = generate_random_password()
    
    is_admin = (params[:is_admin] == "1" || params[:is_admin] == "on") ? true : false
    @user = User.new(:username => params[:username], :is_admin => is_admin, :email => params[:email], 
                       :password => temp_password, :password_confirmation => temp_password)

    if @user.save
      begin
        @user.send_activation_email
        flash[:info] = "An e-mail has been sent to the member so that the account can be activated."

        # writing image to the NFS
        avatar_path = Member.write_to_filesystem(params[:avatar], 'uploads/images/')
        
        # writing cv to the NFS
        cv_path = Member.write_to_filesystem(params[:cv], 'uploads/cv/')
      
        is_listed = (params[:is_listed] == "1" || params[:is_listed] == "on") ? true : false
      
        # creating member
        member = Member.create(:name => params[:name], :last_name => params[:last_name], :position => params[:position],
                               :telephone => params[:telephone], :fax => params[:fax],
                               :is_listed => is_listed,
                               :previous_affiliation => params[:previous_affiliation], :bio => params[:bio], 
                               :interests => params[:interests], :birthplace => params[:birthplace], :building => params[:building],
                               :office => params[:office], :rank => params[:rank].to_i,
                               :link => params[:link], :avatar_path => avatar_path, :cv_path => cv_path)
      
        @user.update_attribute(:member, member)
      
        # removing temp files
        try_delete_tempfile(params[:avatar])
        try_delete_tempfile(params[:cv])
      
        # redirect to the created member page
        redirect_to members_path
      rescue Exception => ex
        @user.destroy
        flash[:danger] = "#{ex}"
        redirect_to root_path
      end
    else
      flash[:danger] = "The account could not be created. Please try again."
      redirect_to new_member_path
    end

  end

  def update
    member = Member.find(params[:id])

    is_admin = (params[:is_admin] == "1" || params[:is_admin] == "on") ? true : false
    member.user.update_attribute(:is_admin, is_admin)

    # writing avatar and cv to the NFS
    if params[:avatar] != nil
      avatar_path = Member.write_to_filesystem(params[:avatar], 'uploads/images/')
      params[:avatar_path] = avatar_path
    end

    if params[:cv] != nil
      cv_path = Member.write_to_filesystem(params[:cv], 'uploads/cv/')
      params[:cv_path] = cv_path
    end
   
    if logged_in? && current_user_admin? 
      is_listed = (params[:is_listed] == "1" || params[:is_listed] == "on") ? true : false
      params[:is_listed] = is_listed
      params[:rank] = params[:rank].to_i
    end

    member.update_attributes(params)

    # removing temp files
    try_delete_tempfile(params[:avatar])
    try_delete_tempfile(params[:cv])

    # redirecting to profile
    redirect_to member_path(member)
  end

  def destroy
    member = Member.find(params[:id])
    if member != nil
      if logged_in? && current_user.id == member.user.id
        log_out
      end
      member.user.destroy
      member.destroy
      flash[:info] = "Member #{member.user.username} deleted successfully"
    end
    redirect_to members_path
  end

  # if there's a temporary file, then delete it
  def try_delete_tempfile(file)
    if file != nil
      tempfile = file.tempfile.path
      if File::exists?(tempfile)
       File::delete(tempfile)
      end
    end
  end

  # generates a random password with size 10
  def generate_random_password
    alphabet = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    return (0...10).map { alphabet[rand(alphabet.length)] }.join
  end

end
