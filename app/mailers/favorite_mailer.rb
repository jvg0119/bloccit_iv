class FavoriteMailer < ApplicationMailer

  default from:  "youremail@email.com" 

  def new_comment(user, post, comment)

 # these do not affect email delivery pass/fail
    #  headers["Message-ID"] = "<comments/#{comment.id}@your-app-name.example>"
    #  headers["In-Reply-To"] = "<post/#{post.id}@your-app-name.example>"
    #  headers["References"] = "<post/#{post.id}@your-app-name.example>"


    headers["Message-ID"] = "<comments/#{comment.id}@bloccit_iv.example>"
    headers["In-Reply-To"] = "<post/#{post.id}@bloccit_iv.example>"
    headers["References"] = "<post/#{post.id}@bloccit_iv.example>"


     @user = user
     @post = post
     @comment = comment

 # #19
     mail(to: user.email, subject: "New comment on #{post.title}")
   end


end
