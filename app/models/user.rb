# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  user_name              :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  username               :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

	validates :username,
	  :uniqueness => {
	    :case_sensitive => false
	  }

  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :authentication_keys => [:login], :omniauth_providers => [:facebook]
  
  attr_accessor :login

  has_many :posts
  has_and_belongs_to_many :tribes
  has_many :reports
  has_many :activities

  acts_as_tagger
  acts_as_voter

  ## Associations for Follower and following users
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed


  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower


	def self.find_first_by_auth_conditions(warden_conditions)
	  conditions = warden_conditions.dup
	  if login = conditions.delete(:login)
	    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
	  else
	    where(conditions).first
	  end
	end
	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		if relationships.create!(followed_id: other_user.id)

		end
	end

	def unfollow!(other_user)
    	relationships.find_by(followed_id: other_user.id).destroy
    end

    def recent_activities(limit)
	    activities.order('created_at DESC').limit(limit)
    end


	  	def self.find_for_oauth(auth, signed_in_resource = nil)

	    # Get the identity and user if they exist
	    identity = Identity.find_for_oauth(auth)

	    # If a signed_in_resource is provided it always overrides the existing user
	    # to prevent the identity being locked with accidentally created accounts.
	    # Note that this may leave zombie accounts (with no associated identity) which
	    # can be cleaned up at a later date.
	    user = signed_in_resource ? signed_in_resource : identity.user

	    # Create the user if needed
	    if user.nil?

	      # Get the existing user by email if the provider gives us a verified email.
	      # If no verified email was provided we assign a temporary email and ask the
	      # user to verify it on the next step via UsersController.finish_signup
	      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
	      email = auth.info.email 
   	      #email = auth.info.email if email_is_verified

	      user = User.where(:email => email).first if email

	      # Create the user if it's a new registration
	      if user.nil?
	        user = User.new(
	          username: auth.extra.raw_info.name,
	          #username: auth.info.nickname || auth.uid,
	          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
	          password: Devise.friendly_token[0,20]
	        )
	        user.skip_confirmation!
	        user.save!
	      end
	    end

	    # Associate the identity with the user if needed
	    if identity.user != user
	      identity.user = user
	      identity.save!
	    end
	    user
	  end

	  def email_verified?
	    self.email && self.email !~ TEMP_EMAIL_REGEX
	  end
 end
