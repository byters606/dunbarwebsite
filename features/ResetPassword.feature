Feature: Password Reset
  In order to retrieve a lost password
  As a user of this site
  I want to reset it

  Scenario: Reset password
    Given I am not logged in
    And a user exists with email: "xuesuxiao@gmail.com", password: "xiaoxuesu123"
    And I am on the login page
    Then I should see "Forgot my password"
    When I follow "Forgot my password"
    Then I should see "Recover your account"
    And I should see "An e-mail is going to be sent to your e-mail with the instructions about how to recover your account"
    When I fill in "Please enter your e-mail" with "xuesuxiao@gmail.com"
    And I press "Send"
    Then I should see "Email sent with password reset instructions"
    And "xuesuxiao@gmail.com" should have an email
    When I open the email
    Then I should see "Password reset" in the email body
    When I follow "Reset password" in the email
    Then I should see "Reset Password"
    When I fill in "password" with "xiaoxuesu456"
    And I fill in "Confirm Password" with "xiaoxuesu456"
    And I press "Update password"
    Then I should see "Password reset successfully!"
    When I am not logged in
    Then I should be able to log in with email "xuesuxiao@gmail.com" and password "xiaoxuesu456"

  Scenario: Reset password no account
    Given I am not logged in
    And I am on the login page
    Then I should see "Forgot my password"
    When I follow "Forgot my password"
    Then I should see "Recover your account"
    And I should see "An e-mail is going to be sent to your e-mail with the instructions about how to recover your account"
    When I fill in "Please enter your e-mail" with "xiaoxuesu@gmail.com"
    And I press "Send"
    Then I should see "Email address not found"  
