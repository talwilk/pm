require 'rails_helper'

feature 'Managing super admins' do
  let!(:super_admin) { create :super_admin }
  let!(:other_super_admin) { create :super_admin }
  let(:index_page) { Page::SuperAdmin::SuperAdmins::Index.new }
  let(:new_page) { Page::SuperAdmin::SuperAdmins::New.new }
  let(:edit_page) { Page::SuperAdmin::SuperAdmins::Edit.new(super_admin) }
  let(:new_super_admin) { attributes_for(:super_admin) }

  before do
    sign_in(super_admin)
  end

  scenario 'Super admin can see the list of super admins' do
    index_page.visit
    expect(index_page).to have_entry(super_admin)
  end

  scenario 'Super admin can add a new super admin' do
    new_page.visit
    new_page.fill_in({email: '', password: '', password_confirmation: ''})

    expect do
      new_page.save
    end.to change(SuperAdmin, :count).by(0)


    new_page.fill_in(new_super_admin)

    expect do
      new_page.save
    end.to change(SuperAdmin, :count).by(1)
  end

  scenario 'Super admin can edit a super admin' do
    edit_page.visit
    edit_page.fill_in({email: 'new_email_super_admin@example.com'})
    edit_page.save

    expect(super_admin.reload.email).to eq('new_email_super_admin@example.com')
  end

  scenario 'Super admin can destroy a super admin and then bring back' do
    index_page.visit
    expect do
      index_page.destroy(other_super_admin)
    end.to change(SuperAdmin, :count).by(-1)
    expect do
      index_page.bring_back(other_super_admin)
    end.to change(SuperAdmin, :count).by(1)
  end

  scenario 'Super admin can not destroy himself' do
    index_page.visit
    expect do
      index_page.destroy(super_admin)
    end.to change(SuperAdmin, :count).by(0)
  end
end
