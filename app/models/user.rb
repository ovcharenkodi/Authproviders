class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :nickname, :provider, :url, :username, :token

  def self.find_for_facebook_oauth access_token
    if user = User.where(:url => access_token.info.urls.Facebook).first
      user.token = access_token.credentials.token 
      user
    else 
      User.create!(:provider => access_token.provider, 
                   :url => access_token.info.urls.Facebook, 
                   :username => access_token.extra.raw_info.name, 
                   :nickname => access_token.extra.raw_info.username,
                   :token => access_token.credentials.token,
                   :email => access_token.extra.raw_info.email, 
                   :password => Devise.friendly_token[0,20]) 
    end
  end

  def self.find_for_vkontakte_oauth access_token
    puts "-----------------------------------------------+++++++"
    puts access_token

    if user = User.where(:url => access_token.info.urls.Vkontakte).first
      user.token = access_token.credentials.token
      user
    else 
      User.create!(:provider => access_token.provider, 
                   :url => access_token.info.urls.Vkontakte, 
                   :username => access_token.info.name,
                   :token => access_token.credentials.token,
                   :nickname => access_token.extra.raw_info.domain,
                   :email => access_token.extra.raw_info.uid.to_s + '@vk.com',
                   :password => Devise.friendly_token[0,20]) 
    end
  end

 def getfriends
   friends =[]
   if self.provider == "facebook"
     user = FbGraph::User.me(self.token)
     user.friends.each do |f| 
       friends << f.name
     end
   else 
     vk = VkontakteApi::Client.new(self.token)
     vk.friends.get(fields: [:first_name, :last_name]).each do |f|
       friends << "#{f.first_name} #{f.last_name}"  
     end
   end  
   friends
 end
 
end
