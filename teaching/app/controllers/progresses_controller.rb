class ProgressesController < ApplicationController

  before_filter :authenticate_user!
  
  def show
    progresses = Progress.where(user_id: current_user.id).map(&:chapter_id)
    course_chapters = Course.find(params[:course_id]).chapters
    completed_chapters = Course.find(params[:course_id]).chapters.where(id: progresses)
    completed_chapters = completed_chapters.each{|c| c.completed = true}
    chapters = course_chapters - course_chapters.where(id: progresses)
    final = chapters + completed_chapters
    render json: final.sort_by!(&:id)
  end

  def create
    @progress = Progress.create(
      :user_id => current_user.id,
      :chapter_id => params[:chapter_id]
      )
    render json: { progress: @progress }
  end 

  def delete
    @progress = Progress.where("user_id = ? AND chapter_id = ?", current_user.id, params[:chapter_id])
    @progress.first.destroy
    render json: @progress
  end


end

# 1 - We find all the progresses associated to the current_user and map all the chapters id's. In other words, we are fetching all the completed chapters from the current_user(Line 6).

# 2 - We fetch all the chapters from the respective course through the parameter :course_id passed in with the request (Line 7).

# 3 - We fetch all the completed chapters from that same course (Line 8).

# 4 - Now that we have a variable - completed_chapters - with all the completed chapters from the course we set the complete attribute to true on each of them (Line 9).

# 5 - Next we remove all the completed chapters from the array that contains all the chapters (Line 10).

# 6 - We get a variable - chapters - which contains all the chapters that are not completed. We just need to add the array - completed_chapters - which  have the completed attribute set to true. Basically we end up with an array of all the chapters of the course. The ones we've completed have the completed attribute set to true and the ones that are not have it set to false (Line 11).

# 7 - Finally, we just need to order/sort the records by :id (Line12).