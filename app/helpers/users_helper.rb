module UsersHelper
  def choose_create_or_edit
    if action_name == 'create'
      confirm_users_path
    elsif action_name == 'edit'
      user_path
    end
  end
end
