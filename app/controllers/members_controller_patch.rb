module MembersControllerPatch
  def self.included(base)
    base.class_eval do

      def create
        members = []
        invite = false

        if params[:membership]
          if params[:email]
            if User.joins(:email_address).where(email_addresses: { address: params[:email] }).empty?
              password = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
              u = User.new(mail: params[:email], firstname: "tbd", lastname: "tbd", :language => current_language.to_s)
              u.login = params[:email]
              u.password = password
              u.firstname = params[:firstname] if params[:firstname]
              u.lastname = params[:lastname] if params[:lastname]

              if u.save
                invite = true
                params[:membership][:user_ids].blank? ? (params[:membership][:user_ids] = [u.id]) : params[:membership][:user_ids] << u.id
                Mailer.account_information(u, password, true, @project.name, User.current.name, @project).deliver
                flash[:notice] = l(:notice_email_sent, params[:email])
              end
            # elsif !User.where(mail: params[:email]).empty?
            #   flash[:error] = l(:notice_existing_user)
            end
          end

          members = []

          if params[:membership]
            user_ids = Array.wrap(params[:membership][:user_id] || params[:membership][:user_ids])
            user_ids << nil if user_ids.empty?

            user_ids.each do |user_id|
              member = Member.new(:project => @project, :user_id => user_id)
              member.set_editable_role_ids(params[:membership][:role_ids])
              members << member

              Mailer.account_information(member.user, "", true, @project.name, User.current.name, @project).deliver
            end

            @project.members << members
          end
        end

        respond_to do |format|
          format.html { redirect_to_settings_in_projects }
          if params[:email] && !User.joins(:email_address).where(email_addresses: { address: params[:email] }).empty?
            format.js { render inline: "location.reload();" }
          else
            format.js { @members = members }
          end
          format.api {
            @member = members.first
            if @member.valid? || invite == true
              render :action => 'show', :status => :created, :location => membership_url(@member)
            elsif !User.where(mail: params[:email]).empty?
              render_validation_errors("Un compte lié à cet email existe déjà.")
            else
              render_validation_errors(@member)
            end
          }
        end
      end

    end
  end
end

MembersController.send(:include, MembersControllerPatch)
