def create_user
    @user = FactoryGirl.create(:user)
end

######################################################################
## Background
######################################################################


Given (/^I am logged in$/) do
    create_user
    visit '/login'
    fill_in "username", :with => @user[:username]
    fill_in "password", :with => @user[:password]
    click_button "login-form-button"
end

Given (/^I exist as a user$/) do
    create_user
end

Given (/^these publications exist:$/) do |table|
    table.hashes.each do |publication|
        Publication.create(publication)
    end
end
Given (/^this user exists:$/) do |table|
    table.hashes.each do |user|
        @user1 = User.create(user)
    end
end

Given (/^this member exists for user "myname":$/) do |table|
    table.hashes.each do |member|
        @member1 = Member.create(member)
    end
    @user1.update_attribute(:member, @member1)
end



Given (/^this group info exist:$/) do |table|
    table.hashes.each do |group_info|
        GroupInfo.create(group_info)
    end
end

##########################################################################
## Action
#########################################################################
When (/^I logout$/) do
    visit '/logout'
end

When (/^I return to the site$/) do
   visit '/'
end

When (/^I choose to add new member$/) do
    visit '/members/new'
end


When(/^I choose to add new group info$/) do
  visit '/group_infos/new'
end

And (/^I upload a picture from "([^"]*)"$/) do |picture|
    path = File.join(::Rails.root, picture) 
    attach_file("avatar", path)
end
And (/^I upload a file from "([^"]*)"$/) do |file|
    path = File.join(::Rails.root, file) 
    attach_file("cv", path)
end

When (/^I click on the picture for "([^"]*)"$/) do |name|
    #click_image(@user1)
    find(".img.member-picture").click
end

Then (/^the personal page for "([^"]*)"$/) do |name|
    member_path(@user1)
end

When(/^I upload a group file from "([^"]*)"$/) do |file|
    path = File.join(::Rails.root, file) 
    attach_file("file", path)
end

############################################################################
## Response
############################################################################
Then (/^I should see a flash "([^"]*)"$/) do |msg|
    page.has_content?(msg)
end

Then (/^I should be logged out$/) do 
    page.should have_content "Login"
    page.should_not have_content "Logout"
end
