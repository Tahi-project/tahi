class AssignTeamOverlay < CardOverlay

  def self.visit(assign_team_task, &blk)
    page.visit "/papers/#{assign_team_task.paper.id}/tasks/#{assign_team_task.id}"
    wait_for_ajax

    new.tap do |overlay|
      if block_given?
        find(".overlay-container .overlay-content")
        blk.call overlay
        wait_for_ajax
        overlay.dismiss
      end
    end
  end

  def assign_role_for_user(role_name, user)
    find(".invite-reviewers")

    select2 role_name, from: "Role"
    wait_for_ajax

    select2 user.full_name, from: "User"
    wait_for_ajax

    click_button "Assign"
  end

  def unassign_user(user)
    trash_icon = find(".invitation", text: user.full_name).find(".invite-reviewer-remove")
    trash_icon.click
    wait_for_ajax
  end

end
