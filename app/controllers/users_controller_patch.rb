module UsersControllerPatch
  def self.included(base)
    base.class_eval do

      def edit_membership
        @membership = Member.edit_membership(params[:membership_id], params[:membership], @user)
        @membership.save
        respond_to do |format|
          format.html { redirect_to edit_user_path(@user, :tab => 'memberships') }
          format.js
        end
      end

      def destroy_membership
        @membership = Member.find(params[:membership_id])
        if @membership.deletable?
          @membership.destroy
        end
        respond_to do |format|
          format.html { redirect_to edit_user_path(@user, :tab => 'memberships') }
          format.js
        end
      end

    end
  end
end

UsersController.send(:include, UsersControllerPatch)