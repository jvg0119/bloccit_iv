class FavoriteMailer < ApplicationMailer

  default from:  "joeemail@email.com"

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

     mail(to: user.email, subject: "New comment on #{post.title}")
   end

   def new_post(post)

     headers["Message-ID"] = "post/#{post.id}@bloccit_iv.example>"
     headers["In-Reply-To"] = "<post/#{post.id}@bloccit_iv.example>"
     headers["References"] = "<post/#{post.id}@bloccit_iv.example>"

     @post = post

     mail(to: post.user.email, subject: "Your new post #{post.title}")

   end


end
